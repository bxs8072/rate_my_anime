import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/anime_tile.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/dashboard/anime_bloc.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchPage extends StatefulWidget {
  final Person person;
  const SearchPage({Key? key, required this.person}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  AnimeBloc animeBloc = AnimeBloc();
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: widget.key,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          key: widget.key,
          body: CustomScrollView(
            key: widget.key,
            slivers: [
              SliverAppBar(
                key: widget.key,
                backgroundColor: ThemeService.isDarkMode(context)
                    ? DarkTheme.appBarBgColor
                    : ThemeService.primary,
                pinned: true,
                title: Text(
                  "Search",
                  key: widget.key,
                ),
              ),
              SliverStickyHeader(
                sticky: true,
                header: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeService.width(context) * 0.03,
                      vertical: SizeService.height(context) * 0.02),
                  color: ThemeService.isDarkMode(context)
                      ? DarkTheme.appBarBgColor
                      : ThemeService.primary,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: ThemeService.secondary,
                        )),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 6.0, top: 6.0),
                        border: InputBorder.none,
                        hintText: "Search Anime",
                        hintStyle: GoogleFonts.lato(
                          color: ThemeService.secondary,
                        ),
                        labelText: "Search",
                        labelStyle: GoogleFonts.lato(
                          color: ThemeService.primary,
                        ),
                        suffixIcon: textEditingController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () async {
                                  textEditingController.clear();
                                  animeBloc.update("search", "", 1);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                icon: Icon(
                                  Icons.clear,
                                  key: widget.key,
                                  color: ThemeService.danger,
                                ),
                              ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          animeBloc.update("search", val.trim(), 1);
                        });
                      },
                    ),
                  ),
                ),
                sliver: StreamBuilder<List<Anime>>(
                    initialData: const [],
                    stream: animeBloc.stream,
                    builder: (context, snapshot) {
                      List<Anime> list = snapshot.data!;
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeService.width(context) * 0.01),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            Anime anime = list[i];
                            return AnimeTile(
                              anime: anime,
                              person: widget.person,
                            );
                          }, childCount: list.length),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
