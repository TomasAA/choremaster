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
        var userObjects = new List<UserModel>();
        
        // Create a list of user objects (to get rid of mongodb's _id)
        users.forEach((user) {
          userObjects.add(new UserModel.fromJson(user));
        });
        
        // Close sends the users list and closes the response 
        close(userObjects);
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
    
    print("Inside get user $user");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        // Create a new user object (to get rid of mongodb's _id) 
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
    UserModel user = new UserModel();
    
    // Get user value from url, /users/$user/$password
    user.user = path[1];
    
    // Get user password from query paramters, /users/$user/$password
    user.password = path[2];
    
    // Set points to 0
    user.points = 0;
    
    print("Inside create");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Check that username is not already taken
      usersColl.findOne({"user": user.user}).then((Map existingUser) {
        // If we did not find any existing user with the same username, then
        // create the new user
        if(existingUser == null) {
          // Save new user to database 
          usersColl.insert(user.toJson()).then((dbRes) {
            log.info("Mongodb: ${dbRes}");
            
            close("ok");
          }).catchError((e) {
            log.warning("Unable to insert new user: ${e}");
            close("error");
          });
        } else {
          close("Error, user already exists");
        }
      }).catchError((e) {
        log.warning("Unable to search for existing user: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to insert new user: ${e}");
      close("error");
    });
    
    return end;
  }
  
  // Delete user 'user'
  Future delete() {
    // Get user value from url, /users/$user   
    var user = path[1];
    
    print("Inside delete");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");
      
      // Delete user from database 
      usersColl.remove({"user": user}).then((dbRes) {
        log.info("Mongodb: ${dbRes}");
        
        close("ok");
      }).catchError((e) {
        log.warning("Unable to delete user: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to delete user: ${e}");
      close("error");
    });
    
    return end;
  }
  
  // Authenticate user 'user' with password 'password'
  Future authenticate() {
   // Get user value from url, /users/auth/$user/$password
   var user = path[2];
   
   // Get user password from query paramters, /users/auth/$user/$password
   var password = path[3];
   
   print("Trying to authenticate user $user with password $password");
   
   // Add item to database 
   mongodb.then((mongodb) {
     // Create a collection variable so we can access a specific collection of 
     // data from the database
     var usersColl = mongodb.collection("users");
  
     // Check if there is a user that has the provided username and password 
     usersColl.findOne({"user": user, "password": password}).then((Map user) {
       if(user != null) {          
         // If a user was found, return true
         print("User was authenticate");
         close(true);
       } else {
         // Else return false if no user was found
         print("Bad username or password");
         close(false);
       }
     }).catchError((e) {
       log.warning("Unable to update user: ${e}");
       close(false);
     });
   }).catchError((e) {
     log.warning("Unable to update user: ${e}");
     close(false);
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
        close(0);
      });
    }).catchError((e) {
      // If there was an error, return a empty map 
      close(0);
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
    // Get points value from url, /users/points/$user/$points
    var user = path[2];
    var points = path[3];
    
    print("Removing $points new points to user $user");
    
    // Add item to database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var usersColl = mongodb.collection("users");

      // Find all data that is in the collection "users", make it to a list
      usersColl.findOne({"user": user}).then((Map user) {
        if(user != null) {          
          // Add more points to user
          user["points"] = user["points"] - int.parse(points);
          
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
}

