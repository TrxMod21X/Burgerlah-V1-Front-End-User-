import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedItemView3 extends StatelessWidget {
  const RecommendedItemView3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _productList = productController.popularProductList;

      return (_productList.length != null)
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: TitleWidget(title: 'recommended_food'.tr),
                ),
                _productList.length != 0
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _productList.length ?? 0,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              ResponsiveHelper.isMobile(context)
                                  ? Get.bottomSheet(
                                      ProductBottomSheet(
                                          product: _productList[index],
                                          isCampaign: false),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    )
                                  : Get.dialog(
                                      Dialog(
                                        child: ProductBottomSheet(
                                            product: _productList[index]),
                                      ),
                                    );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: Dimensions.PADDING_SIZE_DEFAULT,
                                left: Dimensions.PADDING_SIZE_DEFAULT,
                                bottom: Dimensions.PADDING_SIZE_DEFAULT,
                              ),
                              child: Row(
                                children: [
                                  /// IMAGE SECTION
                                  Container(
                                    width: Dimensions.listViewImgSize,
                                    height: Dimensions.listViewImgSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_EXTRA_LARGE),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${_productList[index].image}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            Images.placeholder,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        DiscountTag(
                                          discount:
                                              _productList[index].discount,
                                          discountType:
                                              _productList[index].discountType,
                                          inLeft: false,
                                        ),
                                        productController.isAvailable(
                                                _productList[index])
                                            ? SizedBox()
                                            : NotAvailableWidget(
                                                isRestaurant: true,
                                                border: BorderRadius.circular(
                                                    Dimensions
                                                        .RADIUS_EXTRA_LARGE),
                                              ),
                                      ],
                                    ),
                                  ),

                                  /// TEXT CONTAINER
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewTextContSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              Dimensions.RADIUS_EXTRA_LARGE),
                                          bottomRight: Radius.circular(
                                              Dimensions.RADIUS_EXTRA_LARGE),
                                        ),
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                              right:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _productList[index].name ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                Text(
                                                  _productList[index]
                                                          .restaurantName ??
                                                      '',
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                Row(
                                                  children: [
                                                    productController.getDiscount(
                                                                _productList[
                                                                    index]) >
                                                            0
                                                        ? Flexible(
                                                            child: Text(
                                                            PriceConverter.convertPrice(
                                                                productController
                                                                    .getStartingPrice(
                                                                        _productList[
                                                                            index])),
                                                            style: robotoRegular
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ))
                                                        : SizedBox(),
                                                    SizedBox(
                                                        width: _productList[
                                                                        index]
                                                                    .discount >
                                                                0
                                                            ? Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL
                                                            : 0),
                                                    Text(
                                                      PriceConverter
                                                          .convertPrice(
                                                        productController
                                                            .getStartingPrice(
                                                                _productList[
                                                                    index]),
                                                        discount:
                                                            productController
                                                                .getDiscount(
                                                                    _productList[
                                                                        index]),
                                                        discountType:
                                                            productController
                                                                .getDiscountType(
                                                          _productList[index],
                                                        ),
                                                      ),
                                                      style: robotoMedium,
                                                    ),
                                                    SizedBox(
                                                        width: Dimensions
                                                            .PADDING_SIZE_DEFAULT),
                                                    RatingBar(
                                                      rating:
                                                          _productList[index]
                                                              .avgRating,
                                                      ratingCount:
                                                          _productList[index]
                                                              .ratingCount,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Icon(Icons.add,
                                                  size: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                    : Container(
                        width: 10,
                        height: 10,
                      ),
              ],
            )
          : SizedBox();
    });
  }
}
