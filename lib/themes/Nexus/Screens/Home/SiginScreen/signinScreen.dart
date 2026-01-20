import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/themes/Nexus/Main/main.dart';
import 'package:one_click_builder/themes/Nexus/Screens/RegisterAccount/regiisterAccount.dart';
import 'package:one_click_builder/themes/Nexus/api/Sigin/sigin.dart';

class NexusSignInScreen extends StatefulWidget {
  const NexusSignInScreen({super.key});

  @override
  State<NexusSignInScreen> createState() => _NexusSignInScreenState();
}

class _NexusSignInScreenState extends State<NexusSignInScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final NexusAuthService authService = NexusAuthService();
  bool showPassword = false;
  bool isEmailLogin = true;
  bool isLoading = false;

  String selectedCode = "+91";

  Future<void> handleLogin() async {
    String password = passwordCtrl.text.trim();

    if (password.isEmpty) {
      errorSnack("Password is required");
      return;
    }

    String input = "";

    if (isEmailLogin) {
      input = emailCtrl.text.trim();
      if (input.isEmpty || !GetUtils.isEmail(input)) {
        errorSnack("Please enter a valid email");
        return;
      }
    } else {
      input = phoneCtrl.text.trim();

      if (input.isEmpty || input.length < 10) {
        errorSnack("Please enter a valid phone number");
        return;
      }

input = "$selectedCode$input"; // correct
    }

    setState(() => isLoading = true);

    bool success = await authService.login(input, password);

    setState(() => isLoading = false);

    if (success) {
      Get.snackbar(
        'Login Successful',
        'Welcome back!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      Get.offAll(() => NexusMain());
    } else {
      errorSnack("Invalid credentials");
    }
  }

  void errorSnack(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    phoneCtrl.dispose();
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
              'Sign in with your email or phone',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // ---------------- Toggle Buttons ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("Email Login"),
                    selected: isEmailLogin,
                    onSelected: (_) {
                      setState(() => isEmailLogin = true);
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("Phone Login"),
                    selected: !isEmailLogin,
                    onSelected: (_) {
                      setState(() => isEmailLogin = false);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // ---------------- Email Field ----------------
                  if (isEmailLogin)
                    TextField(
                      controller: emailCtrl,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                  // ---------------- Phone Field with Country Code ----------------
                  if (!isEmailLogin)
                    IntlPhoneField(
                      controller: phoneCtrl,
                      initialCountryCode: "IN",
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (phone) {
                        selectedCode = "${phone.countryCode}";

                        print("${phone.countryCode}");
                        phoneCtrl.text = phone.number;
                      },
                    ),

                  const SizedBox(height: 16),

                  // ---------------- Password Field ----------------
                  TextField(
                    controller: passwordCtrl,
                    enabled: !isLoading,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => showPassword = !showPassword);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- Login Button ----------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

            // ---------------- Bottom Register Box ----------------
            Container(
              width: double.infinity,
              color: Colors.purple[300],
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  const Icon(Icons.person_add, size: 40, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'New to Our Platform?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    ),
                    onPressed: () => Get.to(() => CreateAccountScreen()),
                    child: const Text('Create Account', style: TextStyle(color: Colors.white)),
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




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_click_builder/themes/Nexus/Main/main.dart';
// import 'package:one_click_builder/themes/Nexus/Screens/RegisterAccount/regiisterAccount.dart';
// import 'package:one_click_builder/themes/Nexus/api/Sigin/sigin.dart';

// class NexusSignInScreen extends StatefulWidget {
//   const NexusSignInScreen({super.key});

//   @override
//   State<NexusSignInScreen> createState() => _NexusSignInScreenState();
// }

// class _NexusSignInScreenState extends State<NexusSignInScreen> {
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//   final NexusAuthService authService = NexusAuthService();
// bool showPassword = false;

//   bool isLoading = false;
// Future<void> handleLogin() async {
//   String input = emailCtrl.text.trim();
//   String password = passwordCtrl.text.trim();

//   if (input.isEmpty || password.isEmpty) {
//     Get.snackbar(
//       'Error',
//       'Email/Phone and password are required',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//     return;
//   }

//   // If input contains only numbers → treat as phone number
//   if (RegExp(r'^[0-9]+$').hasMatch(input)) {
//     if (!input.startsWith('+91')) {
//       input = '+91$input';
//     }
//     print("Login with phone: $input");
//   } else {
//     print("Login with email: $input");
//   }

//   setState(() => isLoading = true);

//   bool success = await authService.login(
//     input,   // email OR +91 phone
//     password,
//   );

//   setState(() => isLoading = false);

//   if (success) {
//     Get.snackbar(
//       'Login Successful',
//       'Welcome back!',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//     );

//     Get.offAll(() => NexusMain());
//   } else {
//     Get.snackbar(
//       'Login Failed',
//       'Invalid credentials',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }


//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passwordCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 100),

//             CircleAvatar(
//               radius: 40,
//               backgroundColor: Colors.blue[100],
//               child: const Icon(Icons.person, size: 50, color: Colors.white),
//             ),

//             const SizedBox(height: 20),

//             const Text(
//               'Welcome Back',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 8),

//             Text(
//               'Sign in with your email or phone number',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),

//             const SizedBox(height: 30),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 children: [
//                   TextField(
//   controller: emailCtrl,
//   enabled: !isLoading,
//   keyboardType: TextInputType.emailAddress,
//   decoration: InputDecoration(
//     prefixIcon: const Icon(Icons.person),
//     hintText: 'Email or Phone Number',
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     contentPadding: const EdgeInsets.symmetric(vertical: 16),
//   ),
// ),


//                   const SizedBox(height: 16),

//                   TextField(
//   controller: passwordCtrl,
//   enabled: !isLoading,
//   obscureText: !showPassword, // 👈 show/hide logic
//   decoration: InputDecoration(
//     prefixIcon: const Icon(Icons.lock),
//     hintText: 'Enter your password',
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     contentPadding: const EdgeInsets.symmetric(vertical: 16),

//     // 👇 show/hide icon
//     suffixIcon: IconButton(
//       icon: Icon(
//         showPassword ? Icons.visibility : Icons.visibility_off,
//       ),
//       onPressed: () {
//         setState(() {
//           showPassword = !showPassword;
//         });
//       },
//     ),
//   ),
// ),


//                   const SizedBox(height: 16),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink[100],
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: isLoading ? null : handleLogin,
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.purple,
//                               ),
//                             )
//                           : const Text(
//                               'Sign In',
//                               style: TextStyle(color: Colors.purple),
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),

//             Container(
//               width: double.infinity,
//               color: Colors.purple[300],
//               padding: const EdgeInsets.symmetric(
//                   vertical: 40, horizontal: 24),
//               child: Column(
//                 children: [
//                   const Icon(Icons.person_add,
//                       size: 40, color: Colors.white),

//                   const SizedBox(height: 16),

//                   const Text(
//                     'New to Our Platform?',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   const Text(
//                     'Join our growing community today!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white),
//                   ),

//                   const SizedBox(height: 16),

//                OutlinedButton(
//   style: OutlinedButton.styleFrom(
//     side: const BorderSide(color: Colors.white),
//     padding: const EdgeInsets.symmetric(
//       vertical: 16,
//       horizontal: 40,
//     ),
//   ),
//   onPressed: isLoading
//       ? null
//       : () {
//           Get.to(() => CreateAccountScreen());
//         },
//   child: const Text(
//     'Create Account',
//     style: TextStyle(color: Colors.white),
//   ),
// )

//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
