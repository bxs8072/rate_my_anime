import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen_bloc.dart';
import 'package:rate_my_anime/screens/setup_account_screen/setup_account_screen.dart';

class HomeLandingScreen extends StatelessWidget {
  HomeLandingScreen({Key? key}) : super(key: key);

  HomeLandingScreenBloc bloc = HomeLandingScreenBloc();
  @override
  Widget build(BuildContext context) {
    bloc.update();
    return StreamBuilder<Person?>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text(
                "Error",
                key: key,
              ),
              content: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              key: key,
              child: CircularProgressIndicator(
                key: key,
              ),
            );
          } else if (snapshot.data == null) {
            return SetupAccountScreen(
              key: key,
              homeLandingScreenBloc: bloc,
            );
          } else {
            return Center(
              key: key,
              child: Text(
                "Account Exists",
                key: key,
              ),
            );
          }
        });
  }
}
