part of models;

class UserModel {
  String user;
  String password;
  int points;
  
  UserModel();

  UserModel.fromJson(Map json) {
    user = json["user"];
    password = json["password"];
    points = json["points"];
  }
  
  Map toJson() {
    return {
      "user": user,
      "password": password,
      "points": points
    };
  }
}
