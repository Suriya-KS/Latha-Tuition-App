import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    required this.labelText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final List<String> items;
  final void Function(BuildContext, String, void Function(Object)) onChanged;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  int itemLength = 0;

  Iterable<Object> optionsBuilder(TextEditingValue textEditingValue) {
    final value = textEditingValue.text;

    if (value.isEmpty) {
      setState(() {
        itemLength = 0;
      });

      return const Iterable<String>.empty();
    }

    final filteredOptions = widget.items.where(
      (String option) => option.toLowerCase().contains(
            value.toLowerCase(),
          ),
    );

    setState(() {
      if (filteredOptions.length > 4) {
        itemLength = 4;
      } else {
        itemLength = filteredOptions.length;
      }
    });

    return filteredOptions;
  }

  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width - screenPadding * 2;

    return Column(
      children: [
        Autocomplete(
          optionsBuilder: optionsBuilder,
          fieldViewBuilder: (
            context,
            controller,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextFormField(
              decoration: InputDecoration(
                labelText: widget.labelText,
                prefixIcon: Icon(widget.prefixIcon),
              ),
              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              validator: (value) =>
                  validateRequiredInput(value, 'the', 'student name'),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  clipBehavior: Clip.hardEdge,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: inputWidth,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option =
                            options.elementAt(index).toString();

                        return InkWell(
                          onTap: () =>
                              widget.onChanged(context, option, onSelected),
                          child: Builder(
                            builder: (BuildContext context) {
                              final highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;

                              return Container(
                                color: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  RawAutocomplete.defaultStringForOption(
                                      option),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: itemLength * 50),
      ],
    );
  }
}
