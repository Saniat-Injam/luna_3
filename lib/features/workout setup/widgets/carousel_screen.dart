import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:barbell/features/workout%20setup/controller/carousel_state_controller.dart';


class CarouselScreen extends StatelessWidget {
  const CarouselScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselStateController controller = Get.find<CarouselStateController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
         
height: 322,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.6,  
            onPageChanged: (index, reason) {
              controller.onPageChanged(index);
            },
          ),
          items: controller.imageList.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Failed to load image'));
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        // SizedBox(height: 20),
        // Obx(() => Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: List.generate(controller.imageList.length, (index) {
        //         return Container(
        //           width: 8.0,
        //           height: 8.0,
        //           margin: EdgeInsets.symmetric(horizontal: 4.0),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: controller.currentIndex.value == index
        //                 ? Colors.blueAccent
        //                 : Colors.grey,
        //           ),
        //         );
        //       }),
        //     )),
      ],
    );
  }
}
