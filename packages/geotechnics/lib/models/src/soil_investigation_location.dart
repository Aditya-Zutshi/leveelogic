import 'package:flutter/material.dart';

enum SoilInvestigationLocation {
  crest,
  polder,
  crestAndPolder,
}

Map<SoilInvestigationLocation, String> mapSoilInvestigationLocationName = {
  SoilInvestigationLocation.crest: 'crest',
  SoilInvestigationLocation.polder: 'polder',
  SoilInvestigationLocation.crestAndPolder: 'crest and polder',
};

Map<SoilInvestigationLocation, Color> mapSoilInvestigationLocationColor = {
  SoilInvestigationLocation.crest: Colors.cyan.shade200,
  SoilInvestigationLocation.polder: Colors.green.shade200,
  SoilInvestigationLocation.crestAndPolder: Colors.red.shade200
};

SoilInvestigationLocation? getSoilInvestigationLocationFromString(
  String soilInvestigationLocationAsString,
) {
  for (final sil in SoilInvestigationLocation.values) {
    if (sil.toString() == soilInvestigationLocationAsString) {
      return sil;
    }
  }
  throw "Unknown soil investigation location '$soilInvestigationLocationAsString' found";
}
