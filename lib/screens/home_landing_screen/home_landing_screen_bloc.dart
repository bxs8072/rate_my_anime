import 'dart:async';

import 'package:rate_my_anime/api/person_api.dart';
import 'package:rate_my_anime/models/person.dart';

class HomeLandingScreenBloc {
  StreamController<Person?> controller = StreamController<Person?>();
  Stream<Person?> get stream => controller.stream;

  get dispose => controller.close();

  Future<void> update() async {
    PersonApi().retrievePerson().then((person) {
      controller.sink.add(person);
    }).catchError((error) {
      controller.sink.addError(error);
    });
  }
}
