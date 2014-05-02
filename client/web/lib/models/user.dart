part of models;

class UserModel {
  String user;
  int points;
  
  UserModel();

  UserModel.fromJson(Map json) {
    user = json["user"];
    points = json["points"];
  }
  
  Map toJson() {
    return {
      "user": user,
      "points": points
    };
  }
}
