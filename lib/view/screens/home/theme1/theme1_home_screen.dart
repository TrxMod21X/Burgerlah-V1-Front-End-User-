import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/paginated_list_view.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/home/theme1/banner_view.dart';
import 'package:efood_multivendor/view/screens/home/theme1/category_view.dart';
import 'package:efood_multivendor/view/screens/home/theme1/item_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/theme1/popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/theme1/popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Theme1HomeScreen extends StatelessWidget {
  const Theme1HomeScreen({
    Key key,
    @required ScrollController scrollController,
    @required ConfigModel configModel,
  })  : _scrollController = scrollController,
        _configModel = configModel,
        super(key: key);

  final ScrollController _scrollController;
  final ConfigModel _configModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
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
            child: Row(children: [
              Expanded(
                  child: InkWell(
                onTap: () =>
                    Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
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
                        Icon(
                          locationController.getUserAddress().addressType ==
                                  'home'
                              ? Icons.home_filled
                              : locationController
                                          .getUserAddress()
                                          .addressType ==
                                      'office'
                                  ? Icons.work
                                  : Icons.location_on,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            locationController.getUserAddress().address,
                            style: robotoRegular.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ],
                    );
                  }),
                ),
              )),
              InkWell(
                child: GetBuilder<NotificationController>(
                    builder: (notificationController) {
                  return Stack(children: [
                    Icon(Icons.notifications,
                        size: 25,
                        color: Theme.of(context).textTheme.bodyText1.color),
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
                                    color: Theme.of(context).cardColor),
                              ),
                            ))
                        : SizedBox(),
                  ]);
                }),
                onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
              ),
            ]),
          )),
        ),

        // Search Button
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
              child: Center(
                  child: Container(
            height: 50,
            width: Dimensions.WEB_MAX_WIDTH,
            color: Theme.of(context).backgroundColor,
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: InkWell(
              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 200],
                        spreadRadius: 1,
                        blurRadius: 5)
                  ],
                ),
                child: Row(children: [
                  Icon(Icons.search,
                      size: 25, color: Theme.of(context).primaryColor),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Expanded(
                      child: Text('search_food_or_restaurant'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ))),
                ]),
              ),
            ),
          ))),
        ),

        SliverToBoxAdapter(
          child: Center(
              child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              BannerView(),
              CategoryView(),
              _configModel.popularRestaurant == 1
                  ? PopularRestaurantView(isPopular: true)
                  : SizedBox(),
              ItemCampaignView(),
              _configModel.popularFood == 1
                  ? PopularFoodView(isPopular: true)
                  : SizedBox(),
              _configModel.newRestaurant == 1
                  ? PopularRestaurantView(isPopular: false)
                  : SizedBox(),
              _configModel.mostReviewedFoods == 1
                  ? PopularFoodView(isPopular: false)
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 5),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    'all_restaurants'.tr,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge),
                  )),
                  FilterView(),
                ]),
              ),
              GetBuilder<RestaurantController>(builder: (restaurantController) {
                return PaginatedListView(
                  scrollController: _scrollController,
                  totalSize: restaurantController.restaurantModel != null
                      ? restaurantController.restaurantModel.totalSize
                      : null,
                  offset: restaurantController.restaurantModel != null
                      ? restaurantController.restaurantModel.offset
                      : null,
                  onPaginate: (int offset) async => await restaurantController
                      .getRestaurantList(offset, false),
                  productView: ProductView(
                    isRestaurant: true,
                    products: null,
                    restaurants: restaurantController.restaurantModel != null
                        ? restaurantController.restaurantModel.restaurants
                        : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                          : Dimensions.PADDING_SIZE_SMALL,
                      vertical: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                          : 0,
                    ),
                  ),
                );
              }),
            ]),
          )),
        ),
      ],
    );
  }
}
