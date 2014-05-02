import 'dart:async';
import 'package:vane/vane.dart';
import '../../client/web/lib/models/models.dart';

class Logs extends Vane {
  // Get all log entries 
  Future getAll() {
    return close("All logs");
  }
  
  // Add one log item
  Future create() {
    
    return close("Adding log item");
  }
  
  // Get one log item for user 'user'
  Future get() {

    return close("Get log item");
  }
}

