
import 'package:firebase_auth/firebase_auth.dart';

class Constants{
  static late User firebaseUser;
  static String baseUrl='http://192.168.68.107:8000/';
  static late String username;
  static String lastScanResultId='';
  
}

enum UserType{
  doctor,
  patient,
  admin,
}

// enum Collection{
//   static String   doctor='Doctor',

// }