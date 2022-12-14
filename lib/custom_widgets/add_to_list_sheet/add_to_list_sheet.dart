import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/anime_detail_api.dart';
import 'package:rate_my_anime/api/favorite_api.dart';
import 'package:rate_my_anime/api/rating_api.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/average_rating_bloc.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/anime_detail.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:rate_my_anime/uis/anime_detail_ui/favorite_bloc.dart';

class AddToListSheet extends StatefulWidget {
  final Anime anime;
  final Person person;
  final AverageRatingBloc averageRatingBloc;
  final FavoriteBloc favoriteBloc;

  const AddToListSheet({
    Key? key,
    required this.anime,
    required this.person,
    required this.averageRatingBloc,
    required this.favoriteBloc,
  }) : super(key: key);

  @override
  State<AddToListSheet> createState() => _AddToListSheetState();
}

class _AddToListSheetState extends State<AddToListSheet> {
  List<String> items = [
    "Currently Watching",
    "Plan to watch",
    "Completed",
    "Not Interested",
    "Dropped"
  ];

  String selectedItem = "Currently Watching";

  double rating = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                widget.anime.image,
                                fit: BoxFit.cover,
                                height: SizeService.height(context) * 0.16,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.anime.title,
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            SizeService.height(context) * 0.01),
                                    FutureBuilder<AnimeDetail?>(
                                        future: AnimeDetailApi()
                                            .retrieve(widget.anime.link),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CircularProgressIndicator(
                                                    key: widget.key,
                                                    color: ThemeService.primary,
                                                  ),
                                                  SizedBox(
                                                    width: SizeService.width(
                                                            context) *
                                                        0.02,
                                                  ),
                                                  Text(
                                                    "Loading Details ...",
                                                    key: widget.key,
                                                    style: GoogleFonts.lato(
                                                      color:
                                                          ThemeService.primary,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            AnimeDetail animeDetail =
                                                snapshot.data!;
                                            return Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: [
                                                Text(
                                                  animeDetail.type
                                                      .toUpperCase(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context)
                                                        .primaryIconTheme
                                                        .color,
                                                  ),
                                                ),
                                                Container(
                                                  height: SizeService.height(
                                                          context) *
                                                      0.02,
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryIconTheme
                                                      .color,
                                                ),
                                                Text(
                                                  animeDetail.status
                                                      .toUpperCase(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context)
                                                        .primaryIconTheme
                                                        .color,
                                                  ),
                                                ),
                                                Container(
                                                  height: SizeService.height(
                                                          context) *
                                                      0.02,
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryIconTheme
                                                      .color,
                                                ),
                                                Text(
                                                  '${animeDetail.episodes.length} EPISODES',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context)
                                                        .primaryIconTheme
                                                        .color,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                            title: Text(
                                                              "Summary",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    ThemeService
                                                                        .light,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pop(
                                                                            ctx);
                                                                  },
                                                                  child: Text(
                                                                    "Close",
                                                                    style:
                                                                        GoogleFonts
                                                                            .lato(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: ThemeService
                                                                          .primary,
                                                                    ),
                                                                  ))
                                                            ],
                                                            content: Text(
                                                              animeDetail.plot,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 14.0,
                                                                color:
                                                                    ThemeService
                                                                        .light,
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Text(
                                                    animeDetail.plot,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                        Text(
                          "Status",
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: const Border.fromBorderSide(
                              BorderSide(
                                color: ThemeService.secondary,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                              elevation: 0,
                              isDense: false,
                              isExpanded: true,
                              underline: Center(key: widget.key),
                              dropdownColor: Theme.of(context).cardTheme.color,
                              value: selectedItem,
                              items: items
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      key: ValueKey(e),
                                      value: e,
                                      onTap: () {
                                        setState(() {
                                          selectedItem = e;
                                        });
                                      },
                                      enabled: true,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {}),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rating",
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "?????? $rating",
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Slider(
                      value: rating,
                      max: 10.00,
                      min: 0.00,
                      divisions: 20,
                      activeColor: ThemeService.primary,
                      thumbColor: ThemeService.primary,
                      label: "?????? $rating",
                      onChanged: (val) {
                        setState(() {
                          rating = val;
                        });
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                primary: ThemeService.primary,
              ),
              onPressed: () async {
                await FavoriteApi().create(
                    anime: widget.anime,
                    status: selectedItem,
                    userId: widget.person.id);

                await RatingApi().create(
                    anime: widget.anime,
                    rating: rating,
                    userId: widget.person.id);

                await widget.favoriteBloc
                    .update(anime: widget.anime, userId: widget.person.id);

                await widget.averageRatingBloc
                    .update(widget.anime)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Save Changes",
                key: widget.key,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
