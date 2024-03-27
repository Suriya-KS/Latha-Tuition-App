import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudentTestMarksText extends StatelessWidget {
  const StudentTestMarksText({
    required this.marks,
    required this.totalMarks,
    super.key,
  });

  final num marks;
  final num totalMarks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30,
          lineWidth: 8,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: marks / totalMarks > 0.5
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          animation: true,
          percent: marks / totalMarks,
          center: Text(
            marks.toString(),
            style: TextStyle(
              color: marks / totalMarks > 0.5
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text('of ${totalMarks.toString()}'),
      ],
    );
  }
}
