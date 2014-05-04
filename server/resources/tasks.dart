import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Tasks extends Vane {
  // Get state for all tasks
  Future getAll() {
    print("Inside getAll tasks");

    // Get a mongodb variable so that we can access the database
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of
      // data from the database
      var tasksColl = mongodb.collection("tasks");

      // Find all data that is in the collection "users", make it to a list
      tasksColl.find().toList().then((List<Map> tasks) {
        var taskObjects = new List<TaskModel>();

        // Create a list of activity objects (to get rid of mongodb's _id)
        tasks.forEach((task) {
          taskObjects.add(new TaskModel.fromJson(task));
        });

        // Close sends the activityObjects list and closes the response
        close(taskObjects);
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

  // Get task 'task'
  Future get() {
    // Get name value from url, /tasks/$name
    var name = path[1];

    print("Inside get task");

    // Get a mongodb variable so that we can access the database
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of
      // data from the database
      var tasksColl = mongodb.collection("tasks");

      // Find all data that is in the collection "users", make it to a list
      tasksColl.findOne({
        "name": name
      }).then((Map task) {
        // Create a new user object (to get rid of mongodb's _id)
        var taskObject = new TaskModel.fromJson(task);

        // Close sends the user object and closes the response
        close(taskObject.toJson());
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

  // Create a new task 'task'
  Future create() {
    var task = new TaskModel();

    // Get name value from url, /tasks/$name/$type/$points
    task.name = path[1];

    // Get name type from url, /tasks/$name/$type/$points
    task.type = path[2];
    
    // Set state as default to false
    task.state = false;

    // Get name points from url, /tasks/$name/$type/$points
    task.points = path[3];
    
    // Get description from body of request
    // Example of body data: "desc=Clean room"
    if(body.body != null) {
      if(body.body is Map && body.body.containsKey("desc") == true) {
        task.desc = body.body["desc"];
      }
    }
    
    print("Inside create task");

    // Get a mongodb variable so that we can access the database
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of
      // data from the database
      var tasksColl = mongodb.collection("tasks");

      // Check that an activity with the same name don't already exists
      tasksColl.findOne({
        "name": task.name
      }).then((Map existingTask) {
        // If we did not find any existing task with the same name, then
        // create the new task
        if (existingTask == null) {
          // Save new user to database
          tasksColl.insert(task.toJson()).then((dbRes) {
            log.info("Mongodb: ${dbRes}");

            close("ok");
          }).catchError((e) {
            log.warning("Unable to insert new task: ${e}");
            close("error");
          });
        } else {
          close("Error, task ${task.name} already exists");
        }
      }).catchError((e) {
        log.warning("Unable to search for existing task: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to insert new task: ${e}");
      close("error");
    });

    return end;
  }
  
  // Delete task 'task'
  Future delete() {
    // Get task name from url, /tasks/$name   
    var name = path[1];
    
    print("Inside delete");
    
    // Get a mongodb variable so that we can access the database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var tasksColl = mongodb.collection("tasks");
      
      // Delete user from database 
      tasksColl.remove({"name": name}).then((dbRes) {
        log.info("Mongodb: ${dbRes}");
        
        close("ok");
      }).catchError((e) {
        log.warning("Unable to delete task $name: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to delete task $name: ${e}");
      close("error");
    });
    
    return end;
  }

  Future setState() {
    // Get values from url, /tasks/$task/$state
    var name = path[2];
    var state = path[3];
    
    print("Setting task $name to state $state");
    
    // Add item to database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var tasksColl = mongodb.collection("tasks");

      // Find all data that is in the collection "users", make it to a list
      tasksColl.findOne({"name": name}).then((Map task) {
        if(task != null) {          
          // Update state 
          task["state"] = state;
          
          // Save changes
          tasksColl.save(task);
        }
        
        close("ok");
      }).catchError((e) {
        log.warning("Unable to update task $name: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to update task $name: ${e}");
      close("error");
    });
    
    return end;
  }

  Future getState() {
    // Get values from url, /tasks/$task/$state
    var name = path[2];
    
    print("Getting state for task $name");
    
    // Add item to database 
    mongodb.then((mongodb) {
      // Create a collection variable so we can access a specific collection of 
      // data from the database
      var tasksColl = mongodb.collection("tasks");

      // Find all data that is in the collection "users", make it to a list
      tasksColl.findOne({"name": name}).then((Map task) {
        if(task != null) {          
          // Return state
          close(task["state"]);
        } else {
          // Return state
          close("Error, task $name could not be found");
        }
      }).catchError((e) {
        log.warning("Unable to update task $name: ${e}");
        close("error");
      });
    }).catchError((e) {
      log.warning("Unable to update task $name: ${e}");
      close("error");
    });
    
    return end;
  }
}
