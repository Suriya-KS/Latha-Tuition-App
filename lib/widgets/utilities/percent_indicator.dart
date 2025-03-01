import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentIndicator extends StatelessWidget {
  const PercentIndicator({
    required this.currentValue,
    required this.totalValue,
    this.description,
    this.showPercentage = true,
    super.key,
  });

  final num currentValue;
  final num totalValue;
  final String? description;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final percentage = currentValue / totalValue;

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 32,
          lineWidth: 6,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: percentage > 0.5
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).colorScheme.error.withOpacity(0.2),
          progressColor: percentage > 0.5
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          animation: true,
          percent: percentage,
          center: Text(
            showPercentage
                ? '${(percentage * 100).round().toString()}%'
                : currentValue.toString(),
            style: TextStyle(
              color: percentage > 0.5
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (description != null) const SizedBox(height: 5),
        if (description != null)
          Text(
            description!,
            style: const TextStyle(fontSize: 13),
          ),
      ],
    );
  }
}
