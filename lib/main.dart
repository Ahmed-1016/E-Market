import 'package:first/screens/auth-panel/splash-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized(); //تأكيد تهيئة الواجهة
  await Firebase.initializeApp( //تهيئة firebase
    options: DefaultFirebaseOptions.currentPlatform, //اضافة الخيارات
  );
  runApp(const MyApp());  //تشغيل التطبيق
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  //البناء

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false, //ازالة علامة debug
      title: 'E-Market',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),  //الشاشة الرئيسية
      builder: EasyLoading.init(),     //تهيئة الloading
    );
  }
}
