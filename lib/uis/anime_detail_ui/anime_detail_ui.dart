import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_anime/api/anime_detail_api.dart';
import 'package:rate_my_anime/api/reply_api.dart';
import 'package:rate_my_anime/api/review_api.dart';
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
import 'package:rate_my_anime/uis/reply_ui/reply_ui.dart';
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
              return StreamBuilder<List<Review>>(
                  stream: reviewsBloc.stream,
                  initialData: const <Review>[],
                  builder: (context, reviewsSnapshot) {
                    for (var each in reviewsSnapshot.data!) {
                      if (!list.contains(each)) {
                        list.add(each);
                      }
                    }

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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            widget.anime.image,
                                            height:
                                                SizeService.height(context) *
                                                    0.4,
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
                                      vertical:
                                          SizeService.height(context) * 0.01),
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
                                                  SizeService.height(context) *
                                                      0.02,
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
                                                    color:
                                                        ThemeService.secondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              color: ThemeService.secondary,
                                              width: 1,
                                              height:
                                                  SizeService.height(context) *
                                                      0.02,
                                            ),
                                            Text(
                                              animeDetail.released
                                                  .toUpperCase(),
                                              style: GoogleFonts.lato(
                                                color: ThemeService.secondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              color: ThemeService.secondary,
                                              width: 1,
                                              height:
                                                  SizeService.height(context) *
                                                      0.02,
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
                                                    color:
                                                        ThemeService.secondary,
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
                                                SizeService.width(context) *
                                                    0.03,
                                            vertical: 10),
                                        child: Text(
                                          animeDetail.plot,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeService.width(context) *
                                                    0.03),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: animeDetail.genres
                                                .map(
                                                  (e) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary: ThemeService
                                                            .primary,
                                                      ),
                                                      onPressed: () {
                                                        NavigationService(
                                                                context)
                                                            .push(
                                                          AnimeUI(
                                                              type: "genre",
                                                              value: e,
                                                              person: widget
                                                                  .person),
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
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    Review review = list[i];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: ThemeService.secondary)),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          review
                                                                  .person
                                                                  .displayImage!
                                                                  .isEmpty
                                                              ? CircleAvatar(
                                                                  backgroundColor:
                                                                      ThemeService
                                                                          .primary,
                                                                  child: Text(
                                                                    review
                                                                        .person
                                                                        .firstName[
                                                                            0]
                                                                        .toUpperCase(),
                                                                    style:
                                                                        GoogleFonts
                                                                            .lato(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: ThemeService
                                                                          .light,
                                                                    ),
                                                                  ),
                                                                )
                                                              : CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(review
                                                                          .person
                                                                          .displayImage!),
                                                                ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          Text(
                                                            "${review.person.firstName} ${review.person.lastName}",
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 14.0,
                                                              color: ThemeService
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? ThemeService
                                                                      .light
                                                                  : Colors
                                                                      .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        Intl()
                                                            .date(
                                                                "MM/dd/yyyy hh:mm")
                                                            .format(review
                                                                .createdAt),
                                                        style: GoogleFonts.lato(
                                                          fontSize: 10.0,
                                                          color: ThemeService
                                                              .secondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color:
                                                        ThemeService.secondary,
                                                    thickness: 0.5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isThreeLine: true,
                                            subtitle: Text(
                                              review.message,
                                              style: GoogleFonts.lato(
                                                fontSize: 14.0,
                                                color: ThemeService.isDarkMode(
                                                        context)
                                                    ? Colors.white70
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: () async {
                                                      await ReviewApi()
                                                          .handleLikes(
                                                              userId: widget
                                                                  .person.id,
                                                              reviewId:
                                                                  review.id)
                                                          .then((value) async {
                                                        setState(() {
                                                          review
                                                                  .likes!
                                                                  .contains(widget
                                                                      .person
                                                                      .id)
                                                              ? review.likes!
                                                                  .remove(widget
                                                                      .person
                                                                      .id)
                                                              : review.likes!
                                                                  .add(widget
                                                                      .person
                                                                      .id);
                                                        });
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.thumb_up,
                                                      color: review.likes!
                                                              .contains(widget
                                                                  .person.id)
                                                          ? ThemeService.primary
                                                          : ThemeService
                                                              .secondary,
                                                    ),
                                                    label: Text(
                                                      review.likes!.length
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                        color: review.likes!
                                                                .contains(widget
                                                                    .person.id)
                                                            ? ThemeService
                                                                .primary
                                                            : ThemeService
                                                                .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () async {
                                                      await ReviewApi()
                                                          .handleDislikes(
                                                              userId: widget
                                                                  .person.id,
                                                              reviewId:
                                                                  review.id)
                                                          .then((value) async {
                                                        setState(() {
                                                          review.dislikes!
                                                                  .contains(widget
                                                                      .person
                                                                      .id)
                                                              ? review.dislikes!
                                                                  .remove(widget
                                                                      .person
                                                                      .id)
                                                              : review.dislikes!
                                                                  .add(widget
                                                                      .person
                                                                      .id);
                                                        });
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.thumb_down,
                                                      color: review.dislikes!
                                                              .contains(widget
                                                                  .person.id)
                                                          ? ThemeService.danger
                                                          : ThemeService
                                                              .secondary,
                                                    ),
                                                    label: Text(
                                                      review.dislikes!.length
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                        color: review.dislikes!
                                                                .contains(widget
                                                                    .person.id)
                                                            ? ThemeService
                                                                .danger
                                                            : ThemeService
                                                                .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              FutureBuilder<int>(
                                                  future: ReplyApi()
                                                      .retrieveReplyLength(
                                                          review.id),
                                                  initialData: 0,
                                                  builder: (context, snapshot) {
                                                    return TextButton.icon(
                                                      onPressed: () {
                                                        NavigationService(
                                                                context)
                                                            .push(
                                                          ReplyUI(
                                                              person:
                                                                  widget.person,
                                                              review: review),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.reply),
                                                      label: Text(
                                                          snapshot.data! >= 10
                                                              ? "10+"
                                                              : snapshot.data
                                                                  .toString()),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: list.length,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeService.width(context) * 0.03),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      primary: ThemeService.primary,
                                      side: const BorderSide(
                                        color: ThemeService.primary,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      reviewsBloc.update(
                                          list.length.toString(), widget.anime);
                                    },
                                    child: const Text("Load more reviews"),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  });
            }),
      ),
    ));
  }
}
