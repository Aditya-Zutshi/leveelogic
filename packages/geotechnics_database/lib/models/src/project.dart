class Project {
  // a unique id for the database
  String id;
  // link to the user
  String userId;
  // the name of the project
  String name;
  // a description of the project
  String description;
  // a list of ids of collaborators to the project
  List<String> collaboratorIds;
  // a list of CPT ids
  List<String> cptIds;

  Project(
    this.id,
    this.userId,
    this.name,
    this.description,
    this.collaboratorIds,
    this.cptIds,
  );

  static Project emptyProject = Project("", "", "", "", [], []);

  factory Project.fromJson(dynamic json) {
    String id = json['id'] as String;
    String userId = json['userId'] as String;
    String name = json['name'] as String;
    String description = json['description'] as String;
    List<String> collaboratorIds =
        (json['collaboratorIds'] as List).map((e) => e as String).toList();
    List<String> cptIds =
        (json['cptIds'] as List).map((e) => e as String).toList();

    return Project(id, userId, name, description, collaboratorIds, cptIds);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'collaboratorIds': collaboratorIds,
      'cptIds': cptIds,
    };
  }
}
