import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/common/screen_header.dart';
import 'package:kitchenary/views/widgets/saved/saved_recipes_grid.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(title: 'Saved', subtitle: 'Your favourite recipes'),
            Expanded(child: SavedRecipesGrid()),
          ],
        ),
      ),
    );
  }
}
