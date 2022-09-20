import 'package:rate_my_anime/models/anime.dart';

class Favorite {
  final String id, userId, status;
  final Anime anime;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.anime,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> get toJSON => {
        "id": id,
        "anime": anime.toJSON,
        "user": userId,
        "status": status,
      };

  factory Favorite.fromJSON(dynamic jsonData) {
    return Favorite(
        id: jsonData["id"],
        userId: jsonData["user"],
        anime: Anime.fromJSON(jsonData["anime"]),
        status: jsonData["status"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            jsonData["createdAt"]["T"] * 1000));
  }
}
