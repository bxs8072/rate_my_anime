import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const baseURL =
      "https://rate-my-anime-api-git-oeghfd4pma-uc.a.run.app/api/v1";
  static const apiKey = "wHNFET6Lwp7EAFMkCzOe2oLeEYop0evdo3k2iDGyz2w=";
  static Future<String> get token async =>
      await FirebaseAuth.instance.currentUser!.getIdToken();
}
