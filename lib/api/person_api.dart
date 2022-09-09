import 'dart:convert';

import 'package:http/http.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';

class PersonApi {
  Client http = Client();

  Future<Person?> retrievePerson() async {
    try {
      Response response = await http.post(
        Uri.parse("${ApiService.baseURL}/user/"),
        headers: <String, String>{
          "x-api-key": ApiService.apiKey,
          "token": await ApiService.token,
        },
      );

      if (response.statusCode == 400) {
        return null;
      }

      var jsonResponse = response.body;

      print(jsonResponse);
      return Person.fromJSON(json.decode(jsonResponse));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setup({
    required String firstname,
    required String middlename,
    required String lastname,
    required String displayImage,
  }) async {
    try {
      Response response = await http.post(
        Uri.parse("${ApiService.baseURL}/user/create"),
        headers: <String, String>{
          "x-api-key": ApiService.apiKey,
          "token": await ApiService.token,
        },
        body: json.encode({
          "firstName": firstname,
          "middleName": middlename,
          "lastName": lastname,
          "displayImage": displayImage,
        }),
      );

      var jsonResponse = response.body;

      print(jsonResponse);
    } catch (e) {
      rethrow;
    }
  }
}
