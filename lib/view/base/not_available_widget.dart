import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotAvailableWidget extends StatelessWidget {
  final double fontSize;
  final bool isRestaurant;
  final Color color;
  final BorderRadiusGeometry border;

  NotAvailableWidget({
    this.fontSize = 8,
    this.isRestaurant = false,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: border ?? BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: color == null ? Colors.black.withOpacity(0.6) : color,
        ),
        child: Text(
          isRestaurant ? 'closed_now'.tr : 'not_available_now_break'.tr,
          textAlign: TextAlign.center,
          style:
              robotoRegular.copyWith(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
