import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_providers.dart';
import '../widgets/user_product_item.dart';
import '../widgets/main_drawer.dart';
import './edit_product_page.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  Future<void> _onRefreshProducts(BuildContext context) async {
    await Provider.of<ProductProviders>(context, listen: false)
        .fetchShopProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductProviders>(context);
    // print('rebuilding..');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: _onRefreshProducts(context),
        builder: (ctx, snapshot) =>
            (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _onRefreshProducts(context),
                    child: Consumer<ProductProviders>(
                      builder: (context, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              const Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
