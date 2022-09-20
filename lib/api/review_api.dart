import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/rating.dart';
import 'package:rate_my_anime/models/review.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class ReviewApi {
  Client http = Client();

  Future<List<Review>> retrieveReviewsByAnime(
      {required String skipValue, required Anime anime}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/review/retrieve/anime"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "animeLink": anime.link,
            "skipValue": skipValue,
          }));

      if (response.statusCode == 400) {
        throw "error";
      }
      var jsonResponse = response.body;
      print(json.decode(jsonResponse));

      if (json.decode(jsonResponse) == null) {
        return [];
      }

      List<Review> list =
          List<Map<String, dynamic>>.from(json.decode(jsonResponse))
              .map((e) => Review.fromJSON(e))
              .toList();
      list.forEach((element) {
        print(element);
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create({
    required Anime anime,
    required String message,
    required String userId,
  }) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/review/create"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "anime": anime.toJSON,
                "message": message,
                "user": userId,
              }));

      if (response.statusCode == 400) {
        throw "error";
      }
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
