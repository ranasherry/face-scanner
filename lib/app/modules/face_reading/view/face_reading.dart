import 'package:dotted_border/dotted_border.dart';
import 'package:face_scanner/app/data/response_status.dart';
import 'package:face_scanner/app/modules/face_reading/controller/face_reading_ctl.dart';
import 'package:face_scanner/app/modules/home/views/helping_widgets/gems_widget.dart';
import 'package:face_scanner/app/modules/home/views/scanner_widget.dart';
import 'package:face_scanner/app/providers/admob_ads_provider.dart';
import 'package:face_scanner/app/routes/app_pages.dart';
import 'package:face_scanner/app/utills/colors.dart';
import 'package:face_scanner/app/utills/gems_rate.dart';
import 'package:face_scanner/app/utills/helping_methods.dart';
import 'package:face_scanner/app/utills/images.dart';
import 'package:face_scanner/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class FaceReading extends GetView<FaceReadingCtl> {
  const FaceReading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Obx(() => controller.responseStatus.value == ResponseStatus.success
              ? BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changeTabIndex,
                  items: [
                    nav_bar(AppImages.face, "Face"),
                    nav_bar(AppImages.lips, "Lips"),
                    nav_bar(AppImages.eyes, "Eyes"),
                    nav_bar(AppImages.nose, "Nose"),
                    nav_bar(AppImages.eyebrows, "EyeBrows"),
                  ],
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: Colors.grey,
                )
              : Container(
                  height: 0,
                )),
      appBar: AppBar(
        title: Text(
          "Face Reading",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
            onTap: () {
              AdMobAdsProvider.instance.showInterstitialAd(() {});
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 2),
            child: gems_widget(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => Stack(
                children: [
                  controller.selectedImage.value != null
                      ? Container(
                          width: double.infinity,
                          height: 300,
                          child: Image.file(
                            controller.selectedImage.value!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 300,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade200),
                          child: Center(
                            child: Text(
                              "Add Image",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                  Positioned(
                    right: 16.0,
                    bottom: 16.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Choose Image',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              await controller.pickImage(
                                                  ImageSource.camera);
                                              Get.back();

                                              // Get.to(() => ScannerWidget());
                                            },
                                            child: _buildImageOption(
                                                Icons.camera_alt, 'Camera')),
                                        GestureDetector(
                                            onTap: () async {
                                              await controller.pickImage(
                                                  ImageSource.gallery);
                                              Get.back();

                                              // Get.to(() => ScannerWidget());
                                            },
                                            child: _buildImageOption(
                                                Icons.image, 'Gallery')),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(16),
            Obx(() => controller.responseStatus.value == ResponseStatus.success
                ? Container(
                    height: 240,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        controller.selectedFeature.value,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  )
                : Container()),
            Obx(() => controller.selectedImage.value != null &&
                    controller.responseStatus.value == ResponseStatus.idle
                ? GestureDetector(
                    onTap: () {
                      if (GEMS_RATE.remianingGems.value >=
                          GEMS_RATE.FaceReadingGems) {
                        controller.startScanningImage(
                            controller.selectedImage.value!);
                        (controller.selectedImage.value!);
                      } else {
                        // Show a toast message for insufficient gems
                        HelpingMethods.instance.ShowNoGemsToast();
                        Get.toNamed(Routes.GEMSVIEW);
                      }
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 6.5,
                      width: SizeConfig.blockSizeHorizontal * 70,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          // color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start Reading",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 5,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Text(
                                " (${GEMS_RATE.FaceReadingGems} x ",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Image.asset(
                                AppImages.gems,
                                height: SizeConfig.blockSizeVertical * 2.5,
                              ),
                              Text(
                                ")",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Container()),
            verticalSpace(SizeConfig.blockSizeVertical),
            Obx(() => controller.selectedImage.value != null &&
                    controller.responseStatus.value == ResponseStatus.success
                ? GestureDetector(
                    onTap: () {
                      if (GEMS_RATE.remianingGems.value >=
                          GEMS_RATE.FaceReadingGems) {
                        controller.startScanningImage(
                            controller.selectedImage.value!);
                        (controller.selectedImage.value!);
                      } else {
                        // Show a toast message for insufficient gems
                        HelpingMethods.instance.ShowNoGemsToast();
                        Get.toNamed(Routes.GEMSVIEW);
                      }
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 6.5,
                      width: SizeConfig.blockSizeHorizontal * 70,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          // color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Try Again",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 5,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Text(
                                " (${GEMS_RATE.FaceReadingGems} x ",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Image.asset(
                                AppImages.gems,
                                height: SizeConfig.blockSizeVertical * 2.5,
                              ),
                              Text(
                                ")",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Container()),
            Obx(() => controller.selectedImage.value != null &&
                    controller.responseStatus.value == ResponseStatus.success
                ? Container()
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        // height: SizeConfig.blockSizeVertical * 30,
                        width: SizeConfig.blockSizeHorizontal * 60,
                        decoration: BoxDecoration(),
                        child: Lottie.asset("assets/lottie/add_image.json"),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 70,
                        child: Text(
                            "Show us your smile and uncover what your face says about you! 🌈"),
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem nav_bar(String image, String text) {
    return BottomNavigationBarItem(
        icon: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
            ),
            child: Image.asset(
              image,
              width: SizeConfig.blockSizeHorizontal * 9,
              fit: BoxFit.fill,
            )),
        label: text);
  }

  Widget _buildImageOption(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon,
            color: Colors.green, size: SizeConfig.blockSizeHorizontal * 10),
        verticalSpace(SizeConfig.blockSizeVertical * 1),
        Text(label,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5)),
      ],
    );
  }
}
