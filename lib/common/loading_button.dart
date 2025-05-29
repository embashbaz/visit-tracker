import 'package:flutter/material.dart';

class LoadingMainBt extends StatelessWidget {
  final String name;
  bool isLoading;
  final VoidCallback onPressed;
  Color buttonColor;
  Color textColor;

  LoadingMainBt({Key? key, required this.name, required this.onPressed, this.isLoading = false, this.buttonColor = Colors.blueAccent, this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Align(alignment: Alignment.center, child: CircularProgressIndicator()) : Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child:  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            textStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            animationDuration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // <-- Radius
            )),
        child: Text(name),
      ),) ;
  }
}