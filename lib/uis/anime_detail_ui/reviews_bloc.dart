import 'dart:async';

import 'package:rate_my_anime/api/review_api.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/review.dart';

class ReviewsBloc {
  StreamController<List<Review>> controller =
      StreamController<List<Review>>.broadcast();
  Stream<List<Review>> get stream => controller.stream.asBroadcastStream();
  get dispose => controller.close();

  Future<void> update(String skipValue, Anime anime) async {
    List<Review> list = await ReviewApi()
        .retrieveReviewsByAnime(skipValue: skipValue, anime: anime);
    controller.sink.add(list);
  }
}
