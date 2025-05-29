

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visit_tracker/common/size_config.dart';

import 'loading_button.dart';

bool isDialogVisible = false;
void onError(String message, BuildContext context,
    {Function? onSuccess, Function? onErrorResult}) async {

    if(!isDialogVisible) {
      isDialogVisible = true;
      showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          enableDrag: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)),
          ),
          builder: (BuildContext context) {
            return showStatus(
              context,
              "Error",
              message,
              "Cancel",
              Icons.cancel,
              Colors.orangeAccent,);
          }).then((value){
        isDialogVisible = false;
        onErrorResult?.call();
        //Navigator.pop(context);
      });

    }

}

Widget showStatus(
    BuildContext context, String title, String text, String btText, IconData icon, Color iconColor) {
  return Padding(
      padding: EdgeInsets.only(
          top: 16, left: 16, right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 4),
          Flexible(child: Icon(icon,color: iconColor, size: 76)),
          SizedBox(height: SizeConfig.blockSizeVertical! * 2),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 4),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 26, right: 26, bottom: 30),
            child: LoadingMainBt(
              name: btText,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 4),
        ],
      ));
}

