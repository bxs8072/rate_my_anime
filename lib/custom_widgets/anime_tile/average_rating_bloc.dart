import 'dart:async';

import 'package:rate_my_anime/api/rating_api.dart';
import 'package:rate_my_anime/models/anime.dart';

class AverageRatingBloc {
  StreamController<double?> controller = StreamController<double?>();
  Stream<double?> get stream => controller.stream;
  get dispose => controller.close();

  Future<void> update(Anime anime) async {
    RatingApi().retrieveTotalRating(anime: anime).then((value) {
      controller.add(value);
    });
  }
}
