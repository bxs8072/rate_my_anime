import 'dart:convert';

import 'package:rate_my_anime/models/anime.dart';

class Rating {
  final String id, userId;
  double rating;
  final Anime anime;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.userId,
    required this.anime,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> get toJSON => {
        "id": id,
        "anime": anime.toJSON,
        "user": userId,
        "rating": rating,
      };

  factory Rating.fromJSON(dynamic jsonData) {
    return Rating(
        id: jsonData["id"],
        userId: jsonData["user"],
        anime: Anime.fromJSON(jsonData["anime"]),
        rating: double.parse(jsonData["rating"].toString()),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            jsonData["createdAt"]["T"] * 1000));
  }
}
