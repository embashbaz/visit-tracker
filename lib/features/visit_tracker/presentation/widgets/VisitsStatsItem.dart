

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/size_config.dart';
import 'VisitGroupIcon.dart';

class Visitsstatsitem extends StatelessWidget {
   Visitsstatsitem({super.key, this.status, this.count, this.text});

  String? status;

  int? count;

  String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visitgroupicon(
          visitStatus: status,
        ),
        SizedBox(
          height:  SizeConfig.blockSizeVertical,
        ),
        Text(
          count?.toString() ?? "",
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600 ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),
        Text(
          text ?? "",
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400 ),
          textAlign: TextAlign.center,
        ),
      ]
    );
  }
}
