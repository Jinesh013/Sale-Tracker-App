import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String titleText;
  final String messageText;
  final Object? errorDetails;
  final void Function() onDismiss;

  const ErrorMessage({
    super.key,
    this.titleText = 'Error',
    required this.messageText,
    this.errorDetails,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titleText,
        style: const TextStyle(color: Colors.redAccent),
      ),
      elevation: 5,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Text(messageText),
            ] +
            (errorDetails != null
                ? <Widget>[
                    const Padding(padding: EdgeInsets.all(10)),
                    buildErrorDetails(),
                  ]
                : <Widget>[]),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  Widget buildErrorDetails() {
    return Container(
      padding: const EdgeInsets.all(10),  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(),
      ),
      child: Text(
        '$errorDetails',
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'monospaced',
            
        ),
      ),
    );
  }
}
