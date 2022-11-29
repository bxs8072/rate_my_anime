import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/auth_api.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/profile_page/edit_profile_ui/edit_profile_ui.dart';
import 'package:rate_my_anime/screens/auth_screen/policy_ui/policy.dart';
import 'package:rate_my_anime/screens/auth_screen/policy_ui/policy_ui.dart';
import 'package:rate_my_anime/screens/home_landing_screen/home_landing_screen_bloc.dart';
import 'package:rate_my_anime/services/navigation_services/navigation_service.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final Person person;
  final HomeLandingScreenBloc homeLandingScreenBloc;

  const ProfilePage(
      {Key? key, required this.person, required this.homeLandingScreenBloc})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: widget.key,
      child: Scaffold(
        key: widget.key,
        body: CustomScrollView(
          key: widget.key,
          slivers: [
            SliverAppBar(
              key: widget.key,
              title: Text(
                "Profile",
                key: widget.key,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeService.width(context) * 0.03,
                    vertical: 5.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    CircleAvatar(
                      backgroundColor: ThemeService.primary,
                      backgroundImage:
                          NetworkImage(widget.person.displayImage!),
                      radius: SizeService.height(context) * 0.08,
                      child: Text(
                        widget.person.displayImage!.isEmpty
                            ? ""
                            : "${widget.person.firstName[0]} ${widget.person.lastName[0]}",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: SizeService.height(context) * 0.08,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${widget.person.firstName} ${widget.person.lastName}",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: SizeService.height(context) * 0.035,
                      ),
                    ),
                    Text(
                      widget.person.email,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: SizeService.height(context) * 0.023,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          NavigationService(context).push(EditProfileUI(
                              homeLandingScreenBloc:
                                  widget.homeLandingScreenBloc,
                              person: widget.person));
                        },
                        leading: const Card(
                          color: ThemeService.success,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          "Edit Profile",
                          style: GoogleFonts.lato(),
                        ),
                        subtitle: Text(
                          "Edit your information",
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: const Card(
                          color: Colors.black,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.dark_mode,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          "Dark Mode",
                          style: GoogleFonts.lato(),
                        ),
                        subtitle: Text(
                          "Change Theme",
                          style: GoogleFonts.lato(),
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            ThemeService.switchTheme(context);
                          },
                          value: ThemeService.isDarkMode(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          NavigationService(context).push(
                            PolicyUI(key: widget.key),
                          );
                        },
                        leading: const Card(
                          color: ThemeService.warning,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.privacy_tip,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          "Privacy and Policy",
                          style: GoogleFonts.lato(),
                        ),
                        subtitle: Text(
                          "Read our privacy and policy",
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text(
                                    "Are you sure?",
                                    style: GoogleFonts.lato(
                                      color: ThemeService.danger,
                                    ),
                                  ),
                                  content: Text(
                                    "Do you want to logout?",
                                    style: GoogleFonts.lato(),
                                  ),
                                  actions: [
                                    IconButton(
                                        onPressed: () {
                                          AuthApi().logout();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.check_box)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.cancel))
                                  ],
                                );
                              });
                        },
                        leading: const Card(
                          color: ThemeService.danger,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          "Logout",
                          style: GoogleFonts.lato(),
                        ),
                        subtitle: Text(
                          "Sign out from the app",
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
