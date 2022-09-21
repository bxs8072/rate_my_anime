import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/models/review.dart';

class Reply {
  final String id;
  final Person person;
  final String review;
  final String message;

  final DateTime createdAt;
  final List<String>? likes;
  final List<String>? dislikes;

  Reply({
    required this.id,
    required this.person,
    required this.review,
    required this.message,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
  });

  Map<String, dynamic> get toJSON => {
        "id": id,
        "user": person.id,
        "review": review,
        "message": message,
      };

  factory Reply.fromJSON(dynamic jsonData) {
    return Reply(
      id: jsonData["_id"] ?? jsonData["id"],
      person: Person.fromJSON(jsonData["user"][0]),
      review: jsonData["review"],
      message: jsonData["message"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          jsonData["createdAt"]["T"] * 1000),
      likes:
          jsonData["likes"] == null ? [] : List<String>.from(jsonData["likes"]),
      dislikes: jsonData["dislikes"] == null
          ? []
          : List<String>.from(jsonData["dislikes"]),
    );
  }
}
