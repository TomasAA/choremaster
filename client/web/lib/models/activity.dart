part of models;

class ActivityModel {
  String name;
  String type;
  int points;
  
  ActivityModel();

  ActivityModel.fromJson(Map json) {
    name = json["name"];
    type = json["type"];
    points = json["points"];
  }
  
  Map toJson() {
    return {
      "name": name,
      "type": type,
      "points": points
    };
  }
}

