import 'package:flutter/material.dart';

SnackBar snackBarError(BuildContext context, String strError) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(239, 210, 210, 1),
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(221, 165, 165, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notification_important_rounded,
                  color: Color.fromRGBO(213, 83, 83, 1),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  strError,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(213, 83, 83, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}
