/*
 * This file is used to keep some methods that will be repeated in other screens. 
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static screenDimensions(BuildContext context) => MediaQuery.of(context);

  static Object? getRouteArgs(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;

  static String setLastSeen() {
    // Atualizando o horário
    DateTime now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    String today = formatter.format(now);

    return today;
  }
}
