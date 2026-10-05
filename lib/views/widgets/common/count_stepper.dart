import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A number with minus and plus buttons around it.
class CountStepper extends StatelessWidget {
  const CountStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.decreaseLabel = 'Decrease',
    this.increaseLabel = 'Increase',
    super.key,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String decreaseLabel;
  final String increaseLabel;

  @override
  Widget build(BuildContext context) {
    final style = IconButton.styleFrom(minimumSize: Size(40.r, 40.r));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: decreaseLabel,
          style: style,
          icon: const Icon(Icons.remove),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 44.w,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          tooltip: increaseLabel,
          style: style,
          icon: const Icon(Icons.add),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
