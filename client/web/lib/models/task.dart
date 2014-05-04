part of models;

class TaskModel {
  String name;
  String type;  // nfs or manual
  bool state;
  String desc;
  int points;
  
  TaskModel();

  TaskModel.fromJson(Map json) {
    name = json["name"];
    type = json["type"];
    state = json["state"];
    desc = json["desc"];
    points = json["points"];
  }
  
  Map toJson() {
    return {
      "name": name,
      "type": type,
      "state": state,
      "desc": desc,
      "points": points
    };
  }
}

