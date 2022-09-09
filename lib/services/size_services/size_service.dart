import 'package:flutter/material.dart';

class SizeService {
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
