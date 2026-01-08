import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/register/controllers/register_controller.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

import 'package:godevi_app/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  // Access AuthController for social login
  AuthController get _authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo Placeholder
            // User design has a bird + Godevi text.
            // I'll try to find if there is an asset or build a text logo.
            _buildLogo(),
            const SizedBox(height: 40),
            _buildInput(
              hint: 'Your Name',
              controller: controller.nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: 'Your Email',
              controller: controller.emailController,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: 'Password',
              controller: controller.passwordController,
              icon: Icons.vpn_key_outlined, // closest to key
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: 'Repeat your password',
              controller: controller.repeatPasswordController,
              icon: Icons.vpn_key_outlined,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.isTermsAgreed.value,
                    onChanged: (val) => controller.isTermsAgreed.value = val!,
                    activeColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree all statements in ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      children: const [
                        TextSpan(
                          text: 'Terms of service',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('OR', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _authController.signInWithFacebook(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3b5998),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.facebook, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Facebook', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _authController.signInWithGoogle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Google', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/godevi_logo_full.png', height: 80),
    );
  }

  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ), // No horizontal padding needed if prefixIcon is used?
          // Actually prefixIcon takes space.
        ),
      ),
    );
  }
}
