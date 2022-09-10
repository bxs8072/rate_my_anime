import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/custom_widgets/add_to_list_sheet/add_to_list_sheet.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class AnimeTile extends StatelessWidget {
  final Anime anime;
  const AnimeTile({Key? key, required this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                anime.image,
                fit: BoxFit.cover,
                height: SizeService.height(context) * 0.15,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            anime.title,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return AddToListSheet(anime: anime);
                                });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: DarkTheme.scaffoldBgColor,
                            ),
                            child: Icon(
                              Icons.add,
                              key: key,
                            ),
                          ),
                        ),
                      ],
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
