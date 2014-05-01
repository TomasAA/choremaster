import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

// /users
class Users extends Vane {
  // Get all users 
  Future getAll() {
    return close("All users");
  }
  
  // Get user 'user'
  Future get() {
    return close("Get user 'user'");
  }
  
  // Create a new user 'user'
  Future create() {
    return close("Creating user");
  }
  
  // Get points for user 'user'
  Future getPoints() {
    return close("10");
  }
  
  // Add points for user 'user'
  Future addPoints() {
    return close("adding x points");
  }
}

