import 'dart:io';
import 'package:geotechnics/helpers/enum_from_string.dart';
import 'package:geotechnics/helpers/helpers.dart';
import 'package:path/path.dart' as p;

import 'soil_investigation_location.dart';

const int gefColumnZ = 1;
const int gefColumnQc = 2;
const int gefColumnFs = 3;
const int gefColumnU = 6;
const int gefColumnZCorrected = 11;

class CPTReadingException implements Exception {
  final String _message;

  CPTReadingException(this._message);

  @override
  String toString() {
    return _message;
  }
}

class CPT {
  String id;
  final String name;
  final double latitude;
  final double longitude;
  final SoilInvestigationLocation soilInvestigationLocation;
  final double z;
  final String date;
  final List<double> zs;
  final List<double> qc;
  final List<double> fs;
  final List<double> u2;
  final double preExcavatedDepth;
  final double waterLevel;

  CPT(
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.soilInvestigationLocation,
    this.z,
    this.date,
    this.zs,
    this.qc,
    this.fs,
    this.u2,
    this.preExcavatedDepth,
    this.waterLevel,
  );

  static CPT emptyCPT = CPT("", "", 0, 0,
      SoilInvestigationLocation.crestAndPolder, 0, '', [], [], [], [], 0, 0);

  static Future<CPT> fromFile(File file) async {
    try {
      final String fileContent = await file.readAsString();

      final String fileExtension = p.extension(file.path).toLowerCase();

      if (fileExtension == '.csv') {
        throw CPTReadingException('CPT csv reader not implemented yet');
      } else if (fileExtension == '.gef') {
        return CPT.fromGEFString(fileContent);
      } else {
        throw CPTReadingException("Invalid CPT fileformat '$fileExtension'");
      }
    } catch (e) {
      throw CPTReadingException("Undefined error; '$e'");
    }
  }

  factory CPT.fromGEFString(String data) {
    String name = '';
    double longitude = 0.0;
    double latitude = 0.0;
    double z = 0.0;
    String date = '';
    List<double> zs = [];
    List<double> qc = [];
    List<double> fs = [];
    List<double> u2 = [];
    double preExcavatedDepth = 0.0;
    double waterLevel = 0.0;

    final lines = data.split('\n');

    final metadata = {
      "recordSeparator": "",
      "columnSeparator": " ",
    };

    final Map<int, int> columnInfo = {};
    final Map<int, double> columnVoids = {};

    var readingHeader = true;
    for (var i = 0; i < lines.length; i++) {
      String line = lines[i].replaceAll("\n", "").replaceAll("\r", "");

      if (readingHeader) {
        List<String> args = line.split("=");
        final String keyword = args[0].replaceAll(' ', '');
        args = args[1].split(',');

        if (line.contains("#EOH")) {
          readingHeader = false;
        } else if (keyword == "#RECORDSEPARATOR") {
          metadata['recordSeparator'] = args[0].replaceAll(" ", "");
        } else if (keyword == "#COLUMNSEPARATOR") {
          metadata['columnSeparator'] = args[0].replaceAll(" ", "");
        } else if (keyword == '#MEASUREMENTVAR') {
          final int code = int.parse(args[0]);

          switch (code) {
            case 13:
              preExcavatedDepth = double.parse(args[1]);
              break;
            case 14:
              waterLevel = double.parse(args[1]);
              break;
          }
        } else if (keyword == "#COLUMNINFO") {
          try {
            final int column = int.parse(args[0]);
            int dtype = int.parse(args[3]);
            if (dtype == gefColumnZCorrected) {
              dtype = gefColumnZ;
            }
            columnInfo[dtype] = column - 1;
          } catch (e) {
            throw CPTReadingException("Error reading #COLUMNINFO; '$e'");
          }
        } else if (keyword == "#XYID") {
          try {
            var x = double.parse(args[1]);
            var y = double.parse(args[2]);

            // convert to latlon
            final point = rdToWGS84(x, y);
            latitude = point.y;
            longitude = point.x;
          } catch (e) {
            throw CPTReadingException("Error reading #XYID; '$e'");
          }
        } else if (keyword == "#REPORTCODE" || keyword == "#PROCEDURECODE") {
          if (args[0].toUpperCase().contains('BORE')) {
            throw CPTReadingException("Trying to read a borehole GEF as a CPT");
          }
        } else if (keyword == "#ZID") {
          try {
            z = double.parse(args[1]);
          } catch (e) {
            throw CPTReadingException("Error reading #ZID; '$e'");
          }
        } else if (keyword == "#COLUMNVOID") {
          try {
            final int col = int.parse(args[0]);
            columnVoids[col - 1] = double.parse(args[1]);
          } catch (e) {
            throw CPTReadingException("Error reading #COLUMNVOID; '$e'");
          }
        } else if (keyword == "#TESTID") {
          name = args[0].trim();
        } else if (keyword == "#FILEDATE") {
          try {
            final int yyyy = int.parse(args[0]);
            final int mm = int.parse(args[1]);
            final int dd = int.parse(args[2]);
            date = "$yyyy-$mm-$dd";
          } catch (e) {
            throw CPTReadingException("Error reading #FILEDATE; '$e'");
          }
        } else if (keyword == "#STARTDATE") {
          try {
            final int yyyy = int.parse(args[0]);
            final int mm = int.parse(args[1]);
            final int dd = int.parse(args[2]);
            date = "$yyyy-$mm-$dd";
          } catch (e) {
            throw CPTReadingException("Error reading #STARTDATE; '$e'");
          }
        }
      } else {
        // READING DATALINES
        line = line.replaceAll(metadata['recordSeparator']!, '');
        line = line.replaceAll('\r', '');
        final List<String> args = line.split(metadata['columnSeparator']!);
        args.removeWhere((element) => element == "");

        if (args.isNotEmpty) {
          final List<double> fargs = [
            for (var j = 0; j < args.length; j++) double.parse(args[j])
          ];

          // skip columnvoids
          bool hasColumnVoid = false;
          columnVoids.forEach((key, value) {
            hasColumnVoid |= fargs[key] == value;
          });

          if (!hasColumnVoid) {
            final int zcolumn = columnInfo[gefColumnZ]!;
            final int qccolumn = columnInfo[gefColumnQc]!;
            final int fscolumn = columnInfo[gefColumnFs]!;
            int ucolumn = -1;
            if (columnInfo.keys.contains(gefColumnU)) {
              ucolumn = columnInfo[gefColumnU]!;
            }

            zs.add(z - fargs[zcolumn].abs());

            var newqc = fargs[qccolumn];
            if (newqc <= 0) newqc = 1e-3;
            qc.add(newqc);

            var newfs = fargs[fscolumn];
            if (newfs < 1e-6) newfs = 1e-6;
            fs.add(newfs);

            if (ucolumn > -1) u2.add(fargs[ucolumn]);
          }
        }
      }
    }

    return CPT(
        "",
        name,
        latitude,
        longitude,
        SoilInvestigationLocation.crestAndPolder,
        z,
        date,
        zs,
        qc,
        fs,
        u2,
        preExcavatedDepth,
        waterLevel);
  }

  factory CPT.fromJson(dynamic json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    double latitude = json['latitude'] as double;
    double longitude = json['longitude'] as double;

    SoilInvestigationLocation soilInvestigationLocation = enumFromString(
        SoilInvestigationLocation.values,
        json['soilInvestigationLocation'].toString());
    double z = json['z'] as double;
    String date = json['date'] as String;
    List<double> zs = (json['zs'] as List).map((e) => e as double).toList();
    List<double> qc = (json['qc'] as List).map((e) => e as double).toList();
    List<double> fs = (json['fs'] as List).map((e) => e as double).toList();
    List<double> u2 = (json['u2'] as List).map((e) => e as double).toList();
    double preExcavatedDepth = json['preExcavatedDepth'] as double;
    double waterLevel = json['waterLevel'] as double;

    return CPT(id, name, latitude, longitude, soilInvestigationLocation, z,
        date, zs, qc, fs, u2, preExcavatedDepth, waterLevel);
  }

  factory CPT.empty() {
    return emptyCPT;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'soilInvestigationLocation': soilInvestigationLocation.toString(),
      'z': z,
      'date': date,
      'zs': zs,
      'qc': qc,
      'fs': fs,
      'u2': u2,
      'preExcavatedDepth': preExcavatedDepth,
      'waterLevel': waterLevel,
    };
  }
}
