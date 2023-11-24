import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:em/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class Waiting extends StatelessWidget {
  const Waiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: LottieBuilder.asset("assets/loading.json")),
        AnimatedTextKit(repeatForever: true, animatedTexts: <AnimatedText>[TypewriterAnimatedText("Fetching Transactions...", speed: 300.ms, textStyle: const TextStyle(color: emerald, fontSize: 18, fontWeight: FontWeight.bold))])
      ],
    );
  }
}
