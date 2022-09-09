import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/screens/auth_screen/auth_screen_bloc.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthScreenBloc authScreenBloc;

  const ForgotPasswordScreen({Key? key, required this.authScreenBloc})
      : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: SizeService.height(context) * 0.05),
                          Text(
                            "Forgot Password",
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
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: ThemeService.primary,
                              onPrimary: ThemeService.light,
                            ),
                            onPressed: () {
                              widget.authScreenBloc
                                  .update(FormType.forgotPassword);
                            },
                            child: Text(
                              "Submit",
                              style: GoogleFonts.lato(),
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Password remembered?",
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
