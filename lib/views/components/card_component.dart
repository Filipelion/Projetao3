import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final String title;
  final Function onTap;

  const CardComponent({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Center(
          child: Text(
            this.title,
            textAlign: TextAlign.center,
          ),
        ),
        color: Colors.yellow[200],
      ),
      onTap: () => this.onTap,
    );
  }
}