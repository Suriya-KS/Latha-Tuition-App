import 'package:flutter/material.dart';

class ToggleInput extends StatefulWidget {
  const ToggleInput({
    required this.iconLeft,
    required this.iconRight,
    required this.onToggle,
    this.labelTextLeft,
    this.labelTextRight,
    this.backgroundColors,
    this.isSelected,
    super.key,
  });

  final String? labelTextLeft;
  final String? labelTextRight;
  final IconData iconLeft;
  final IconData iconRight;
  final List<Color>? backgroundColors;
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
        if (widget.labelTextLeft != null)
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: isSelected[0] ? 1 : 0.5,
              child: GestureDetector(
                onTap: () => toggleHandler(0),
                child: Text(
                  widget.labelTextLeft!,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight:
                        isSelected[0] ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        if (widget.labelTextLeft != null) const SizedBox(width: 20),
        ToggleButtons(
          fillColor: widget.backgroundColors != null
              ? isSelected[0]
                  ? widget.backgroundColors![0]
                  : widget.backgroundColors![1]
              : null,
          selectedColor: widget.backgroundColors != null ? Colors.white : null,
          isSelected: isSelected,
          borderRadius: BorderRadius.circular(8),
          onPressed: toggleHandler,
          children: [
            Icon(widget.iconLeft),
            Icon(widget.iconRight),
          ],
        ),
        if (widget.labelTextRight != null) const SizedBox(width: 20),
        if (widget.labelTextRight != null)
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: isSelected[1] ? 1 : 0.5,
              child: GestureDetector(
                onTap: () => toggleHandler(1),
                child: Text(
                  widget.labelTextRight!,
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
