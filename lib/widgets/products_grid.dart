import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/product_providers.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this.showFavs, {Key? key}) : super(key: key);

  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProviders>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (context) => products[i],
        value: products[i],
        child: const ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      itemCount: products.length,
    );
  }
}
