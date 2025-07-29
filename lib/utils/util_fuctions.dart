import 'package:flutter/material.dart';

void showSnackBars({required context, required String text}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: 1)));
}

void showDialogBox({
  required BuildContext context,
  required String title,
  required String text,
  required String buttonText,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title,),
        content: Text(text, style: TextStyle(color: Colors.grey),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              onConfirm();
              Navigator.of(context).pop();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
