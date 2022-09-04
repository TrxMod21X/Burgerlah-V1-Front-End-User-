import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/home/theme2/best_reviewed_item_view.dart';
import 'package:efood_multivendor/view/screens/home/theme2/category_view2.dart';
import 'package:efood_multivendor/view/screens/home/theme3/popular_item_view3.dart';
import 'package:efood_multivendor/view/screens/home/theme3/recommended_item_view3.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Theme3HomeScreen extends StatelessWidget {
  final ScrollController scrollController;

  const Theme3HomeScreen({Key key, @required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        /// APP BAR SECTION
        SliverAppBar(
          actions: [SizedBox()],
          floating: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ResponsiveHelper.isDesktop(context)
              ? Colors.transparent
              : Theme.of(context).backgroundColor,
          title: Center(
            child: Container(
              width: Dimensions.WEB_MAX_WIDTH,
              height: 50,
              color: Theme.of(context).backgroundColor,
              child: Row(
                children: [
                  /// LOCATION DETAIL SECTION
                  Expanded(
                    child: InkWell(
                      onTap: () => {
                        Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_SMALL,
                          horizontal: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.PADDING_SIZE_SMALL
                              : 0,
                        ),
                        child: GetBuilder<LocationController>(
                          builder: (locationController) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /// LOCATION TYPE ICON
                                Icon(
                                  locationController
                                              .getUserAddress()
                                              .addressType ==
                                          'home'
                                      ? Icons.home_filled
                                      : locationController
                                                  .getUserAddress()
                                                  .addressType ==
                                              'office'
                                          ? Icons.work
                                          : Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                                SizedBox(width: 10),

                                /// LOCATION POSITION TEXT
                                Flexible(
                                  child: Text(
                                    locationController.getUserAddress().address,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  /// NOTIFICATION SECTION
                  InkWell(
                    onTap: () =>
                        Get.toNamed(RouteHelper.getNotificationRoute()),
                    child: GetBuilder<NotificationController>(
                      builder: (notificationController) {
                        return Stack(
                          children: [
                            Icon(
                              Icons.notifications,
                              size: 25,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                            notificationController.hasNotification
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// SEARCH BUTTON SECTION
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
            child: Center(
              child: Container(
                height: 50,
                width: Dimensions.WEB_MAX_WIDTH,
                color: Theme.of(context).backgroundColor,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 800 : 200],
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Icon(
                          Icons.search,
                          size: 25,
                          color: Theme.of(context).hintColor,
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Expanded(
                          child: Text(
                            'search_food_or_restaurant'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// MAIN CONTENT SECTION
        SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: Column(
                children: [
                  PopularItemView3(),
                  CategoryView2(),
                  RecommendedItemView3(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

