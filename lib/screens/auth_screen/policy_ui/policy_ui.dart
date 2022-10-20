import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/screens/auth_screen/policy_ui/policy.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class PolicyUI extends StatelessWidget {
  const PolicyUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text("Terms and Condition"),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeService.height(context) * 0.01),
                Container(
                  width: double.infinity,
                  color: ThemeService.primary,
                  child: Text(
                    "COLLECTED INFORMATION",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      fontSize: SizeService.height(context) * 0.04,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        List.from(Policy().policies["collected_informations"])
                            .map((e) => Text(
                                  "- $e",
                                  style: GoogleFonts.lato(
                                    fontSize:
                                        SizeService.height(context) * 0.022,
                                  ),
                                ))
                            .toList(),
                  ),
                ),
                SizedBox(height: SizeService.height(context) * 0.04),
                Container(
                  width: double.infinity,
                  color: ThemeService.danger,
                  child: Text(
                    "PROHIBITED CONTENTS",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      fontSize: SizeService.height(context) * 0.04,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        List.from(Policy().policies["prohibited_contents"])
                            .map((e) => Text(
                                  "- $e",
                                  style: GoogleFonts.lato(
                                    fontSize:
                                        SizeService.height(context) * 0.022,
                                  ),
                                ))
                            .toList(),
                  ),
                ),
                SizedBox(height: SizeService.height(context) * 0.04),
                Container(
                  width: double.infinity,
                  color: ThemeService.warning,
                  child: Text(
                    "FLAGGING PROCESS",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      fontSize: SizeService.height(context) * 0.04,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Policy().policies["flagging_process"],
                    style: GoogleFonts.lato(
                      fontSize: SizeService.height(context) * 0.022,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
