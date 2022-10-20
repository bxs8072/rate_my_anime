import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen_bloc.dart';
import 'package:rate_my_anime/screens/home_screen/home_screen.dart';
import 'package:rate_my_anime/screens/setup_account_screen/setup_account_screen.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

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
          } else if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ThemeService.primary,
              ),
            );
          } else if (!snapshot.hasData) {
            return SetupAccountScreen(
              key: key,
              homeLandingScreenBloc: bloc,
            );
          } else {
            return HomeScreen(
              key: key,
              homeLandingScreenBloc: bloc,
              person: snapshot.data!,
            );
          }
        });
  }
}
