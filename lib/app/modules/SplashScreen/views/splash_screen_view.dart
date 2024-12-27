import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.put untuk menginisialisasi controller
    Get.put(SplashScreenController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), // Gambar latar belakang
            fit: BoxFit.cover, // Agar gambar memenuhi layar
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
