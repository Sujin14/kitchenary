import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_view.dart';
import 'package:provider/provider.dart';

/// Full-screen, step-by-step cooking mode.
class CookingScreen extends StatelessWidget {
  const CookingScreen({required this.session, super.key});

  final CookingSession session;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CookingController>(
      create: (_) => CookingController(session),
      child: const Scaffold(body: CookingView()),
    );
  }
}
