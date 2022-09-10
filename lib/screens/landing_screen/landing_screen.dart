import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_anime/api/auth_api.dart';
import 'package:rate_my_anime/screens/auth_screen/auth_screen.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthApi().logout();
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text(
                "Error",
                key: key,
              ),
              content: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return AuthScreen(key: key);
          } else {
            if (!snapshot.data!.emailVerified) {
              return AlertDialog(
                title: Text(
                  "Verify your email address ${snapshot.data!.email}",
                  key: key,
                ),
                content: Text(
                  "Check your inbox or sometimes junk folder in email to verify your email address",
                  key: key,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      snapshot.data!.reload();
                    },
                    icon: Icon(Icons.refresh, key: key),
                  ),
                  TextButton(
                    onPressed: () {
                      snapshot.data!.sendEmailVerification();
                    },
                    child: Text("Send again", key: key),
                  ),
                ],
              );
            }
            return HomeLandingScreen(
              key: key,
            );
          }
        });
  }
}
