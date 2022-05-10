import 'package:flutter/material.dart';
import 'package:Projetao3/views/shared/constants.dart';
import 'package:Projetao3/views/shared/utils.dart';

class ButtonComponent extends StatelessWidget {
  final String? title;
  final Function? onPressed;
  final double? width;

  const ButtonComponent({this.title, this.onPressed, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width ?? Utils.screenDimensions(context).size.width * 0.8,
      child: RaisedButton(
        child: Text(
          this.title ?? "Enviar",
          style: TextStyle(
              fontSize: Constants.regularFontSize, color: Colors.white),
        ),
        onPressed: () async => this.onPressed,
        color: Constants.COR_VINHO,
      ),
    );
  }
}
