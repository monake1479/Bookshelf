import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'select_text_field_dropdown.dart';

class SelectTextfield<T> extends StatefulWidget {
  const SelectTextfield({
    super.key,
    required this.values,
    required this.displayValue,
    required this.onSelected,
    required this.validator,
    required this.label,
    this.initialSelection,
  });

  final List<T> values;
  final T? initialSelection;
  final String label;
  final String Function(T) displayValue;
  final void Function(T) onSelected;
  final String? Function(T?) validator;

  @override
  State<SelectTextfield> createState() => _SelectTextfieldState<T>();
}

class _SelectTextfieldState<T> extends State<SelectTextfield<T>> {
  final LayerLink _dropdownLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _dropdownEntry;

  final TextEditingController _textEditingController = TextEditingController();
  final StreamController<String> _searchPhraseController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    _textEditingController.text = widget.initialSelection != null
        ? widget.displayValue(widget.initialSelection as T)
        : '';
    _textEditingController.addListener(() {
      _searchPhraseController.add(_textEditingController.text);
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdownMenu();
      }
      if (!_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_focusNode.hasFocus) {
            _hideDropdownMenu();
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _dropdownLink,
      child: TextFormField(
        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        validator: (value) {
          if (value == null) {
            return widget.validator(null);
          }
          return widget.validator(
            widget.values.firstWhereOrNull(
              (element) => widget.displayValue(element) == value,
            ),
          );
        },
      ),
    );
  }

  void _showDropdownMenu() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _dropdownEntry = _SelectTextFieldDropdown(
      _dropdownLink,
      widget.values,
      widget.displayValue,
      _onSelected,
      _searchPhraseController.stream,
      size,
      offset,
    );
    overlay.insert(_dropdownEntry!);
  }

  void _hideDropdownMenu() {
    if (_dropdownEntry?.mounted ?? false) {
      _dropdownEntry?.remove();
      _dropdownEntry = null;
    }
  }

  void _onSelected(T value) {
    widget.onSelected(value);
    _textEditingController.text = widget.displayValue(value);
    _hideDropdownMenu();
  }
}
