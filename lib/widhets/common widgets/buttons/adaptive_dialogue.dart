import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialogWidget extends StatelessWidget {
  final String? title;
  final String? content;
  final String? yesText;
  final String? noText;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final bool showYesButton;
  final bool showNoButton;

  const AdaptiveAlertDialogWidget({
    super.key,
    this.title,
    this.content,
    this.yesText,
    this.noText,
    this.onYes,
    this.onNo,
    this.showYesButton = true,
    this.showNoButton = true,
  });

  void show(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => this,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => this,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title != null ? Text(title!) : null,
        content: content != null ? Text(content!) : null,
        actions: [
          if (showNoButton)
            CupertinoDialogAction(
              child: Text(noText ?? 'No'),
              onPressed: () {
                Navigator.of(context).pop();
                onNo?.call();
              },
            ),
          if (showYesButton)
            CupertinoDialogAction(
              child: Text(yesText ?? 'Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                onYes?.call();
              },
            ),
        ],
      );
    } else {
      return AlertDialog(
        title: title != null ? Text(title!) : null,
        content: content != null ? Text(content!) : null,
        actions: [
          if (showNoButton)
            TextButton(
              child: Text(noText ?? 'No'),
              onPressed: () {
                Navigator.of(context).pop();
                onNo?.call();
              },
            ),
          if (showYesButton)
            TextButton(
              child: Text(yesText ?? 'Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                onYes?.call();
              },
            ),
        ],
      );
    }
  }
}
