import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/common/screen_header.dart';
import 'package:kitchenary/views/widgets/mine/new_recipe_button.dart';
import 'package:kitchenary/views/widgets/mine/own_recipes_list.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'My recipes',
              subtitle: 'Dishes you wrote yourself',
              trailing: NewRecipeButton(),
            ),
            Expanded(child: OwnRecipesList()),
          ],
        ),
      ),
    );
  }
}
