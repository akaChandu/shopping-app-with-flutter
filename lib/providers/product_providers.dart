import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_execption.dart';

class ProductProviders with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoriteOnly = false;

  final String authToken;
  final String userId;

  ProductProviders(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly =false;
  //   notifyListeners();
  // }

  Future<void> fetchShopProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-list-pad-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://shop-list-pad-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title']!,
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData![prodId] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        ('https://shop-list-pad-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'userId': userId,
        }),
      );
      final newproduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      // for adding items next to the exixting item.
      _items.add(newproduct);

      // adding items to the starting of the listitems.
      // _items.insert(0, newproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-list-pad-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deletePrduct(String id) async {
    final url = Uri.parse(
        'https://shop-list-pad-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final inExistingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? inExistingProduct = _items[inExistingProductIndex];
    _items.removeAt(inExistingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(inExistingProductIndex, inExistingProduct);
      notifyListeners();
      throw HttpExecption('Could not delete product!');
    }
    inExistingProduct = null;
  }
}
