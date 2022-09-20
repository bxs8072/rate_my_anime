import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/favorite.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class FavoriteApi {
  Client http = Client();

  Future<List<Favorite>?> retrieveAll(
      {required String status, required String userId}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/favorite/retrieve/all"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "status": status,
            "user": userId,
          }));

      if (response.statusCode == 400) {
        throw "error";
      }
      var jsonResponse = response.body;
      // print(jsonResponse);
      if (json.decode(jsonResponse)["data"] == null) {
        return [];
      }
      return List.from(json.decode(jsonResponse)["data"])
          .map((e) => Favorite.fromJSON(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Favorite?> retrieveFavorite(
      {required String userId, required Anime anime}) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/favorite/retrieve"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "link": anime.link,
                "user": userId,
              }));

      if (response.statusCode == 400) {
        throw "error";
      }
      var jsonResponse = response.body;
      // print(jsonResponse);
      if (json.decode(jsonResponse)["data"] == null) {
        return null;
      }
      return Favorite.fromJSON(json.decode(jsonResponse)["data"][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create({
    required Anime anime,
    required String status,
    required String userId,
  }) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/favorite/create"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "anime": anime.toJSON,
                "status": status,
                "user": userId,
              }));

      if (response.statusCode == 400) {
        throw "error";
      }

      var jsonResponse = response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update({
    required Favorite favorite,
  }) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/favorite/update"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode(favorite.toJSON));

      if (response.statusCode == 400) {
        throw "error";
      }

      var jsonResponse = response.body;
    } catch (e) {
      rethrow;
    }
  }
}
