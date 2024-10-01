import 'package:flutter/material.dart';
class TextCustom extends StatelessWidget {
   TextCustom({Key? key,required this.text,required this.color}) : super(key: key);
String text;
Color color;
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      color: color,fontSize: 12,fontWeight: FontWeight.normal
    ),);
  }
}
