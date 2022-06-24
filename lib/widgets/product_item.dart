import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/product_details_page.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(/*this.id, this.title, this.imageUrl,*/ {Key? key})
      : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsPage.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token!,
                  authData.userId!,
                );
              },
              color: Colors.deepOrange,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('added!!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
