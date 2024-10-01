import 'package:flutter/material.dart';

import 'custom_text.dart';
class LogoImage extends StatelessWidget {
   LogoImage({
    super.key,required this.text
  });
   String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Row(
        children: [
          Image.asset(
            "assets/images/splash.png",
            width: 50,
            height: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          TextCustom(text: text, color: Colors.black)
        ],
      ),
    );
  }
}
