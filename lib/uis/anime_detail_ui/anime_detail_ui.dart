import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/anime_detail_api.dart';
import 'package:rate_my_anime/custom_widgets/add_to_list_sheet/add_to_list_sheet.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/average_rating_bloc.dart';
import 'package:rate_my_anime/custom_widgets/edit_to_list_sheet/edit_to_list_sheet.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/anime_detail.dart';
import 'package:rate_my_anime/models/favorite.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/models/review.dart';
import 'package:rate_my_anime/services/navigation_services/navigation_service.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:rate_my_anime/uis/add_review_ui/add_review_ui.dart';
import 'package:rate_my_anime/uis/anime_detail_ui/favorite_bloc.dart';
import 'package:rate_my_anime/uis/anime_detail_ui/reviews_bloc.dart';
import 'package:rate_my_anime/uis/anime_ui/anime_ui.dart';
import 'package:theme_provider/theme_provider.dart';

class AnimeDetailUI extends StatefulWidget {
  final Person person;
  final Anime anime;
  const AnimeDetailUI({Key? key, required this.anime, required this.person})
      : super(key: key);

  @override
  State<AnimeDetailUI> createState() => _AnimeDetailUIState();
}

class _AnimeDetailUIState extends State<AnimeDetailUI> {
  final AverageRatingBloc averageRatingBloc = AverageRatingBloc();

  final FavoriteBloc favoriteBloc = FavoriteBloc();
  final ReviewsBloc reviewsBloc = ReviewsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    averageRatingBloc.update(widget.anime);
    favoriteBloc.update(anime: widget.anime, userId: widget.person.id);
    reviewsBloc.update("0", widget.anime);
  }

  List<Review> list = [];

  // Review? lastReview;

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
        child: Scaffold(
      floatingActionButton: StreamBuilder<Favorite?>(
          stream: favoriteBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return FloatingActionButton(
                onPressed: () {},
                backgroundColor: ThemeService.primary,
                child: CircularProgressIndicator(
                  key: widget.key,
                  color: ThemeService.light,
                ),
              );
            }
            return FloatingActionButton(
              onPressed: () {
                if (snapshot.data == null) {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return AddToListSheet(
                          favoriteBloc: favoriteBloc,
                          anime: widget.anime,
                          person: widget.person,
                          averageRatingBloc: averageRatingBloc,
                        );
                      });
                  favoriteBloc.update(
                      anime: widget.anime, userId: widget.person.id);
                } else {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return EditToListSheet(
                          anime: widget.anime,
                          person: widget.person,
                          favorite: snapshot.data!,
                          averageRatingBloc: averageRatingBloc,
                          favoriteBloc: favoriteBloc,
                        );
                      });

                  favoriteBloc.update(
                      anime: widget.anime, userId: widget.person.id);
                }
              },
              backgroundColor: ThemeService.primary,
              child: Icon(
                snapshot.data == null ? Icons.add : Icons.edit,
                key: widget.key,
                color: ThemeService.light,
              ),
            );
          }),
      body: SafeArea(
        child: StreamBuilder<double?>(
            stream: averageRatingBloc.stream,
            builder: (context, totalSnapshot) {
              return FutureBuilder<AnimeDetail?>(
                  future: AnimeDetailApi().retrieve(widget.anime.link),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          key: widget.key,
                          color: ThemeService.primary,
                        ),
                      );
                    }

                    AnimeDetail animeDetail = snapshot.data!;
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Stack(
                            fit: StackFit.loose,
                            alignment: Alignment.center,
                            children: [
                              Hero(
                                tag: widget.anime.image,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      widget.anime.image,
                                      height: SizeService.height(context) * 0.4,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: BackButton(
                                  key: widget.key,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeService.height(context) * 0.01),
                            child: Column(
                              children: [
                                Text(
                                  widget.anime.title,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Wrap(
                                    spacing: 10.0,
                                    children: [
                                      Text(
                                        animeDetail.status.toUpperCase(),
                                        style: GoogleFonts.lato(
                                          color: ThemeService.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        color: ThemeService.secondary,
                                        width: 1,
                                        height:
                                            SizeService.height(context) * 0.02,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            key: widget.key,
                                            size: 16,
                                            color: ThemeService.warning,
                                          ),
                                          Text(
                                            " ${totalSnapshot.data == null ? "0.00" : totalSnapshot.data!.toStringAsFixed(2)}",
                                            style: GoogleFonts.lato(
                                              color: ThemeService.secondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: ThemeService.secondary,
                                        width: 1,
                                        height:
                                            SizeService.height(context) * 0.02,
                                      ),
                                      Text(
                                        animeDetail.released.toUpperCase(),
                                        style: GoogleFonts.lato(
                                          color: ThemeService.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        color: ThemeService.secondary,
                                        width: 1,
                                        height:
                                            SizeService.height(context) * 0.02,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.list_alt,
                                            key: widget.key,
                                            size: 16,
                                            color: ThemeService.secondary,
                                          ),
                                          Text(
                                            " ${animeDetail.episodes.length}",
                                            style: GoogleFonts.lato(
                                              color: ThemeService.secondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeService.width(context) * 0.03,
                                      vertical: 10),
                                  child: Text(
                                    animeDetail.plot,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeService.width(context) * 0.03),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: animeDetail.genres
                                          .map(
                                            (e) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: ThemeService.primary,
                                                ),
                                                onPressed: () {
                                                  NavigationService(context)
                                                      .push(
                                                    AnimeUI(
                                                        type: "genre",
                                                        value: e,
                                                        person: widget.person),
                                                  );
                                                },
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Reviews",
                                    style: GoogleFonts.lato(),
                                  ),
                                  trailing: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        primary: ThemeService.primary,
                                        side: const BorderSide(
                                            color: ThemeService.primary)),
                                    onPressed: () {
                                      NavigationService(context).push(
                                        AddReviewUI(
                                          anime: widget.anime,
                                          person: widget.person,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Add",
                                      style: GoogleFonts.lato(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<List<Review>>(
                            stream: reviewsBloc.stream,
                            initialData: const <Review>[],
                            builder: (context, snapshot) {
                              list.addAll(snapshot.data!);

                              // if (list.isNotEmpty) {
                              //   lastReview = list.last;
                              // }

                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    Review review = list[i];
                                    return ListTile(
                                      leading: review
                                              .person.displayImage!.isEmpty
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  ThemeService.primary,
                                              child: Text(
                                                review.person.firstName[0]
                                                    .toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  color: ThemeService.light,
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  review.person.displayImage!),
                                            ),
                                      title: Text(
                                        review.createdAt.toLocal().toString(),
                                      ),
                                      subtitle: Text(review.message),
                                    );
                                  },
                                  childCount: list.length,
                                ),
                              );
                            }),
                        SliverToBoxAdapter(
                          child: OutlinedButton(
                              onPressed: () {
                                reviewsBloc.update(
                                    list.length.toString(), widget.anime);
                              },
                              child: const Text("Load mode...")),
                        ),
                      ],
                    );
                  });
            }),
      ),
    ));
  }
}
