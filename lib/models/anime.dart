import 'dart:convert';

class Anime {
  final String title, link, image;
  Anime({
    required this.title,
    required this.link,
    required this.image,
  });

  Map<String, dynamic> get toJSON => {
        "title": title,
        "link": link,
        "image": image,
      };

  factory Anime.fromJSON(dynamic jsonData) {
    return Anime(
        title: jsonData["title"],
        link: jsonData["link"],
        image: jsonData["image"]);
  }
}
