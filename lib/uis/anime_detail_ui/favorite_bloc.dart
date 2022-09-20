import 'dart:async';

import 'package:rate_my_anime/api/favorite_api.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/favorite.dart';

class FavoriteBloc {
  StreamController<Favorite?> controller = StreamController<Favorite?>();
  Stream<Favorite?> get stream => controller.stream;

  get dispose => controller.close();

  Future<void> update({required String userId, required Anime anime}) async {
    FavoriteApi()
        .retrieveFavorite(userId: userId, anime: anime)
        .then((value) => controller.sink.add(value));
  }
}
