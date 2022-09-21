import 'dart:async';

import 'package:rate_my_anime/api/reply_api.dart';
import 'package:rate_my_anime/models/reply.dart';

class ReplyBloc {
  StreamController<List<Reply>> controller =
      StreamController<List<Reply>>.broadcast();
  Stream<List<Reply>> get stream => controller.stream.asBroadcastStream();
  get dispose => controller.close();

  Future<void> update(String reviewId, String skipValue) async {
    List<Reply> replies = await ReplyApi().retrieveReplies(reviewId, skipValue);
    controller.sink.add(replies);
  }
}
