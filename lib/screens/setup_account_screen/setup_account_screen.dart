import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/person_api.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen_bloc.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class SetupAccountScreen extends StatefulWidget {
  final HomeLandingScreenBloc homeLandingScreenBloc;
  const SetupAccountScreen({Key? key, required this.homeLandingScreenBloc})
      : super(key: key);

  @override
  State<SetupAccountScreen> createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  FocusNode firstnameFocusnode = FocusNode();
  FocusNode middlenameFocusnode = FocusNode();
  FocusNode lastnameFocusnode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    firstnameController.dispose();
    middlenameController.dispose();
    lastnameController.dispose();
    firstnameFocusnode.dispose();
    middlenameFocusnode.dispose();
    lastnameFocusnode.dispose();
    super.dispose();
  }

  String displayImage = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                        "Setup Account",
                        style: GoogleFonts.pacifico(
                          color: ThemeService.success,
                          fontSize: SizeService.height(context) * 0.05,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                          key: widget.key,
                          height: SizeService.height(context) * 0.02),
                      Text(
                        "Getting started",
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
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeService.width(context) * 0.04,
                          vertical: SizeService.height(context) * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CircleAvatar(
                            radius: SizeService.height(context) * 0.08,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.loose,
                              children: [
                                if (displayImage.isNotEmpty)
                                  Image.network(displayImage),
                                Positioned(
                                  bottom: 0,
                                  right: SizeService.width(context) / 2 -
                                      SizeService.height(context) * 0.1,
                                  child: Container(
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.black87),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.03),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              controller: firstnameController,
                              focusNode: firstnameFocusnode,
                              decoration: const InputDecoration(
                                labelText: "First Name",
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
                              controller: middlenameController,
                              focusNode: middlenameFocusnode,
                              decoration: const InputDecoration(
                                labelText: "Middle Name",
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
                              controller: lastnameController,
                              focusNode: lastnameFocusnode,
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: SizeService.height(context) * 0.01),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: ThemeService.primary,
                              onPrimary: ThemeService.light,
                            ),
                            onPressed: () async {
                              await PersonApi().setup(
                                displayImage: displayImage,
                                firstname: firstnameController.text.trim(),
                                middlename: middlenameController.text.trim(),
                                lastname: lastnameController.text.trim(),
                              );
                              await widget.homeLandingScreenBloc.update();
                            },
                            child: Text(
                              "Get Started",
                              style: GoogleFonts.lato(),
                            ),
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
