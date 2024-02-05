part of 'select_text_field.dart';

class _SelectTextFieldDropdown<T> extends OverlayEntry {
  _SelectTextFieldDropdown(
    this._link,
    this.values,
    this.displayValue,
    this.onSelected,
    this._searchPhraseStream,
    this._parentSize,
    this._parentOffset,
  ) : super(builder: (context) => const SizedBox());

  final LayerLink _link;
  final Size _parentSize;
  final Offset _parentOffset;
  final List<T> values;
  final Stream<String> _searchPhraseStream;
  final String Function(T) displayValue;
  final void Function(T) onSelected;

  @override
  WidgetBuilder get builder => build;

  Widget build(BuildContext context) {
    List<T> visibleValues = values;
    return StatefulBuilder(
      builder: (context, setInnerState) {
        final searchPhraseSubscription = _searchPhraseStream.listen((event) {
          if (mounted) {
            setInnerState(() {
              visibleValues = values
                  .where(
                    (element) => displayValue(element)
                        .toLowerCase()
                        .contains(event.toLowerCase()),
                  )
                  .toList();
            });
          }
        });
        final bottomDistance =
            MediaQuery.of(context).size.height - _parentOffset.dy;
        final dropdownMenuHeight = visibleValues.length * 48.0;
        final showFullDropdownMenu = bottomDistance > dropdownMenuHeight;
        final dropDownMenuSize = showFullDropdownMenu
            ? Size(_parentSize.width, dropdownMenuHeight)
            : Size(_parentSize.width, bottomDistance);
        return Positioned(
          key: UniqueKey(),
          width: dropDownMenuSize.width,
          height: dropDownMenuSize.height,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            offset: Offset(0, _parentSize.height + 5),
            child: Material(
              child: ListView.builder(
                key: UniqueKey(),
                itemCount: visibleValues.length,
                itemBuilder: (context, index) {
                  final value = visibleValues[index];
                  final valueAsString = displayValue(value);
                  return ListTile(
                    key: ValueKey(valueAsString),
                    title: Text(valueAsString),
                    onTap: () {
                      onSelected(value);
                      searchPhraseSubscription.cancel();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
