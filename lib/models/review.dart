import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';

class Review {
  final String id;
  final Person person;
  final Anime anime;
  final String message;

  final DateTime createdAt;
  final List<String>? likes;
  final List<String>? dislikes;

  Review({
    required this.id,
    required this.person,
    required this.anime,
    required this.message,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
  });

  Map<String, dynamic> get toJSON => {
        "id": id,
        "user": person.id,
        "anime": anime.toJSON,
        "message": message,
      };

  factory Review.fromJSON(dynamic jsonData) {
    return Review(
      id: jsonData["_id"],
      person: Person.fromJSON(jsonData["user"][0]),
      anime: Anime.fromJSON(jsonData["anime"]),
      message: jsonData["message"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          jsonData["createdAt"]["T"] * 1000),
      likes: jsonData["likes"] ?? [],
      dislikes: jsonData["dislikes"] ?? [],
    );
  }
}
