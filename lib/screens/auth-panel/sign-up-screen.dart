// ignore_for_file: file_names, avoid_unnecessary_containers, unnecessary_null_comparison, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Authentication للتعامل مع تسجيل الدخول
import 'package:first/controllers/sign-up-controller.dart'; // استيراد وحدة التحكم لتسجيل المستخدمين
import 'package:first/screens/auth-panel/sign-in-screen.dart'; // استيراد شاشة تسجيل الدخول
import 'package:first/utils/app-constant.dart'; // استيراد الثوابت من ملف app-constant
import 'package:flutter/material.dart'; // استيراد مكتبة Flutter لبناء واجهات المستخدم
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // استيراد مكتبة لرصد حالة ظهور لوحة المفاتيح
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة

class SignupScreen extends StatefulWidget {
  // تعريف كلاس شاشة التسجيل
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState(); // إنشاء حالة الشاشة
}

class _SignupScreenState extends State<SignupScreen> {
  final SignUpController signUpController =
      Get.put(SignUpController()); // إنشاء كائن وحدة التحكم لتسجيل المستخدمين
  final _formKey = GlobalKey<FormState>(); // إنشاء مفتاح لنموذج البيانات
  TextEditingController username =
      TextEditingController(); // إنشاء وحدة التحكم لحقل اسم المستخدم
  TextEditingController useremail =
      TextEditingController(); // إنشاء وحدة التحكم لحقل البريد الإلكتروني
  TextEditingController userphone =
      TextEditingController(); // إنشاء وحدة التحكم لحقل رقم الهاتف
  TextEditingController usercity =
      TextEditingController(); // إنشاء وحدة التحكم لحقل المدينة
  TextEditingController userpassword =
      TextEditingController(); // إنشاء وحدة التحكم لحقل كلمة المرور

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, iskeyboradvisible) {
      // بناء واجهة المستخدم بناءً على حالة ظهور لوحة المفاتيح
      return Scaffold(
        appBar: AppBar(
          backgroundColor:
              AppConstant.appSecondaryColor, // تعيين لون خلفية شريط التطبيق
          title: const Text(
            "Sign UP", // عنوان شريط التطبيق
            style: TextStyle(
                color: AppConstant.appTextColor,
                fontWeight: FontWeight.bold), // تنسيق النص
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // تعيين فيزياء التمرير
          child: Container(
            child: Form(
              key: _formKey, // تعيين مفتاح النموذج
              child: Column(
                children: [
                  SizedBox(height: Get.height / 20), // إضافة مساحة عمودية
                  Container(
                    alignment: Alignment.center, // محاذاة المحتوى في المنتصف
                    child: const Text(
                      "Wecome to my app", // نص الترحيب
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor, // لون النص
                          fontWeight: FontWeight.bold, // وزن الخط
                          fontSize: 20), // حجم النص
                    ),
                  ),
                  SizedBox(height: Get.height / 20), // إضافة مساحة عمودية
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // تعيين هامش أفقي
                    width: Get.width, // تعيين عرض الحاوية
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // تعيين حشوة
                      child: TextFormField(
                        controller:
                            username, // تعيين وحدة التحكم لحقل اسم المستخدم
                        cursorColor:
                            AppConstant.appSecondaryColor, // تعيين لون المؤشر
                        keyboardType:
                            TextInputType.name, // تعيين نوع لوحة المفاتيح
                        decoration: InputDecoration(
                          hintText: "UserName", // نص التلميح
                          prefixIcon:
                              const Icon(Icons.person), // أيقونة البداية
                          contentPadding: const EdgeInsets.only(
                              top: 2.0, left: 8.0), // حشوة المحتوى
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // نصف قطر الزوايا للحقل
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your UserName';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // تعيين هامش أفقي
                    width: Get.width, // تعيين عرض الحاوية
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // تعيين حشوة
                      child: TextFormField(
                        controller:
                            userphone, // تعيين وحدة التحكم لحقل رقم الهاتف
                        cursorColor:
                            AppConstant.appSecondaryColor, // تعيين لون المؤشر
                        keyboardType:
                            TextInputType.number, // تعيين نوع لوحة المفاتيح
                        decoration: InputDecoration(
                          hintText: "Phone Number", // نص التلميح
                          prefixIcon: const Icon(Icons.phone), // أيقونة البداية
                          contentPadding: const EdgeInsets.only(
                              top: 2.0, left: 8.0), // حشوة المحتوى
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // نصف قطر الزوايا للحقل
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Phone Number';
                          }
                          if (value.length < 11 || value.length > 11) {
                            return 'Phone Number must be 11 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // تعيين هامش أفقي
                    width: Get.width, // تعيين عرض الحاوية
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // تعيين حشوة
                      child: TextFormField(
                        controller: usercity, // تعيين وحدة التحكم لحقل المدينة
                        cursorColor:
                            AppConstant.appSecondaryColor, // تعيين لون المؤشر
                        keyboardType: TextInputType
                            .streetAddress, // تعيين نوع لوحة المفاتيح
                        decoration: InputDecoration(
                          hintText: "City", // نص التلميح
                          prefixIcon:
                              const Icon(Icons.location_pin), // أيقونة البداية
                          contentPadding: const EdgeInsets.only(
                              top: 2.0, left: 8.0), // حشوة المحتوى
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // نصف قطر الزوايا للحقل
                          ),
                        ),

                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your City';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // تعيين هامش أفقي
                    width: Get.width, // تعيين عرض الحاوية
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // تعيين حشوة
                      child: TextFormField(
                        controller:
                            useremail, // تعيين وحدة التحكم لحقل البريد الإلكتروني
                        cursorColor:
                            AppConstant.appSecondaryColor, // تعيين لون المؤشر
                        keyboardType: TextInputType
                            .emailAddress, // تعيين نوع لوحة المفاتيح
                        decoration: InputDecoration(
                          hintText: "Email", // نص التلميح
                          prefixIcon: const Icon(Icons.email), // أيقونة البداية
                          contentPadding: const EdgeInsets.only(
                              top: 2.0, left: 8.0), // حشوة المحتوى
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // نصف قطر الزوايا للحقل
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid Email address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // تعيين هامش أفقي
                    width: Get.width, // تعيين عرض الحاوية
                    child: Padding(
                        padding: const EdgeInsets.all(10.0), // تعيين حشوة
                        child: Obx(
                          () => TextFormField(
                            controller:
                                userpassword, // تعيين وحدة التحكم لحقل كلمة المرور
                            obscureText: signUpController.isPasswordVisible
                                .value, // تعيين حالة إخفاء النص
                            cursorColor: AppConstant
                                .appSecondaryColor, // تعيين لون المؤشر
                            keyboardType: TextInputType
                                .visiblePassword, // تعيين نوع لوحة المفاتيح
                            decoration: InputDecoration(
                              hintText: "Password", // نص التلميح
                              prefixIcon:
                                  const Icon(Icons.password), // أيقونة البداية
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  signUpController.isPasswordVisible
                                      .toggle(); // تبديل حالة إخفاء النص
                                },
                                child: Icon(
                                    signUpController.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility), // أيقونة النهاية
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 2.0, left: 8.0), // حشوة المحتوى
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // نصف قطر الزوايا للحقل
                              ),
                            ),

                            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                          ),
                        )),
                  ),
                  SizedBox(height: Get.height / 30), // إضافة مساحة عمودية
                  Material(
                    child: Container(
                      width: Get.width / 2, // تعيين عرض الحاوية
                      height: Get.height / 18, // تعيين ارتفاع الحاوية
                      decoration: BoxDecoration(
                          color: AppConstant
                              .appSecondaryColor, // تعيين لون الخلفية
                          borderRadius: BorderRadius.circular(
                              20)), // نصف قطر الزوايا للحاوية
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                          String name = username.text
                              .trim(); // الحصول على النص من حقل اسم المستخدم
                          String email = useremail.text
                              .trim(); // الحصول على النص من حقل البريد الإلكتروني
                          String phone = userphone.text
                              .trim(); // الحصول على النص من حقل رقم الهاتف
                          String city = usercity.text
                              .trim(); // الحصول على النص من حقل المدينة
                          String password = userpassword.text
                              .trim(); // الحصول على النص من حقل كلمة المرور
                          String userDeviceToken =
                              ''; // تعيين قيمة فارغة لرمز جهاز المستخدم

                          if (name.isEmpty ||
                              email.isEmpty ||
                              phone.isEmpty ||
                              city.isEmpty ||
                              password.isEmpty) {
                            // التحقق من أن جميع الحقول ممتلئة
                            Get.snackbar(
                              'Error', // عنوان الرسالة
                              'Please fill all fields', // نص الرسالة
                              snackPosition:
                                  SnackPosition.BOTTOM, // تعيين موضع الرسالة
                              backgroundColor: AppConstant
                                  .appSecondaryColor, // تعيين لون خلفية الرسالة
                              colorText: AppConstant
                                  .appTextColor, // تعيين لون نص الرسالة
                            );
                          } else {
                            UserCredential? userCredential =
                                await signUpController.signUPMethod(
                                    name,
                                    email,
                                    phone,
                                    city,
                                    password,
                                    userDeviceToken); // استدعاء دالة التسجيل

                            if (UserCredential != null) {
                              // التحقق من نجاح عملية التسجيل
                              Get.snackbar(
                                'verification email sent', // عنوان الرسالة
                                'please verify your email', // نص الرسالة
                                snackPosition:
                                    SnackPosition.BOTTOM, // تعيين موضع الرسالة
                                backgroundColor: AppConstant
                                    .appSecondaryColor, // تعيين لون خلفية الرسالة
                                colorText: AppConstant
                                    .appTextColor, // تعيين لون نص الرسالة
                              );
                              FirebaseAuth.instance.signOut(); // تسجيل الخروج
                              Get.offAll(() =>
                                  const SigninScreen()); // الانتقال إلى شاشة تسجيل الدخول
                            } else {
                              Get.snackbar(
                                'Error', // عنوان الرسالة
                                'Please check the entered data.', // نص الرسالة
                                snackPosition:
                                    SnackPosition.BOTTOM, // تعيين موضع الرسالة
                                backgroundColor: AppConstant
                                    .appSecondaryColor, // تعيين لون خلفية الرسالة
                                colorText: AppConstant
                                    .appTextColor, // تعيين لون نص الرسالة
                              );
                            }
                          }
                          }
                        },
                        child: const Text(
                          "Sign Up", // نص الزر
                          style: TextStyle(
                              fontSize: 20, // حجم النص
                              fontWeight: FontWeight.bold, // وزن الخط
                              color: AppConstant.appTextColor), // لون النص
                          textAlign: TextAlign.center, // محاذاة النص في المنتصف
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 30), // إضافة مساحة عمودية
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // محاذاة العناصر في المنتصف
                    children: [
                      const Text(
                        "Already have an account?  ", // نص السؤال
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor), // لون النص
                      ),
                      GestureDetector(
                        onTap: () => Get.offAll(() =>
                            const SigninScreen()), // الانتقال إلى شاشة تسجيل الدخول عند النقر
                        child: const Text(
                          "Sign In", // نص الرابط
                          style: TextStyle(
                              color: AppConstant.appSecondaryColor, // لون النص
                              fontWeight: FontWeight.bold, // وزن الخط
                              fontSize: 20), // حجم النص
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
