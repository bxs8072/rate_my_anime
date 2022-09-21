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

  Future<void> handleLikes(
      {required String userId, required String reviewId}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/review/likes/handle"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "id": reviewId,
            "user": userId,
          }));

      if (response.statusCode == 400) {
        throw "error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleDislikes(
      {required String userId, required String reviewId}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/review/dislikes/handle"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "id": reviewId,
            "user": userId,
          }));

      if (response.statusCode == 400) {
        throw "error";
      }
    } catch (e) {
      rethrow;
    }
  }
}
