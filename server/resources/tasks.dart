import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Tasks extends Vane {
  // Get state for all tasks
  Future getAll() {
    return close("All tasks");
  }
  
  Future setState() {
    // Set/update state for one task
    
    return close("Setting state");
  }
  
  Future getState() {
    // Get state for one task
    
    return close("Returning state for one task");
  }
}

