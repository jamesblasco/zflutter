import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'cupertino_sheet.dart';

class ModalBottomSheetExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ModalBottomSheetExampleState();
}

class _ModalBottomSheetExampleState extends State<ModalBottomSheetExample> {
  @override
  void initState() {
    showModal();
    super.initState();
  }

  showModal() {
    if (!mounted) return;
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context, scrollController) => Close(
          child: PhotoShareBottomSheet(scrollController: scrollController),
        ),
      );
    });
    Future.delayed(Duration(seconds: 9), () => showModal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: CupertinoPageScaffold(
          child: Center(
              child: Image.asset(
            'assets/demo_image.jpeg',
          )),
        ),
        bottomNavigationBar: bottomAppBar(context));
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Column(
        children: <Widget>[
          Text('New York', style: TextStyle(fontWeight: FontWeight.normal)),
          Text('1 February 11:45',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
        ],
      ),
      trailing: Text(
        'Edit',
        style: TextStyle(
          color: CupertinoTheme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              CupertinoIcons.share,
              size: 28,
            ),
            onPressed: () {
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) =>
                    PhotoShareBottomSheet(scrollController: scrollController),
              );
            },
          ),
          CupertinoButton(
            child: Icon(CupertinoIcons.heart, size: 28),
            onPressed: null,
          ),
          CupertinoButton(
            child: Icon(CupertinoIcons.delete, size: 28),
            onPressed: null,
          )
        ],
      ),
    );
  }
}

class Close extends StatefulWidget {
  final Widget child;

  const Close({Key key, this.child}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CloseState();
}

class CloseState extends State<Close> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
