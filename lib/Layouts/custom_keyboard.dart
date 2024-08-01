import 'package:flutter/material.dart';
import '../Layouts/otp_structure.dart';
import '../Resources/colors.dart';

class CustomKeyboard extends StatelessWidget {
  final OtpController controller;

  CustomKeyboard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int j = 1; j <= 3; j++)
                  NumberButton(
                    number: i * 3 + j,
                    onPressed: () => controller.handleInput(i * 3 + j),
                  ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 55),
              NumberButton(
                number: 0,
                onPressed: () => controller.handleInput(0),
              ),
              IconButton(
                icon: Icon(Icons.backspace, color: AppColors.white),
                onPressed: controller.handleBackspace,
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;

  NumberButton({required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 55,
        height: 55,
        alignment: Alignment.center,
        child: Text(
          number.toString(),
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
