import 'package:flutter/material.dart';

class NavigationService {
  BuildContext context;
  NavigationService(this.context);

  void push(Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
