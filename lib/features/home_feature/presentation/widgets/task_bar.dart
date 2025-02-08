
import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskBar extends StatelessWidget {
  const TaskBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.all(20),
      height: screenHeight / 20,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed('/setting');
            },
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(255, 226, 223, 223),
            ),
            height: screenHeight / 10,
            //width: screenWidth / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //todo: add coins
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('data'),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://i.pinimg.com/736x/11/4b/19/114b19b343986be2290b2ff722383552.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
