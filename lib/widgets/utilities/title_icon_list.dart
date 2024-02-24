import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/cards/title_icon_action_tile.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/text_edit_sheet.dart';

class TitleIconList extends StatelessWidget {
  const TitleIconList({
    required this.fieldName,
    required this.items,
    required this.onListTileTap,
    required this.onIconPressAndSwipe,
    required this.onButtonPress,
    super.key,
  });

  final String fieldName;
  final List<dynamic> items;
  final void Function(int, String) onListTileTap;
  final void Function(int) onIconPressAndSwipe;
  final void Function(String) onButtonPress;

  void listTileTapHandler(BuildContext context, int index) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Edit ${capitalizeText(fieldName)}',
        fieldName: fieldName,
        buttonText: 'Update',
        initialValue: items[index],
        onPressed: (value) => onListTileTap(index, value),
      ),
    );
  }

  void buttonPressHandler(BuildContext context, int index) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Add New ${capitalizeText(fieldName)}',
        fieldName: fieldName,
        buttonText: 'Add',
        onPressed: onButtonPress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) => index < items.length
          ? TitleIconActionTile(
              title: items[index],
              icon: Icons.delete_outline,
              index: index,
              onTap: () => listTileTapHandler(context, index),
              onPressAndSwipe: onIconPressAndSwipe,
              iconColor: Theme.of(context).colorScheme.error,
              key: Key('$index'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => buttonPressHandler(context, index),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_outlined),
                        Text('Add'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
