import 'package:flutter/material.dart';

FloatingActionButton floatingButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.pushNamed(context, '/detail');
    },
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      // Đặt hình dạng làm viền tròn với bán kính 8.0
    ),
    child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(0, 210, 255, 1),
            Color.fromRGBO(58, 123, 213, 0.84),
          ],
        ),
        shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
      ),
      child: const Icon(
        Icons.add_rounded,
        color: Colors.white,
        size: 50,
      ), // Icon hiển thị trong FloatingActionButton
    ),
  );
}
