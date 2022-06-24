import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/edit_product_page.dart';
import '../providers/product_providers.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffoldMsg = ScaffoldMessenger.of(context);
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: SizedBox(
          width: 100.0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductPage.routeName, arguments: id);
                },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<ProductProviders>(context, listen: false)
                        .deletePrduct(id);
                  } catch (error) {
                    scaffoldMsg.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ));
  }
}
