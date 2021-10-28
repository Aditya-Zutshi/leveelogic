import 'package:geotechnics/models/src/cpt.dart';
import 'package:geotechnics_database/models/src/project.dart';
import 'package:geotechnics_database/src/databases/sembast_database.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import 'repository.dart';

class SembastRepository implements Repository {
  static const String cptStoreName = 'cpts';
  static const String projectStoreName = 'projects';

  final _cptStore = stringMapStoreFactory.store(cptStoreName);
  final _projectStore = stringMapStoreFactory.store(projectStoreName);
  Future<Database> get _db async => await SembastDatabase.instance.database;

  /*
   * CPTS
   */
  @override
  Future<String> addCPT(CPT cpt) async {
    var uuid = const Uuid();
    cpt.id = uuid.v4();
    await _cptStore.record(cpt.id).put(await _db, cpt.toJson());
    return cpt.id;
  }

  @override
  Future<List<CPT>> cpts() async {
    final recordSnapshots = await _cptStore.find(await _db);

    return recordSnapshots.map((snapshot) {
      final cpt = CPT.fromJson(snapshot.value);
      return cpt;
    }).toList();
  }

  @override
  Future<String> deleteCPT(String cptId) async {
    try {
      return await _cptStore.record(cptId).delete(await _db);
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> updateCPT(CPT cpt) async {
    final finder = Finder(filter: Filter.byKey(cpt.id));
    await _cptStore.update(
      await _db,
      cpt.toJson(),
      finder: finder,
    );
  }

  @override
  Future<CPT?> cptById(String id) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshot = await _cptStore.findFirst(await _db, finder: finder);

    if (recordSnapshot == null) {
      return null;
    }
    return CPT.fromJson(recordSnapshot.value);
  }

  @override
  Future<int> deleteAllCPTs() async {
    return await _cptStore.delete(await _db);
  }

  /*
   * PROJECTS
   */
  @override
  Future<String> addProject(String userId, Project project) async {
    var uuid = const Uuid();
    project.id = uuid.v4();
    project.userId = userId;
    await _projectStore.record(project.id).put(await _db, project.toJson());
    return project.id;
  }

  @override
  Future<List<Project>> projects(String userId) async {
    final finder = Finder(filter: Filter.equals('userId', userId));
    final recordSnapshots = await _projectStore.find(await _db, finder: finder);
    return recordSnapshots.map((snapshot) {
      final project = Project.fromJson(snapshot.value);
      return project;
    }).toList();
  }

  @override
  Future<int> deleteAllProjectsFromUser(String userId) async {
    List<Project> projectsToDelete = await projects(userId);
    for (int i = 0; i < projectsToDelete.length; i++) {
      await deleteProject(projectsToDelete[i].id);
    }
    return projectsToDelete.length;
  }

  @override
  Future<String> deleteProject(String projectId) async {
    Project? project = await projectById(projectId);

    if (project == null) {
      return '';
    }

    // clear all CPTs
    for (int i = 0; i < project.cptIds.length; i++) {
      deleteCPT(project.cptIds[i]);
    }

    try {
      return await _projectStore.record(projectId).delete(await _db);
    } catch (_) {
      return '';
    }
  }

  @override
  Future<Project?> projectById(String id) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshot =
        await _projectStore.findFirst(await _db, finder: finder);

    if (recordSnapshot == null) {
      return null;
    }
    return Project.fromJson(recordSnapshot.value);
  }

  @override
  Future<void> updateProject(Project project) async {
    final finder = Finder(filter: Filter.byKey(project.id));
    await _projectStore.update(
      await _db,
      project.toJson(),
      finder: finder,
    );
  }
}
