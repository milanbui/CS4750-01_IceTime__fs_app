import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrentUserInfo {
  static String _name = "First Last";
  static List _practiceLogs = [];

  static String getName() {
    setName();
    return _name;
  }

  static List getPracticeLogs() {
    setPracticeLogs();
    return _practiceLogs;
  }

  static void setName() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid +"/name").onValue.listen((DatabaseEvent event) {
      _name = event.snapshot.value.toString();
    });
  }

  static void setPracticeLogs(){
    String id = FirebaseAuth.instance.currentUser!.uid;
    List temp = [];
    FirebaseDatabase.instance.ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      for(DataSnapshot data in event.snapshot.children.toList()) {
        temp.add(data.value);
        print(data.value);
      }
      _practiceLogs = temp;
    });
  }
}