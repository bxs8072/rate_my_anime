import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/favorite_api.dart';
import 'package:rate_my_anime/api/rating_api.dart';
import 'package:rate_my_anime/custom_widgets/add_to_list_sheet/add_to_list_sheet.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/average_rating_bloc.dart';
import 'package:rate_my_anime/custom_widgets/edit_to_list_sheet/edit_to_list_sheet.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/favorite.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/services/navigation_services/navigation_service.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:rate_my_anime/uis/anime_detail_ui/anime_detail_ui.dart';
import 'package:rate_my_anime/uis/anime_detail_ui/favorite_bloc.dart';

class AnimeTile extends StatefulWidget {
  final Anime anime;
  final Person person;
  const AnimeTile({Key? key, required this.anime, required this.person})
      : super(key: key);

  @override
  State<AnimeTile> createState() => _AnimeTileState();
}

class _AnimeTileState extends State<AnimeTile> {
  AverageRatingBloc averageRatingBloc = AverageRatingBloc();

  FavoriteBloc favoriteBloc = FavoriteBloc();

  @override
  Widget build(BuildContext context) {
    averageRatingBloc.update(widget.anime);
    favoriteBloc.update(anime: widget.anime, userId: widget.person.id);

    return GestureDetector(
      onTap: () {
        NavigationService(context)
            .push(AnimeDetailUI(anime: widget.anime, person: widget.person));
      },
      child: Card(
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
                child: Hero(
                  tag: widget.anime.image,
                  child: Image.network(
                    widget.anime.image,
                    fit: BoxFit.cover,
                    height: SizeService.height(context) * 0.15,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: StreamBuilder<double?>(
                      stream: averageRatingBloc.stream,
                      builder: (context, totalSnapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.anime.title,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                StreamBuilder<Favorite?>(
                                    stream: favoriteBloc.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          key: widget.key,
                                        );
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (snapshot.data == null) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return AddToListSheet(
                                                    favoriteBloc: favoriteBloc,
                                                    anime: widget.anime,
                                                    person: widget.person,
                                                    averageRatingBloc:
                                                        averageRatingBloc,
                                                  );
                                                });
                                          } else {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return EditToListSheet(
                                                    anime: widget.anime,
                                                    person: widget.person,
                                                    favorite: snapshot.data!,
                                                    averageRatingBloc:
                                                        averageRatingBloc,
                                                    favoriteBloc: favoriteBloc,
                                                  );
                                                });
                                          }
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            color: DarkTheme.scaffoldBgColor,
                                          ),
                                          child: Icon(
                                            snapshot.data == null
                                                ? Icons.add
                                                : Icons.edit,
                                            key: widget.key,
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            Wrap(
                              children: [
                                Text(
                                    "⭐️ ${totalSnapshot.data == null ? "0.00" : totalSnapshot.data!.toStringAsFixed(2)}")
                              ],
                            )
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
