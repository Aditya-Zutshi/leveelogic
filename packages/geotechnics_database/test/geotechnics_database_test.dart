import 'dart:io';
import 'dart:math';

import 'package:geotechnics_database/geotechnics_repository.dart';
import 'package:geotechnics_database/models/models.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:geotechnics/geotechnics.dart';

void main() {
  group('CPTRepository', () {
    final testDirectory = join(
      Directory.current.path,
      Directory.current.path.endsWith('test') ? '' : 'test',
    );

    test('addCPT should add CPT to the database', () async {
      SembastRepository repository = SembastRepository();
      List<CPT> cpts = await repository.cpts();
      var initialLength = cpts.length;
      final file = File(join(testDirectory, 'testdata/N04-25.gef'));
      CPT cpt = await CPT.fromFile(file);
      await repository.addCPT(cpt);
      cpts = await repository.cpts();
      expect(cpts.length, initialLength + 1);
    });

    test('deleteCPT should delete a CPT from the database', () async {
      SembastRepository repository = SembastRepository();
      CPT cpt = CPT.emptyCPT;
      String expectedKey = await repository.addCPT(cpt);
      String deletedKey = await repository.deleteCPT(cpt.id);
      expect(deletedKey, expectedKey);
    });

    test('deleteCPT invalid key should not break code', () async {
      SembastRepository repository = SembastRepository();
      CPT cpt = CPT.emptyCPT;
      await repository.addCPT(cpt);
      cpt.id = 'nonsense';
      String deletedKey = await repository.deleteCPT(cpt.id);
      expect(deletedKey, '');
    });

    test('cptById should return a valid CPT', () async {
      SembastRepository repository = SembastRepository();
      CPT cpt = CPT.emptyCPT;
      await repository.addCPT(cpt);
      CPT? cpt2 = await repository.cptById(cpt.id);
      expect(cpt.id, cpt2!.id);
    });

    test('cptById with invalid id should return null', () async {
      SembastRepository repository = SembastRepository();
      CPT cpt = CPT.emptyCPT;
      await repository.addCPT(cpt);
      cpt.id = 'nonsense';
      CPT? cpt2 = await repository.cptById(cpt.id);
      expect(cpt2, null);
    });

    test('updateCPT should update the CPT', () async {
      SembastRepository repository = SembastRepository();
      CPT cpt = CPT.emptyCPT;
      await repository.addCPT(cpt);
      cpt.zs.add(1.0);
      await repository.updateCPT(cpt);
      CPT? cpt2 = await repository.cptById(cpt.id);
      expect(cpt.zs.length, cpt2!.zs.length);
    });

    test('deleteAllCPTs should clear the CPT store', () async {
      SembastRepository repository = SembastRepository();
      await repository.deleteAllCPTs();
      List<CPT> cpts = await repository.cpts();
      expect(cpts.length, 0);
    });
  });

  /*
   * PROJECTS
   */
  group('ProjectRepository', () {
    const String fakeUserId = 'fakeUserId';

    test('deleteAllProjectsFromUser should clear the Project store', () async {
      SembastRepository repository = SembastRepository();
      String projectId =
          await repository.addProject(fakeUserId, Project.emptyProject);
      await repository.deleteAllProjectsFromUser(fakeUserId);
      List<Project> projects = await repository.projects(fakeUserId);
      expect(projects.length, 0);

      //TODO should also cleanup cpts owned by the user!
    });

    test('addProject should add Project to the database', () async {
      SembastRepository repository = SembastRepository();
      List<Project> projects = await repository.projects(fakeUserId);
      var initialLength = projects.length;
      await repository.addProject(fakeUserId, Project.emptyProject);
      projects = await repository.projects(fakeUserId);
      expect(projects.length, initialLength + 1);
    });

    test('deleteProject should delete an individual project', () async {
      SembastRepository repository = SembastRepository();
      await repository.deleteAllProjectsFromUser(fakeUserId);
      Project project = Project.emptyProject;
      String expectedId = await repository.addProject(fakeUserId, project);
      String deletedId = await repository.deleteProject(project.id);
      expect(expectedId, deletedId);
    });

    test('projects should return the projects of the given user', () async {
      SembastRepository repository = SembastRepository();
      await repository.deleteAllProjectsFromUser(fakeUserId);
      await repository.addProject(fakeUserId, Project.emptyProject);
      List<Project> projects = await repository.projects(fakeUserId);
      expect(projects.length, 1);
    });

    test('projectById should return the project', () async {
      SembastRepository repository = SembastRepository();
      String expectedId =
          await repository.addProject(fakeUserId, Project.emptyProject);
      Project? project = await repository.projectById(expectedId);
      expect(project!.id, expectedId);
    });

    test('updateProject should update the project', () async {
      SembastRepository repository = SembastRepository();
      Project project = Project.emptyProject;
      String id = await repository.addProject(fakeUserId, project);
      project.cptIds = ["fakeCptId"];
      await repository.updateProject(project);
      Project? project2 = await repository.projectById(id);
      expect(project2!.cptIds, project.cptIds);
    });

    test('deleteProject with cpt data should clear project and associated cpts',
        () async {
      SembastRepository repository = SembastRepository();
      // start without cpts
      await repository.deleteAllCPTs();
      // add project with cpt
      Project project = Project.emptyProject;
      CPT cpt = CPT.emptyCPT;
      String cptId = await repository.addCPT(cpt);
      project.cptIds.add(cptId);
      String projectId = await repository.addProject(fakeUserId, project);

      // check if we have 1 cpt in the database
      List<CPT> cpts = await repository.cpts();
      expect(cpts.length, 1);

      // delete the project and expect 0 cpts now
      await repository.deleteProject(projectId);
      cpts = await repository.cpts();
      expect(cpts.length, 0);
    });
  });
}
