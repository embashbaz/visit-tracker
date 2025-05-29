

import 'package:flutter/material.dart';

class Visitgroupicon extends StatelessWidget {
   Visitgroupicon({super.key, this.visitStatus});

  String? visitStatus;

  Color mainColor = Colors.blueAccent;

  Color secondaryColor = Colors.blueAccent.withValues(alpha: 0.5);

  IconData icon = Icons.list_alt_outlined;

  @override
  Widget build(BuildContext context) {

    if( visitStatus == "Pending"){
      mainColor = Colors.orange;
      secondaryColor = Colors.orange.withValues(alpha: 0.5);
      icon = Icons.pending_outlined;
    } else if(visitStatus == "Completed"){
      mainColor = Colors.green;
      secondaryColor = Colors.green.withValues(alpha: 0.5);
      icon = Icons.check_circle_outline;
    }else if(visitStatus == "Cancelled"){
      mainColor = Colors.red;
      secondaryColor = Colors.red.withValues(alpha: 0.5);
      icon = Icons.cancel_outlined;
    }


    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: secondaryColor),
      child: Icon(
        icon,
        color: mainColor,
        size: 24,
      ),
    );
  }
}
