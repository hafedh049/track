import 'package:em/classes.dart';
import 'package:em/error.dart';
import 'package:em/globals.dart';
import 'package:em/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  database = await ObjectBoxDatabase.init();
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorD(error: details.exception.toString());
  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Escape Matrix",
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
