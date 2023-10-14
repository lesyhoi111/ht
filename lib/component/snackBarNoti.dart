import 'package:flutter/material.dart';

SnackBar snackBarNoti(BuildContext context, String strError) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(189, 233, 191, 1),
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(84, 152, 88, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: Color.fromRGBO(84, 152, 88, 1),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  strError,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(84, 152, 88, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}
