import 'package:flutter/material.dart';

class ToggleInput extends StatefulWidget {
  const ToggleInput({
    required this.labelTextLeft,
    required this.labelTextRight,
    required this.iconLeft,
    required this.iconRight,
    required this.onToggle,
    this.isSelected,
    super.key,
  });

  final String labelTextLeft;
  final String labelTextRight;
  final IconData iconLeft;
  final IconData iconRight;
  final List<bool>? isSelected;
  final void Function(int) onToggle;

  @override
  State<ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<ToggleInput> {
  late List<bool> isSelected;

  void toggleHandler(int index) {
    setState(() {
      isSelected[0] = false;
      isSelected[1] = false;

      isSelected[index] = true;
    });

    widget.onToggle(index);
  }

  @override
  void initState() {
    super.initState();

    isSelected = widget.isSelected ?? [true, false];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Opacity(
            opacity: isSelected[0] ? 1 : 0.5,
            child: GestureDetector(
              onTap: () => toggleHandler(0),
              child: Text(
                widget.labelTextLeft,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight:
                      isSelected[0] ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        ToggleButtons(
          isSelected: isSelected,
          borderRadius: BorderRadius.circular(8),
          onPressed: toggleHandler,
          children: [
            Icon(widget.iconLeft),
            Icon(widget.iconRight),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Opacity(
            opacity: isSelected[1] ? 1 : 0.5,
            child: GestureDetector(
              onTap: () => toggleHandler(1),
              child: Text(
                widget.labelTextRight,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight:
                      isSelected[1] ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
