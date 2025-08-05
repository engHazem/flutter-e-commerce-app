import 'package:hive/hive.dart';

final _cartbox = Hive.box('cartBox');
final _favbox = Hive.box('favoriteBox');

void writeDataToCartbox({
  required String productId,
  required String productName,
  required String productImage,
  required double productPrice,
}) {
  if (_cartbox.containsKey(productId)) {
    final existing = Map<String, dynamic>.from(_cartbox.get(productId));
    existing['quantity'] = (existing['quantity'] ?? 1) + 1;
    _cartbox.put(productId, existing);
  } else {
    _cartbox.put(productId, {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': 1,
    });
  }
}

void writeDataToFavoritebox({
  required String productId,
  required String productName,
  required String productImage,
  required double productPrice,
  required String productDescription,
  required String category,
}) {
  if (_favbox.containsKey(productId)) {
    _favbox.delete(productId);
    return;
  }
  _favbox.put(productId, {
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'productPrice': productPrice,
    'productDescription': productDescription,
    'category': category,
  });
}

List<Map<String, dynamic>> readDataFromFavoritebox() {
  final favoriteItems = _favbox.values.toList();
  return favoriteItems.map((item) {
    return {
      'productName': item['productName'],
      'productImage': item['productImage'],
      'productPrice': item['productPrice'],
      'productDescription': item['productDescription'],
      'category': item['category'],
    };
  }).toList();
}

void removeDataFromCartbox({required String productId}) {
  final cartItems = _cartbox.values.toList();
  final index = cartItems.indexWhere((item) => item['productId'] == productId);
  _cartbox.deleteAt(index);
}

Future<void> clearCartBox() async {
  await _cartbox.clear();
}

Future<void> clearfavoritebox() async {
  await _favbox.clear();
}

List<Map<String, dynamic>> readDataFromCartbox() {
  final cartItems = _cartbox.values.toList();
  return cartItems.map((item) {
    return {'productId': item['productId'], 'quantity': item['quantity']};
  }).toList();
}

void addToFavoriteBox({
  required String productId,
  required String productName,
  required double productPrice,
  required String productImage,
  required String productDescription,
  required String category,
}) {
  _favbox.put(productId, {
    'productId': productId,
    'productName': productName,
    'productPrice': productPrice,
    'productImage': productImage,
    'productDescription': productDescription,
    'category': category,
  });
}

void removeFromFavoriteBox(String productId) {
  _favbox.delete(productId);
}

bool isProductInCart(String productId) {
  return _cartbox.containsKey(productId);
}

bool isProductInFavoriteBox(String productId) {
  return _favbox.containsKey(productId);
}
