

import 'package:flutter/cupertino.dart';
import 'package:weather/UI/screen_one.dart';
import 'package:weather/UI/screen_two.dart';

Map<String, WidgetBuilder> screenRoute = {
  ScreenOne.route :(BuildContext context) => const ScreenOne(),
  ScreenTwo.route2 : (BuildContext context) => const ScreenTwo()

};