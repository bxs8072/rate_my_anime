import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime_detail.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class AnimeDetailApi {
  Client http = Client();

  Future<AnimeDetail?> retrieve(String link) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/anime-detail"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "link": link,
              }));

      if (response.statusCode == 400) {
        return null;
      }

      var jsonResponse = response.body;

      return AnimeDetail.fromJSON(json.decode(jsonResponse)["data"]);
    } catch (e) {
      rethrow;
    }
  }
}
