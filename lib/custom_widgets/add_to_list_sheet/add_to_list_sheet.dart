import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/anime_detail_api.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/anime_detail.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class AddToListSheet extends StatefulWidget {
  final Anime anime;
  const AddToListSheet({Key? key, required this.anime}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.anime.image,
                      fit: BoxFit.cover,
                      height: SizeService.height(context) * 0.17,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: SizeService.height(context) * 0.01),
                          FutureBuilder<AnimeDetail?>(
                              future:
                                  AnimeDetailApi().retrieve(widget.anime.link),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircularProgressIndicator(
                                          key: widget.key,
                                          color: ThemeService.primary,
                                        ),
                                        SizedBox(
                                          width:
                                              SizeService.width(context) * 0.02,
                                        ),
                                        Text(
                                          "Loading Details ...",
                                          key: widget.key,
                                          style: GoogleFonts.lato(
                                            color: ThemeService.primary,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  AnimeDetail animeDetail = snapshot.data!;
                                  return Wrap(
                                    runAlignment: WrapAlignment.start,
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.tv,
                                            key: widget.key,
                                            color: Theme.of(context)
                                                .primaryIconTheme
                                                .color,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            animeDetail.status.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.list_alt,
                                            key: widget.key,
                                            color: Theme.of(context)
                                                .primaryIconTheme
                                                .color,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${animeDetail.episodes.length}  EPISODES',
                                            style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            key: widget.key,
                                            color: Theme.of(context)
                                                .primaryIconTheme
                                                .color,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            animeDetail.type.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .color,
                                            ),
                                          ),
                                        ],
                                      ),
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
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                12.0,
              ),
              child: Text(
                "Status",
                style: GoogleFonts.lato(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                12.0,
              ),
              child: Text(
                "Rating",
                style: GoogleFonts.lato(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
