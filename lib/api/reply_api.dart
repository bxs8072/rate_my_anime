import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/reply.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class ReplyApi {
  Client http = Client();
  Future<List<Reply>> retrieveReplies(String reviewId, String skipValue) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/reply/retrieve"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "reviewId": reviewId,
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

      List<Reply> list =
          List<Map<String, dynamic>>.from(json.decode(jsonResponse))
              .map((e) => Reply.fromJSON(e))
              .toList();
      list.forEach((element) {
        print(element.toJSON);
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> retrieveReplyLength(String reviewId) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/reply/retrieve/length"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({"reviewId": reviewId}));

      if (response.statusCode == 400) {
        throw "error";
      }
      var jsonResponse = response.body;
      print(json.decode(jsonResponse));

      if (json.decode(jsonResponse) == null) {
        return 0;
      }

      return json.decode(jsonResponse)["length"] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create({
    required String reviewId,
    required String message,
    required String userId,
  }) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/reply/create"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "review": reviewId,
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
      {required String userId, required String replyId}) async {
    try {
      Response response =
          await http.post(Uri.parse("${ApiService.baseURL}/reply/likes/handle"),
              headers: <String, String>{
                "x-api-key": ApiService.apiKey,
                "token": await ApiService.token,
              },
              body: json.encode({
                "id": replyId,
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
      {required String userId, required String replyId}) async {
    try {
      Response response = await http.post(
          Uri.parse("${ApiService.baseURL}/reply/dislikes/handle"),
          headers: <String, String>{
            "x-api-key": ApiService.apiKey,
            "token": await ApiService.token,
          },
          body: json.encode({
            "id": replyId,
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
