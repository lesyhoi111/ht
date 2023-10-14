import 'package:flutter/material.dart';

SnackBar snackBarDelete(item, BuildContext context, handleBackItem) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(189, 233, 191, 1),
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(84, 152, 88, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Color.fromRGBO(84, 152, 88, 1),
                  ),
                  Text(
                    'The noti was stored.',
                    style: TextStyle(
                      color: Color.fromRGBO(84, 152, 88, 1),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings_backup_restore_rounded),
                color: const Color.fromRGBO(84, 152, 88, 1),
                iconSize: 25,
                onPressed: () {
                  handleBackItem(item);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Back item ${item.title}')));
                },
              ), // Icon button
            ],
          ),
        ),
      ));
}
