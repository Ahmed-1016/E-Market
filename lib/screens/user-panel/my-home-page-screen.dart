import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:first/screens/user-panel/all-categories-screen.dart';
import 'package:first/screens/user-panel/all-flash-sale-products-screen.dart';
import 'package:first/screens/user-panel/cart-screen.dart';
import 'package:first/screens/user-panel/user-main-screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 3);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 3);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      CartScreen(),
      AllFlashSaleProductsScreen(),
      AllCategoriesScreen(),
      UserMainScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              // notchShader: const SweepGradient(
              //   shopping_carttAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.black87,

              // / reshopping_cartt app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: true,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 12),

              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem:
                      Icon(Icons.shopping_cart, color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.shopping_cart,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'عربة التسوق',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.card_giftcard,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.card_giftcard,
                    color: Colors.pink,
                  ),
                  itemLabel: 'العروض',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.category,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.category,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'الاقسام',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.storefront,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.storefront,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'الرئيسية',
                ),
              ],
              onTap: (index) {
                print('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

// class Page2 extends StatelessWidget {
//   const Page2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.green, child: const Center(child: Text('Page 2')));
//   }
// }
