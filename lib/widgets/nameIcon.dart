import 'package:flutter/material.dart';

class NameIcon extends StatelessWidget {
  final String firstName;
  final Color backgroundColor;
  final Color textColor;
  const NameIcon(
      {required this.firstName, this.backgroundColor= Colors.white, this.textColor= Colors.black,});

  String get firstLetter => this.firstName.substring(0, 1).toUpperCase();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: this.backgroundColor,
          border: Border.all(color: this.textColor, width: 0.5),
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(this.firstLetter, style: TextStyle(color: this.textColor)),
      ),
    );
  }
}