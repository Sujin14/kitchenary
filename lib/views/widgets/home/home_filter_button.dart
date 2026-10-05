import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/home/home_filter_sheet.dart';
import 'package:provider/provider.dart';

/// Round filter icon; shows a dot when a filter is narrowing the feed.
class HomeFilterButton extends StatelessWidget {
  const HomeFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final active = context.select<HomeController, bool>(
      (home) => home.hasActiveFilter,
    );
    final p = context.palette;
    return Semantics(
      button: true,
      label: active ? 'Filters, one applied' : 'Filters',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => showHomeFilterSheet(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? p.primarySoft : p.surface,
                border: Border.all(color: active ? p.primary : p.outline),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: active ? p.primary : p.textPrimary,
              ),
            ),
            if (active)
              Positioned(
                top: 2.r,
                right: 2.r,
                child: Container(
                  width: 11.r,
                  height: 11.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.accent,
                    border: Border.all(color: p.background, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
