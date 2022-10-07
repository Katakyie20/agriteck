import 'package:agriteck/utils/AppColors.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String text1;
  final String? text2;
  final VoidCallback? press;
  const ClickableText({Key? key, this.press,required this.text1, this.text2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16),
              children: [
                TextSpan(text: text1, style: const TextStyle(color: primaryLight)),
                if(text2!=null)
                TextSpan(
                  text: text2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: primaryDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
