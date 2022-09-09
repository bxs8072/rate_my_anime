import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const baseURL = "http://10.0.2.2:8080/api/v1";
  static const apiKey = "wHNFET6Lwp7EAFMkCzOe2oLeEYop0evdo3k2iDGyz2w=";
  static Future<String> get token async =>
      await FirebaseAuth.instance.currentUser!.getIdToken();
}
