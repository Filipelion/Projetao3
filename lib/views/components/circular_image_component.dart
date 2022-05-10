import 'package:flutter/material.dart';
import 'package:Projetao3/views/shared/constants.dart';

class CircularImageComponent extends StatelessWidget {
  final double width, height, borderWidth;
  final ImageProvider image;
  final Color color;

  const CircularImageComponent(
      {Key? key,
      required this.width,
      required this.height,
      required this.borderWidth,
      required this.image,
      this.color = Constants.COR_MOSTARDA})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: this.color,
            width: this.borderWidth,
          ),
          image: DecorationImage(
            image: this.image,
            fit: BoxFit.fill,
          )),
    );
  }
}
