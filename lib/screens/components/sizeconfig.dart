import 'package:flutter/material.dart';

class SizeConfig{
  final double ? height;
  final double ? width;

  SizeConfig({this.width = 0, this.height = 0});

  SizeConfig.getSize(BuildContext context,
      {double ? heightPercent, double ? widthPercent})
  : this.height = (heightPercent ?? 0)/100*MediaQuery.of(context).size.height, this.width = (widthPercent ?? 0)/100*MediaQuery.of(context).size.width;

}