import 'dart:developer';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularItemView3 extends StatefulWidget {
  const PopularItemView3({Key key}) : super(key: key);

  @override
  State<PopularItemView3> createState() => _PopularItemView3State();
}

class _PopularItemView3State extends State<PopularItemView3> {
  PageController _pageController = PageController(viewportFraction: 0.85);
  double _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.popularPageViewContainer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currPageValue = _pageController.page;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _productList = productController.reviewedProductList;

      return (_productList != null)
          ? Column(
              children: [
                /// SLIDER POPULAR FOOD SECTION
                Padding(
                  padding:
                      EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                  child: SizedBox(
                    height: Dimensions.popularPageView,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount:
                          _productList.length > 8 ? 8 : _productList.length,
                      itemBuilder: (context, position) {
                        return _buildPopularItem(
                          position,
                          _productList[position],
                          productController,
                        );
                      },
                    ),
                  ),
                ),

                DotsIndicator(
                  dotsCount: _productList.length > 8 ? 8 : _productList.length,
                  position: _currPageValue,
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).primaryColor,
                    color: Colors.grey,
                    size: const Size.square(9),
                    activeSize: const Size(18, 9),
                    activeShape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE),
                    ),
                  ),
                )
              ],
            )
          : PopularItemShimmer();
    });
  }

  Widget _buildPopularItem(
      int position, Product popularProduct, ProductController controller) {
    Matrix4 matrix4 = Matrix4.identity();
    if (position == _currPageValue.floor()) {
      double currScale = 1 - (_currPageValue - position) * (1 - _scaleFactor);
      double currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position == _currPageValue.floor() + 1) {
      double currScale =
          _scaleFactor + (_currPageValue - position + 1) * (1 - _scaleFactor);
      double currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1);
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position == _currPageValue.floor() - 1) {
      double currScale = 1 - (_currPageValue - position) * (1 - _scaleFactor);
      double currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1);
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      double currScale = 0.8;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix4,
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
                  ProductBottomSheet(
                      product: popularProduct, isCampaign: false),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                )
              : Get.dialog(
                  Dialog(child: ProductBottomSheet(product: popularProduct)),
                );
        },
        child: Stack(
          children: [
            Container(
              height: Dimensions.popularPageViewContainer,
              margin: EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_SMALL,
                right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.RADIUS_DEFAULT * 3),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${popularProduct.image}',
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Colors.transparent,
                  ),
                  DiscountTag(
                    discount: controller.getDiscount(popularProduct),
                    discountType: controller.getDiscountType(popularProduct),
                  ),
                  controller.isAvailable(popularProduct)
                      ? SizedBox()
                      : NotAvailableWidget(
                          fontSize: Dimensions.fontSizeDefault),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.popularPageViewTextContainer,
                margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_OVER_LARGE,
                  right: Dimensions.PADDING_SIZE_OVER_LARGE,
                  bottom: Dimensions.PADDING_SIZE_OVER_LARGE,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).hintColor,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Theme.of(context).hintColor,
                      offset: Offset(-5, 0),
                    ),
                    BoxShadow(
                      color: Theme.of(context).hintColor,
                      offset: Offset(5, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: Dimensions.PADDING_SIZE_DEFAULT,
                        right: Dimensions.PADDING_SIZE_DEFAULT,
                        left: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Column(
                        children: [
                          Text(
                            popularProduct.name,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge + 2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          RatingBar(
                            rating: popularProduct.avgRating,
                            ratingCount: popularProduct.ratingCount,
                            size: 15,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    popularProduct.discount > 0
                                        ? Flexible(
                                            child: Text(
                                              PriceConverter.convertPrice(
                                                controller.getStartingPrice(
                                                    popularProduct),
                                              ),
                                              style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .errorColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      width: popularProduct.discount > 0
                                          ? Dimensions.PADDING_SIZE_SMALL
                                          : 0,
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(
                                        controller
                                            .getStartingPrice(popularProduct),
                                        discount: popularProduct.discount,
                                        discountType:
                                            popularProduct.discountType,
                                      ),
                                      style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  ],
                                ),
                              ),
                              Text(popularProduct.restaurantName)
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: Icon(Icons.add, size: 20, color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularItemShimmer extends StatelessWidget {
  const PopularItemShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.popularPageView,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, position) {
          return Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.all(10),
            color: Colors.red,
          );
        },
      ),
    );
  }
}
