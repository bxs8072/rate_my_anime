import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class AnimeApi {
  Client http = Client();

  Future<List<Anime>> retrieveByType(
      String type, String value, int page) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/anime"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "type": type,
                "value": value,
                "page": page,
              }));

      if (response.statusCode == 400) {
        return [];
      }

      var jsonResponse = response.body;

      return List.from(json.decode(jsonResponse)["data"])
          .map((e) => Anime.fromJSON(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
