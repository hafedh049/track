import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class ErrorD extends StatelessWidget {
  const ErrorD({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: LottieBuilder.asset("assets/error.json")),
        Flexible(child: SingleChildScrollView(child: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: <AnimatedText>[TypewriterAnimatedText(error, speed: 300.ms, textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])))
      ],
    );
  }
}
