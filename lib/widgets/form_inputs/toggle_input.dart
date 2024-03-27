import 'package:flutter/material.dart';

class ToggleInput extends StatefulWidget {
  const ToggleInput({
    required this.onToggle,
    required this.children,
    this.isSelected,
    this.backgroundColors,
    super.key,
  });

  final void Function(int) onToggle;
  final List<Widget> children;
  final List<bool>? isSelected;
  final List<Color>? backgroundColors;

  @override
  State<ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<ToggleInput> {
  late List<bool> isSelected;
  Color? backgroundColor;

  void toggleHandler(int index) {
    setState(() {
      isSelected = List.filled(widget.children.length, false);

      isSelected[index] = true;
      backgroundColor = widget.backgroundColors?[index];
    });

    widget.onToggle(index);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isSelected == null) {
      isSelected = List.filled(widget.children.length, false);
      isSelected[0] = true;
    } else {
      isSelected = widget.isSelected!;
    }

    if (widget.backgroundColors != null) {
      backgroundColor = widget.backgroundColors?[isSelected.indexOf(true)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      fillColor: backgroundColor,
      selectedColor: widget.backgroundColors != null ? Colors.white : null,
      borderRadius: BorderRadius.circular(8),
      isSelected: isSelected,
      onPressed: toggleHandler,
      children: widget.children,
    );
  }
}
