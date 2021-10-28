import 'dart:async';

import 'package:geotechnics/models/models.dart';
import 'package:geotechnics_database/models/models.dart';

abstract class Repository {
  Future<String> addCPT(CPT cpt);
  Future<String> deleteCPT(String cptId);
  Future<List<CPT>> cpts();
  Future<CPT?> cptById(String id);
  Future<void> updateCPT(CPT cpt);
  Future<int> deleteAllCPTs();

  Future<String> addProject(String userId, Project project);
  Future<String> deleteProject(String projectId);
  Future<List<Project>> projects(String userId);
  Future<Project?> projectById(String id);
  Future<void> updateProject(Project project);
  Future<int> deleteAllProjectsFromUser(String userId);
}
