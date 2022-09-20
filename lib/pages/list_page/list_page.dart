import 'package:flutter/material.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/list_page/list_ui.dart';

class ListPage extends StatefulWidget {
  final Person person;
  const ListPage({Key? key, required this.person}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int tabIndex = 0;

  List<String> tabs = [
    "Currently Watching",
    "Plan to watch",
    "Completed",
    "Not Interested",
    "Dropped"
  ];

  List<Widget> get pages => [
        ListUI(
          status: tabs[tabIndex],
          person: widget.person,
        ),
        ListUI(
          status: tabs[tabIndex],
          person: widget.person,
        ),
        ListUI(
          status: tabs[tabIndex],
          person: widget.person,
        ),
        ListUI(
          status: tabs[tabIndex],
          person: widget.person,
        ),
        ListUI(
          status: tabs[tabIndex],
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
        title: const Text("Lists"),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          onTap: (index) {
            setState(() {
              tabIndex = index;
            });
          },
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: pages[tabIndex],
    );
  }
}
