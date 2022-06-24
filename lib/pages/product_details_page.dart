import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_providers.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/product-details';

  // final String title;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductProviders>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                // SizedBox(height: 800.0,)
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 300.0,
        //       width: double.infinity,
        //       child: Hero(
        //         tag: loadedProduct.id,
        //         child: Image.network(
        //           loadedProduct.imageUrl,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
