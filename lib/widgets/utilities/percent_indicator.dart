import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentIndicator extends StatelessWidget {
  const PercentIndicator({
    required this.currentValue,
    required this.totalValue,
    super.key,
  });

  final num currentValue;
  final num totalValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30,
          lineWidth: 8,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: currentValue / totalValue > 0.5
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          animation: true,
          percent: currentValue / totalValue,
          center: Text(
            currentValue.toString(),
            style: TextStyle(
              color: currentValue / totalValue > 0.5
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text('of ${totalValue.toString()}'),
      ],
    );
  }
}
