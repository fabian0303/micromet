import 'package:flutter/material.dart';

class TextWidget {
  Widget textTitle(String message, Color color, var w) {
    return Text(message, style: TextStyle(color: color, fontSize: w * 0.08, fontWeight: FontWeight.w800));
  }

  Widget textSubtitle(String message, Color color, var w) {
    return Text(message, style: TextStyle(color: color, fontSize: w * 0.06, fontWeight: FontWeight.w800));
  }

  Widget textSubtitle2(String message, Color color, var w) {
    return Text(message, style: TextStyle(color: color, fontSize: w * 0.045, fontWeight: FontWeight.w400));
  }

  Widget text(String message, Color color, var w) {
    return Text(message, style: TextStyle(color: color, fontSize: w * 0.035, fontWeight: FontWeight.w400));
  }
}
