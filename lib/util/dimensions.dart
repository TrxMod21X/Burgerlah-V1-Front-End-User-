import 'package:get/get.dart';

class Dimensions {
  static double screenHeight = Get.context.height;
  static double screenWidth = Get.context.width;

  static double fontSizeExtraSmall = screenWidth >= 1300 ? 14 : 10;
  static double fontSizeSmall = screenWidth >= 1300 ? 16 : 12;
  static double fontSizeDefault = screenWidth >= 1300 ? 18 : 14;
  static double fontSizeLarge = screenWidth >= 1300 ? 20 : 16;
  static double fontSizeExtraLarge = screenWidth >= 1300 ? 22 : 18;
  static double fontSizeOverLarge = screenWidth >= 1300 ? 28 : 24;

  static double popularPageView = screenHeight / 2.64;
  static double popularPageViewContainer = screenHeight / 3.84;
  static double popularPageViewTextContainer = screenHeight / 7.03;
  static double listViewImgSize = screenWidth / 3.25;
  static double listViewTextContSize = screenWidth / 3.9;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;
  static const double PADDING_SIZE_OVER_LARGE = 30.0;

  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double RADIUS_EXTRA_LARGE = 20.0;

  static const double WEB_MAX_WIDTH = 1170;
}
