import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Color(0xFF15C8CF), borderRadius: BorderRadius.circular(9)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: const Color.fromARGB(255, 239, 235, 235), fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}