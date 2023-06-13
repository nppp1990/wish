import 'package:flutter/material.dart';

class DialogUtils {
  DialogUtils._();

  static void showToast(BuildContext context, String msg,
      {Duration duration = const Duration(milliseconds: 500)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(msg),
          )
        ],
      ),
      duration: duration,
    ));
  }

  static Future<bool?> showModal(
    BuildContext context,
    String yes,
    String no, {
    Color? yesColor,
    Color? noColor,
    String? title,
    String? content,
  }) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Text(content),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      no,
                      style: TextStyle(color: noColor),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      yes,
                      style: TextStyle(color: yesColor),
                    )),
              ],
            ));
  }
}
