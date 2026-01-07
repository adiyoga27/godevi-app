import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class AboutView extends GetView {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'About Godevi',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo placeholder
            // Logo
            Image.asset(
              'assets/images/godevi_logo_full.png',
              height: 120, // Adjusted height for better visibility
            ),
            const SizedBox(height: 30),
            const Text(
              'GODEVI is a company under of PT Banua Wisata Lestari. GODEVI stands for Go Destination Village. The GODEVI logo is inspired by Bali Starling birds. Bali Starling is represented as one of the rare and unique natural potentials. The colors that appear in the GODEVI logo are cheerful colors that represent tourist activities full of joyful experiences. GODEVI believes that the village as a gathering place for all potentials, each has a different uniqueness and deserves to be introduced to the world community. Like this Bali Starling, GODEVI hopes to be able to become a distinctive brand without losing the identity of the island of Bali. In addition, the starling star is green, which means that GODEVI as a digital-based business is expected to be able to use its mind to see all the opportunities and phenomena that occur while being oriented to environmental sustainability and always prioritizing spirit (SEE) Sustainability, Empowerment and Entrepreneurship.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40),
            Text('Version 1.0.0', style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}
