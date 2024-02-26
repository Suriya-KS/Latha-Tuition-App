import 'package:flutter/material.dart';

class ToggleInput extends StatefulWidget {
  const ToggleInput({
    required this.children,
    required this.onToggle,
    super.key,
  });

  final List<Widget> children;
  final void Function(int) onToggle;

  @override
  State<ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<ToggleInput> {
  late List<bool> isSelected;

  void toggleHandler(int index) {
    setState(() {
      isSelected = List.filled(widget.children.length, false);

      isSelected[index] = true;
    });

    widget.onToggle(index);
  }

  @override
  void initState() {
    super.initState();

    isSelected = List.filled(widget.children.length, false);
    isSelected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      borderRadius: BorderRadius.circular(8),
      onPressed: toggleHandler,
      children: widget.children,
    );
  }
}
