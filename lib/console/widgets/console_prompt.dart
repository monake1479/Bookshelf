import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/utils/color_at_elevation.dart';

class ConsolePrompt extends StatefulWidget {
  const ConsolePrompt({
    super.key,
    required this.onSubmit,
    this.controller,
  });

  final void Function(String) onSubmit;
  final TextEditingController? controller;

  @override
  State<ConsolePrompt> createState() => _ConsolePromptState();
}

class _ConsolePromptState extends State<ConsolePrompt> {
  bool _active = false;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {
        _active = _controller.text.length >= 3;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 40,
      color: colorScheme.surface.withSurfaceTint(context, 2),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            color: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 10),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: _active
                  ? () {
                      widget.onSubmit(_controller.text);
                    }
                  : null,
              child: const Text(
                'Submit',
              ),
            ),
          )
        ],
      ),
    );
  }
}
