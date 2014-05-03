import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Activities extends Vane {
  // Get all activities 
  Future getAll() {
    print("Inside getAll activities");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var activitiesColl = mongodb.collection("activities");
     
      // Find all data that is in the collection "users", make it to a list
      activitiesColl.find().toList().then((List<Map> activities) {
        var activityObjects = new List<ActivityModel>();
       
        // Create a list of activity objects (to get rid of mongodb's _id)
        activities.forEach((activity) {
          activityObjects.add(new ActivityModel.fromJson(activity));
        });
       
        // Close sends the activityObjects list and closes the response 
        close(activityObjects);
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
  
  // Get activity 'activity'
  Future get() {
    // Get user value from url, /activities/$name
    var name = path[1];
    
    print("Inside get activity");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var activitiesColl = mongodb.collection("activities");
      
      // Find all data that is in the collection "users", make it to a list
      activitiesColl.findOne({"name": name}).then((Map activity) {
        // Create a new user object (to get rid of mongodb's _id) 
        var activityObject = new ActivityModel.fromJson(activity);
        
        // Close sends the user object and closes the response 
        close(activityObject.toJson());
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
  
  // Create a new activity 'activity'
  Future create() {
    var activity = new ActivityModel();
    
    // Get name value from url, /activities/$name/$type/$points
    activity.name  = path[1];
    
    // Get name type from url, /activities/$name/$type/$points
    activity.type = path[2];
    
    // Get name points from url, /activities/$name/$type/$points
    activity.points = path[3];
    
    print("Inside create activity");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var activitiesColl = mongodb.collection("activities");
      
      // Check that an activity with the same name don't already exists 
      activitiesColl.findOne({"name": activity.name}).then((Map existingActivity) {
        // If we did not find any existing activity with the same name, then
        // create the new activity
        if(existingActivity == null) {
          // Save new user to database 
          activitiesColl.insert(activity.toJson()).then((dbRes) {
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
}

