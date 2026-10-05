import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/services/screen_awake_service.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_bottom_bar.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_done_page.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_ingredients_page.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_step_page.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_timers_strip.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_top_bar.dart';
import 'package:provider/provider.dart';

/// Cooking mode: a swipeable page per step, with the screen kept awake.
class CookingView extends StatefulWidget {
  const CookingView({super.key});

  @override
  State<CookingView> createState() => _CookingViewState();
}

class _CookingViewState extends State<CookingView> {
  static const Duration _pageDuration = Duration(milliseconds: 280);

  final PageController _pages = PageController();
  late final ScreenAwakeService _awake;

  @override
  void initState() {
    super.initState();
    _awake = context.read<ScreenAwakeService>();
    _awake.keepAwake();
  }

  @override
  void dispose() {
    _awake.allowSleep();
    _pages.dispose();
    super.dispose();
  }

  void _back() =>
      _pages.previousPage(duration: _pageDuration, curve: Curves.easeOut);

  void _next() {
    if (context.read<CookingController>().isDonePage) {
      context.popOrHome();
      return;
    }
    _pages.nextPage(duration: _pageDuration, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final cooking = context.read<CookingController>();
    return ColoredBox(
      color: context.palette.cookingBackground,
      child: SafeArea(
        child: Column(
          children: [
            const CookingTopBar(),
            const CookingTimersStrip(),
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: cooking.setPage,
                children: [
                  const CookingIngredientsPage(),
                  for (var i = 0; i < cooking.stepCount; i++)
                    CookingStepPage(number: i + 1, text: cooking.steps[i]),
                  const CookingDonePage(),
                ],
              ),
            ),
            CookingBottomBar(onBack: _back, onNext: _next),
          ],
        ),
      ),
    );
  }
}
