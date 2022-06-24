import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/orders_page.dart';
import '../pages/user_products_page.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersPage.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => const OrdersPage(),
              //   ),
              // );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsPage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              // Navigator.of(context).pushReplacementNamed(UserProductsPage.routeName);
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
