class AnimeDetail {
  final String type, plot, released, status, other;
  final List<Episode> episodes;
  final List<String> genres;

  AnimeDetail({
    required this.type,
    required this.plot,
    required this.episodes,
    required this.genres,
    required this.status,
    required this.other,
    required this.released,
  });

  Map<String, dynamic> get toJSON => {
        "type": type,
        "plot": plot,
        "episodes": episodes.map((e) => e.toJSON).toList(),
        "genres": genres,
        "status": status,
        "other": other,
        "released": released
      };

  factory AnimeDetail.fromJSON(dynamic jsonData) {
    return AnimeDetail(
        type: jsonData["type"],
        plot: jsonData["plot"],
        episodes: List.from(jsonData["episodes"] ?? [])
            .map((e) => Episode.fromJSON(e))
            .toList(),
        genres: List.from(jsonData["genres"]).map((e) => e.toString()).toList(),
        status: jsonData["status"],
        other: jsonData["other"],
        released: jsonData["released"]);
  }
}

class Episode {
  final String title, link;
  Episode(this.link, this.title);

  Map<String, dynamic> get toJSON => {"title": title, "link": "link"};

  factory Episode.fromJSON(dynamic jsonData) =>
      Episode(jsonData["link"], jsonData["title"]);
}
