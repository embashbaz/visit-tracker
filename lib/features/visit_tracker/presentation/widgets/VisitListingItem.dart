import 'package:flutter/material.dart';

import '../../../../common/size_config.dart';
import '../../../../common/time_utils.dart';
import '../../domain/model/Visit.dart';
import 'VisitGroupIcon.dart';

class Visitlistingitem extends StatelessWidget {
  Visitlistingitem({super.key, required this.visit});
  final Visit visit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visitgroupicon(visitStatus: visit.status),
              SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.customer?.name ?? visit.location ?? "N/A",
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600 ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                    Text(
                      formatTimeToStandard(visit.visitDate ?? visit.createdAt),
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400 ),
                      textAlign: TextAlign.justify
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          Container(height: 1, width: double.infinity, color: Colors.grey.withValues(alpha: 0.3),)
        ],
      ),
    );
  }
}