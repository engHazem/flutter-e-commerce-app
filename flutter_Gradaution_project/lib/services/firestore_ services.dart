// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_project/widgets/custom_productcard.dart';

class Firestore {
  String? name;
  User? user;
  Firestore({this.user, this.name});
  void saveUserDataToFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'username': name,
      'email': user!.email,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveProductDataToFirestore({
    required String name,
    required String price,
    required String description,
    required String category,
    required String imageUrl,
  }) async {
    final docRef = await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'created_at': FieldValue.serverTimestamp(),
    });
    await docRef.update({'productid': docRef.id});
  }

  Future<List<ProductCard>> fetchProductCardsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductCard(
        productName: data['name'] ?? '',
        productPrice: double.tryParse(data['price'].toString()) ?? 0,
        productImage: data['imageUrl'] ?? '',
        productDescription: data['description'] ?? '',
        category: data['category'] ?? 'Unknown',
        productId: data['productid'] ?? doc.id,
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> getUserDataFromFirestore() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
