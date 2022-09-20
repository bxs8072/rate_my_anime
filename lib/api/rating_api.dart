import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/rating.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class RatingApi {
  Client http = Client();

  Future<Rating?> retrieve(
      {required String userId, required Anime anime}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/rating/retrieve/user"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "animeLink": anime.link,
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
      return Rating.fromJSON(json.decode(jsonResponse)["data"][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<double?> retrieveTotalRating({required Anime anime}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/rating/retrieve/total"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "animeLink": anime.link,
          }));

      if (response.statusCode == 400) {
        throw "error";
      }
      var jsonResponse = response.body;

      if (json.decode(jsonResponse)["data"] == null) {
        return null;
      }

      return double.parse(
          json.decode(jsonResponse)["data"][0]["total"].toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create({
    required Anime anime,
    required double rating,
    required String userId,
  }) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/rating/create"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "anime": anime.toJSON,
                "rating": rating,
                "user": userId,
              }));

      if (response.statusCode == 400) {
        throw "error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update({required Rating rating}) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/rating/update"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode(rating.toJSON));

      if (response.statusCode == 400) {
        throw "error";
      }
    } catch (e) {
      rethrow;
    }
  }
}
