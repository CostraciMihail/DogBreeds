import 'package:flutter/material.dart';
import 'package:DogBreeds/DBProviders.dart';
import 'package:provider/provider.dart';

///
/// DBEditAppBar
///
class DBEditAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final Function() onSaveTapHandler;

  @override
  final Size preferredSize;

  DBEditAppBar(this.title, {Key key, @required this.onSaveTapHandler})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppBarState();
}

///
/// _MyAppBarState
///
class _MyAppBarState extends State<DBEditAppBar> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    isEditMode = context.read<ScreenState>().isEditMode;

    return AppBar(
      title: Text(widget.title),
      leading: isEditMode ? _cancelAppBarButton() : null,
      actions: [_selectTopAppBarButton()],
    );
  }

  Widget _selectTopAppBarButton() {
    return Center(
        child: GestureDetector(
      child: isEditMode ? Text("Save") : Text("Select"),
      onTap: () {
        if (isEditMode) {
          widget.onSaveTapHandler();
        }

        context.read<ScreenState>().isEditMode = !isEditMode;
        setState(() => isEditMode = !isEditMode);
      },
    ));
  }

  Widget _cancelAppBarButton() {
    return GestureDetector(
      child: Center(
        child: Text("Cancel"),
      ),
      onTap: () {
        context.read<ScreenState>().isEditMode = false;
        setState(() => isEditMode = false);
      },
    );
  }
}
