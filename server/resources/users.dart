import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Users extends Vane {
  // Get all users 
  Future getAll() {
    
    print("Inside getAll");

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
    
    print("Inside get");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        // Create a new user object (to get rid of mongodb _id) 
        var userObject = new UserModel.fromJson(user);
        
        // Close sends the user object and closes the response 
        close(userObject.toJson());
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
    
    print("Inside create");
    
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
    // Get user value from url, /users/points/$user
    var user = path[2];
    
    print("Inside getPoints user = $user");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        // Create a new user object (to get rid of mongodb _id) 
        var userObject = new UserModel.fromJson(user);
        
        // Close sends the user object and closes the response 
        close(userObject.points);
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
  
  // Add points for user 'user'
  Future addPoints() {
    // Get points value from url, /users/points/$user/$points
    var user = path[2];
    var points = path[3];
    
    print("Adding $points new points to user $user");
    
    // Add item to database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");

      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        if(user != null) {          
          // Add more points to user
          user["points"] = user["points"] + int.parse(points);
          
          // Save changes
          usersColl.save(user);
        }
        
        close("ok");
      }).catchError((e) {
        log.warning("Unable to update user: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to update user: ${e}");
      close("error");
    });
    
    return end;
  }
  
  // Removing points for user 'user'
  Future removePoints() {
    return close("removing x points");
  }
}

