import 'package:flutter/material.dart';

SnackBar snackBarDeleteSent(item, BuildContext context) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(239, 210, 210, 1),
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(221, 165, 165, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Color.fromRGBO(213, 83, 83, 1),
                  ),
                  Text(
                    'The noti was deleted.',
                    style: TextStyle(
                      color: Color.fromRGBO(213, 83, 83, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}
