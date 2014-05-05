part of models;

class TaskModel {
  String name;
  String type;  // nfs or manual
  bool state;
  bool review;
  String desc;
  String assignee;
  int points;
  
  TaskModel();

  TaskModel.fromJson(Map json) {
    name = json["name"];
    type = json["type"];
    state = json["state"];
    review = json["review"];
    desc = json["desc"];
    assignee = json["assignee"];
    points = json["points"];
  }
  
  Map toJson() {
    return {
      "name": name,
      "type": type,
      "state": state,
      "review": review,
      "desc": desc,
      "assignee": assignee,
      "points": points
    };
  }
}

