import 'package:flutter/material.dart';
import 'package:rate_my_anime/screens/auth_screen/auth_screen_bloc.dart';
import 'package:rate_my_anime/screens/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:rate_my_anime/screens/auth_screen/login_screen/login_screen.dart';
import 'package:rate_my_anime/screens/auth_screen/register_screen/register_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  AuthScreenBloc authScreenBloc = AuthScreenBloc();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FormType>(
        stream: authScreenBloc.stream,
        initialData: FormType.login,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case FormType.login:
              return LoginScreen(key: key, authScreenBloc: authScreenBloc);
            case FormType.register:
              return RegisterScreen(key: key, authScreenBloc: authScreenBloc);
            case FormType.forgotPassword:
              return ForgotPasswordScreen(
                  key: key, authScreenBloc: authScreenBloc);
            default:
              return LoginScreen(key: key, authScreenBloc: authScreenBloc);
          }
        });
  }
}
