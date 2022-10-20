import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rate_my_anime/api/person_api.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen_bloc.dart';
import 'package:rate_my_anime/services/api_services/api_service.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;

class EditProfileUI extends StatefulWidget {
  final Person person;
  final HomeLandingScreenBloc homeLandingScreenBloc;

  const EditProfileUI(
      {Key? key, required this.person, required this.homeLandingScreenBloc})
      : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
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

  Future<PickedFile> pickImage() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    return pickedFile!;
  }

  Future<void> uploadImage() async {
    setState(() {
      displayImage = "";
    });
    PickedFile pickedFile = await pickImage();
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${ApiService.baseURL}/user/upload"));

      request.headers.addAll({
        "x-api-key": ApiService.apiKey,
        "token": await ApiService.token,
      });
      request.files
          .add(await http.MultipartFile.fromPath('file', pickedFile.path));

      request.fields.addAll({"userId": widget.person.id});
      StreamedResponse response = await request.send();
      response.stream.bytesToString().then((value) {
        setState(() {
          displayImage = json.decode(value)["data"];
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  String displayImage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      firstnameController.text = widget.person.firstName;
      middlenameController.text = widget.person.middleName ?? "";
      lastnameController.text = widget.person.lastName;
      displayImage = widget.person.displayImage ?? "";
    });
  }

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
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeService.width(context) * 0.04,
                          vertical: SizeService.height(context) * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            fit: StackFit.loose,
                            children: [
                              CircleAvatar(
                                radius: SizeService.height(context) * 0.08,
                                backgroundImage: NetworkImage(displayImage),
                                backgroundColor: ThemeService.primary,
                                child: Text(
                                  displayImage.isNotEmpty
                                      ? ""
                                      : "${firstnameController.text[0]} ${lastnameController.text[0]}",
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w900,
                                    color: ThemeService.light,
                                    fontSize:
                                        SizeService.height(context) * 0.06,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: SizeService.width(context) / 2 -
                                    SizeService.height(context) * 0.1,
                                child: Container(
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.black87),
                                  child: IconButton(
                                    onPressed: () async {
                                      await uploadImage();
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                  ),
                                ),
                              ),
                            ],
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
                              decoration: InputDecoration(
                                labelText: "First Name",
                                labelStyle: GoogleFonts.lato(
                                    color: ThemeService.primary),
                                contentPadding: const EdgeInsets.symmetric(
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
                              decoration: InputDecoration(
                                labelText: "Middle Name",
                                labelStyle: GoogleFonts.lato(
                                    color: ThemeService.primary),
                                contentPadding: const EdgeInsets.symmetric(
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
                              decoration: InputDecoration(
                                labelText: "Last Name",
                                labelStyle: GoogleFonts.lato(
                                    color: ThemeService.primary),
                                contentPadding: const EdgeInsets.symmetric(
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
                              await PersonApi()
                                  .update(
                                displayImage: displayImage,
                                firstname: firstnameController.text.trim(),
                                middlename: middlenameController.text.trim(),
                                lastname: lastnameController.text.trim(),
                              )
                                  .then((value) {
                                widget.homeLandingScreenBloc.update();
                                Navigator.pop(context);
                              });
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
