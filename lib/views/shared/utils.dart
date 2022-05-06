/*
 * This file is used to keep some methods that will be repeated in other screens. 
 */

import 'package:flutter/material.dart';

class Utils {
  static screenDimensions(BuildContext context) => MediaQuery.of(context);

  static Object? getRouteArgs(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;
}