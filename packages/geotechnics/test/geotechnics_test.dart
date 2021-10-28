import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:geotechnics/geotechnics.dart';

void main() {
  group('CPT', () {
    final testDirectory = join(
      Directory.current.path,
      Directory.current.path.endsWith('test') ? '' : 'test',
    );

    test('fromFile should read given valid gef file', () async {
      final file = File(join(testDirectory, 'testdata/N04-25.gef'));
      CPT cpt = await CPT.fromFile(file);
      expect(cpt.name, "N04-25");
    });

    test('toJson / fromJson should convert to json and back', () async {
      final file = File(join(testDirectory, 'testdata/N04-25.gef'));
      CPT cpt = await CPT.fromFile(file);
      var json = cpt.toJson();
      CPT cpt2 = CPT.fromJson(json);
      expect(cpt.name, cpt2.name);
      expect(cpt.zs, cpt2.zs);
    });
  });
}
