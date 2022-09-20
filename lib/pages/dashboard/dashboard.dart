import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/api/anime_api.dart';
import 'package:rate_my_anime/models/anime.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/dashboard/anime_bloc.dart';
import 'package:rate_my_anime/pages/dashboard/movies_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/new_seasion_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/ona_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/ova_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/popular_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/special_list_ui.dart';
import 'package:rate_my_anime/pages/dashboard/tv_series_list_ui.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class Dashboard extends StatefulWidget {
  final Person person;
  const Dashboard({Key? key, required this.person}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int tabIndex = 0;

  List<Map<String, dynamic>> tabs = [
    {"title": "popular", "value": "popular", "type": "type"},
    {"title": "movies", "value": "anime movies", "type": "type"},
    {"title": "new season", "value": "new season", "type": "type"},
    {"title": "ova", "value": "ova", "type": "subcategory"},
    {"title": "ona", "value": "ona", "type": "subcategory"},
    {"title": "tv series", "value": "tv", "type": "subcategory"},
    {"title": "special", "value": "special", "type": "subcategory"},
  ];

  List<Widget> get pages => [
        PopularListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        MoviesListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        NewSeasonListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        OvaListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        OnaListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        TvSeriesListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
        SpecialListUI(
          type: tabs[tabIndex]["type"],
          value: tabs[tabIndex]["value"],
          person: widget.person,
        ),
      ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Hello ${widget.person.firstName}"),
        bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            onTap: (index) {
              setState(() {
                tabIndex = index;
              });
            },
            tabs: tabs
                .map(
                  (e) => Tab(
                    text: e["title"].toUpperCase(),
                  ),
                )
                .toList()),
      ),
      body: pages[tabIndex],
    );
  }
}
