import 'dart:async';

import 'package:rate_my_anime/api/anime_api.dart';
import 'package:rate_my_anime/models/anime.dart';

class AnimeBloc {
  StreamController<List<Anime>> controller =
      StreamController<List<Anime>>.broadcast();
  Stream<List<Anime>> get stream => controller.stream.asBroadcastStream();
  get dispose => controller.close();

  Future<void> update(String type, String value, int page) async {
    List<Anime> items = await AnimeApi().retrieveByType(type, value, page);
    controller.add(items);
  }
}
