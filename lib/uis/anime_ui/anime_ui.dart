import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/anime_tile.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/dashboard/anime_bloc.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class AnimeUI extends StatefulWidget {
  final String type, value;
  final Person person;
  const AnimeUI(
      {Key? key, required this.type, required this.value, required this.person})
      : super(key: key);

  @override
  State<AnimeUI> createState() => _AnimeUIState();
}

class _AnimeUIState extends State<AnimeUI> {
  ScrollController scrollController = ScrollController();
  static List<Anime> list = [];
  static int page = 1;
  AnimeBloc animeBloc = AnimeBloc();
  bool isLoading = false;

  initScroller() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = !isLoading;
          page++;
        });
        animeBloc.update(widget.type, widget.value, page);
      }
      setState(() {
        isLoading = !isLoading;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    list.clear();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (list.isEmpty) {
      animeBloc.update(widget.type, widget.value, page);
    }
    initScroller();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            key: widget.key,
            pinned: true,
            title: Text(widget.value.toUpperCase()),
          ),
          StreamBuilder<List<Anime>>(
              stream: animeBloc.stream,
              initialData: const <Anime>[],
              builder: (context, snapshot) {
                for (Anime a in snapshot.data!) {
                  if (!list.contains(a)) {
                    list.add(a);
                  }
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(6.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      Anime anime = list[i];
                      return AnimeTile(
                        anime: anime,
                        person: widget.person,
                      );
                    },
                    childCount: list.length,
                  )),
                );
              }),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              height: SizeService.height(context) * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    key: widget.key,
                    color: ThemeService.primary,
                  ),
                  SizedBox(
                    width: SizeService.width(context) * 0.03,
                  ),
                  Text(
                    "loading More.....",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
