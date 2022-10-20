import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/auth_api.dart';
import 'package:rate_my_anime/screens/auth_screen/auth_screen_bloc.dart';
import 'package:rate_my_anime/screens/auth_screen/policy_ui/policy_ui.dart';
import 'package:rate_my_anime/services/navigation_services/navigation_service.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  final AuthScreenBloc authScreenBloc;
  const RegisterScreen({Key? key, required this.authScreenBloc})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusnode = FocusNode();
  FocusNode confirmPasswordFocusnode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusnode.dispose();
    confirmPasswordFocusnode.dispose();
    super.dispose();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      await AuthApi()
          .register(emailController.text.trim().toLowerCase(),
              passwordController.text.trim())
          .then((value) {})
          .catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                          key: widget.key,
                          height: SizeService.height(context) * 0.06),
                      Text(
                        "Rate My Anime",
                        style: GoogleFonts.pacifico(
                          color: ThemeService.primary,
                          fontSize: SizeService.height(context) * 0.05,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                          key: widget.key,
                          height: SizeService.height(context) * 0.02),
                      Text(
                        "Give reviews to your favorite animes",
                        style: GoogleFonts.lato(
                          color: ThemeService.light,
                          fontSize: SizeService.height(context) * 0.022,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeService.width(context) * 0.04),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: SizeService.height(context) * 0.05),
                          Text(
                            "Sign Up",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: SizeService.height(context) * 0.03),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.025),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: emailFocusNode,
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              validator: (val) {
                                if (!EmailValidator.validate(
                                    val!.trim().toLowerCase())) {
                                  return "Invalid Email Address";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: passwordFocusnode,
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: confirmPasswordFocusnode,
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Confirm Password",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              validator: (val) {
                                if (val!.trim() !=
                                    passwordController.text.trim()) {
                                  return "Password did not matched";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          TextButton(
                            onPressed: () {
                              NavigationService(context).push(
                                PolicyUI(key: widget.key),
                              );
                            },
                            child: Text(
                              "Privacy and Policy",
                              style: GoogleFonts.lato(
                                fontSize: SizeService.height(context) * 0.02,
                                fontWeight: FontWeight.w700,
                                color: ThemeService.primary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: ThemeService.primary,
                              onPrimary: ThemeService.light,
                            ),
                            onPressed: register,
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.lato(),
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                key: widget.key,
                                style: GoogleFonts.lato(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeService.secondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.authScreenBloc.update(FormType.login);
                                },
                                child: Text(
                                  "Sign In",
                                  key: widget.key,
                                  style: GoogleFonts.lato(
                                    fontSize:
                                        SizeService.height(context) * 0.022,
                                    fontWeight: FontWeight.w700,
                                    color: ThemeService.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
