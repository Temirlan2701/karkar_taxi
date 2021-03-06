import 'package:flutter/material.dart';
import 'package:taxi_app/brand_colors.dart';

class ProgressDialog extends StatelessWidget {

  final String status;

  ProgressDialog({this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),),
              SizedBox(width: 25,),
              Text(status, style: TextStyle(fontSize: 15),),
            ],
          ),
        ),
      ),
    );
  }
}
