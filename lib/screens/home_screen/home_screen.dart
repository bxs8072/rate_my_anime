import 'package:flutter/material.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/pages/dashboard/dashboard.dart';
import 'package:rate_my_anime/pages/list_page/list_page.dart';

class HomeScreen extends StatefulWidget {
  final Person person;
  const HomeScreen({super.key, required this.person});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> get pages => [
        Dashboard(
          key: widget.key,
          person: widget.person,
        ),
        ListPage(
          key: widget.key,
          person: widget.person,
        ),
        Dashboard(
          key: widget.key,
          person: widget.person,
        ),
      ];
  int currentIndex = 0;

  List<BottomNavigationBarItem> bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "List"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottom,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
