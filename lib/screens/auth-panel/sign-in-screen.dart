// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/controllers/sign-in-controller.dart';
import 'package:first/screens/auth-panel/sign-up-screen.dart';
import 'package:first/screens/user-panel/main-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController useremail = TextEditingController();
  TextEditingController userpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, iskeyboradvisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appSecondaryColor,
          title: const Text(
            "Sign In",
            style: TextStyle(
                color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: Get.height / 30),
                iskeyboradvisible
                    ? const Text(
                        "Wecome to my app",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    : Column(
                        children: [
                          SizedBox(
                              height: 300,
                              child: Lottie.asset(
                                  'assets/images/splash-sales.json')),
                        ],
                      ),
                SizedBox(height: Get.height / 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: useremail,
                      cursorColor: AppConstant.appSecondaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        contentPadding:
                            const EdgeInsets.only(top: 2.0, left: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Obx(
                        () => TextFormField(
                          controller: userpassword,
                          obscureText: signInController.isPasswordVisible.value,
                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signInController.isPasswordVisible.toggle();
                              },
                              child: Icon(
                                  signInController.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "forget password?",
                    style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: Get.height / 30),
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        String email = useremail.text.trim();
                        String password = userpassword.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar("error", "Please fill all the fields",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor);
                        } else {
                          UserCredential? userCredential =
                              await signInController.signInMethod(
                                  email, password);
                          if (userCredential != null) {
                            
                            if (userCredential.user!.emailVerified) {
                              Get.snackbar("Success", "Login Successfully!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor);
                                  Get.offAll(()=> const Mainscreen());
                            } else {
                              Get.snackbar(
                                "error",
                                "Please verify your email",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                          } else {
                            Get.snackbar(
                              "error",
                              "Email or password is incorrect",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.appTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?  ",
                      style: TextStyle(color: AppConstant.appSecondaryColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => const SignupScreen()),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
