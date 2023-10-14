import 'package:flutter/material.dart';

AlertDialog PopupConfirm(BuildContext context, String title, String content,
    void Function()? handleConfirm) {
  return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      content: Container(
          constraints: const BoxConstraints(
            minHeight: 200,
            minWidth: double.infinity,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 27),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      content,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(142, 144, 144, 1)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 2),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(232, 232, 232, 1),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(232, 232, 232, 1),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 2),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(226, 76, 75, 1),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Đóng hộp thoại trước khi gọi handleConfirm
                          handleConfirm?.call(); // Gọi handleConfirm
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(226, 76, 75, 1),
                          ),
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ])));
}
