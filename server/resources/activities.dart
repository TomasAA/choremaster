import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

// /activities
class Activities extends Vane {
  // Get all activities 
  Future getAll() {
   return close("All activities");
  }
  
  // Get activity 'activity'
  Future get() {
    return close("Get activity 'activity'");
  }
  
  // Create a new activity 'activity'
  Future create() {
    return close("Creating activity");
  }
}

