import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/rating_api.dart';
import 'package:rate_my_anime/api/review_api.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/models/rating.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class AddReviewUI extends StatefulWidget {
  final Person person;
  final Anime anime;
  const AddReviewUI({Key? key, required this.person, required this.anime})
      : super(key: key);

  @override
  State<AddReviewUI> createState() => _AddReviewUIState();
}

class _AddReviewUIState extends State<AddReviewUI> {
  TextEditingController textEditingController = TextEditingController();

  Rating? initRating;
  double rating = 0.00;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RatingApi()
        .retrieve(userId: widget.person.id, anime: widget.anime)
        .then((value) {
      if (value != null) {
        setState(() {
          initRating = value;
          rating = value.rating;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      key: widget.key,
                      title: const Text("Add Review"),
                    ),
                    SliverToBoxAdapter(
                        key: widget.key,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: SizeService.width(context) * 0.05),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border:
                                      Border.all(color: ThemeService.secondary),
                                ),
                                child: TextField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6.0),
                                    border: InputBorder.none,
                                    labelText: "Review",
                                    labelStyle: GoogleFonts.lato(
                                      color: ThemeService.primary,
                                    ),
                                    hintText: "Write Review...",
                                    hintStyle: GoogleFonts.lato(
                                      color: ThemeService.secondary,
                                    ),
                                  ),
                                  maxLines: 10,
                                  minLines: 4,
                                ),
                              ),
                              SizedBox(
                                height: SizeService.height(context) * 0.03,
                              ),
                              Text(
                                "Rating",
                                style: GoogleFonts.lato(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                        value: rating,
                                        max: 10.00,
                                        min: 0.00,
                                        divisions: 20,
                                        activeColor: ThemeService.primary,
                                        thumbColor: ThemeService.primary,
                                        label: "⭐️ $rating",
                                        onChanged: (val) {
                                          setState(() {
                                            rating = val;
                                          });
                                        }),
                                  ),
                                  Text(
                                    "⭐️ $rating",
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: SizeService.width(context) * 0.05),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ThemeService.primary,
                    onPrimary: ThemeService.light,
                  ),
                  onPressed: () async {
                    if (textEditingController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Review"),
                              content: const Text("Review should not be empty"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text("Close"))
                              ],
                            );
                          });
                    } else {
                      if (initRating == null) {
                        await RatingApi().create(
                          anime: widget.anime,
                          rating: rating,
                          userId: widget.person.id,
                        );
                      } else {
                        initRating!.rating = rating;
                        await RatingApi().update(rating: initRating!);
                      }
                      await ReviewApi()
                          .create(
                              anime: widget.anime,
                              message: textEditingController.text.trim(),
                              userId: widget.person.id)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
