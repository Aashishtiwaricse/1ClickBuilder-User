import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Main/main.dart';
import 'package:one_click_builder/themes/Nexus/api/Sigin/sigin.dart';

class NexusSignInScreen extends StatefulWidget {
  const NexusSignInScreen({super.key});

  @override
  State<NexusSignInScreen> createState() => _NexusSignInScreenState();
}

class _NexusSignInScreenState extends State<NexusSignInScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final NexusAuthService authService = NexusAuthService();

  bool isLoading = false;

  Future<void> handleLogin() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await authService.login(
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      Get.snackbar(
        'Login Successful',
        'Welcome back!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      Get.offAll(() => NexusMain());
    } else {
      Get.snackbar(
        'Login Failed',
        'Invalid credentials',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),

            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Sign in with your email or phone number',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailCtrl,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordCtrl,
                    enabled: !isLoading,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: isLoading ? null : handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.purple,
                              ),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.purple),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              color: Colors.purple[300],
              padding: const EdgeInsets.symmetric(
                  vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  const Icon(Icons.person_add,
                      size: 40, color: Colors.white),

                  const SizedBox(height: 16),

                  const Text(
                    'New to Our Platform?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Join our growing community today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                    ),
                    onPressed: isLoading ? null : () {},
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
