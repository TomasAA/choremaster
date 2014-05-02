import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Users extends Vane {
  // Get all users 
  Future getAll() {

    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Find all data that is in the collection "users", make it to a list
      usersColl.find().toList().then((List<Map> users) {
        // Close sends the users list and closes the response 
        close(users);
      }).catchError((e) {
        // If there was an error, return a empty list 
        close([]);
      });
    }).catchError((e) {
      // If there was an error, return a empty list 
      close([]);
    });
    
    return end;
  }
  
  // Get user 'user'
  Future get() {
    // Get user value from url, /users/$user
    var user = path[1];
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        // Close sends the user object and closes the response 
        close(user);
      }).catchError((e) {
        // If there was an error, return a empty map 
        close({});
      });
    }).catchError((e) {
      // If there was an error, return a empty map 
      close({});
    });
    
    return end;
  }
  
  // Create a new user 'user'
  Future create() {
    // Get user value from url, /users/$user   
    UserModel user = new UserModel();
    user.user = path[1];
    user.points = 0;
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Save new user to database 
      usersColl.insert(user.toJson()).then((dbRes) {
        log.info("Mongodb: ${dbRes}");
        
        close("ok");
      }).catchError((e) {
        log.warning("Unable to insert new user: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to insert new user: ${e}");
      close("error");
    });
    
    return end;
  }
  
  // Get points for user 'user'
  Future getPoints() {
    return close("10");
  }
  
  // Add points for user 'user'
  Future addPoints() {
    return close("adding x points");
  }
  
  // Removing points for user 'user'
  Future removePoints() {
    return close("removing x points");
  }
}

