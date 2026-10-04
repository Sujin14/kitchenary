import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/splash/splash_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashView());
  }
}
