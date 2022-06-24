import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/cart_page.dart';
import './pages/product_details_page.dart';
import './pages/products_overview_page.dart';
import './providers/cart.dart';
import './providers/product_providers.dart';
import './providers/orders.dart';
import './pages/orders_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_product_page.dart';
import './pages/auth_page.dart';
import './providers/auth.dart';
import './pages/splash_Screen_page.dart';
import './helpers/custom_route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProviders?>(
          create: (_) => ProductProviders(
            '',
            '',
            [],
          ),
          update: (context, auth, previousProductProviders) => ProductProviders(
            auth.token ?? '',
            auth.userId ?? '',
            previousProductProviders == null
                ? []
                : previousProductProviders.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })
          ),
          home: value.isAuth
              ? const ProductOverviewPage()
              : FutureBuilder(
                  future: value.autoLogIn(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthPage(),
                ),
          routes: {
            ProductDetailsPage.routeName: (context) =>
                const ProductDetailsPage(),
            CartPage.routeName: (context) => const CartPage(),
            OrdersPage.routeName: (context) => const OrdersPage(),
            UserProductsPage.routeName: (context) => const UserProductsPage(),
            EditProductPage.routeName: (context) => const EditProductPage(),
          },
        ),
      ),
    );
  }
}
