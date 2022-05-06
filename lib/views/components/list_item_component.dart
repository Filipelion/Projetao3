import 'package:flutter/material.dart';
import 'package:Projetao3/views/shared/constants.dart';

class OiaListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function onTap;

  const OiaListTile(
      {Key? key, required this.title, required this.onTap, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white54,
      title: Text(
        this.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: this.subtitle == null
          ? null
          : Text(
              this.subtitle!,
              style: TextStyle(fontSize: Constants.smallFontSize),
            ),
      onTap: () => this.onTap,
    );
  }
}