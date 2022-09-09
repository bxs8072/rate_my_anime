import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    Center(child: Text("Dashboard"),),
    Center(child: Text("Profile"),),
  ];
  int currentIndex = 0;

  List<BottomNavigationBarItem> bottom = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
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
