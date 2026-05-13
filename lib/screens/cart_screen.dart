import 'package:flutter/material.dart';
import '../services/offline_service.dart';

class CartScreen extends StatefulWidget {
  final String token;
  const CartScreen({super.key, required this.token});

  @override
  State<CartScreen> createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  List items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await OfflineService.getCart();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: ListView(
        children: items.map((e) {
          return ListTile(
            title: Text(e["name"]),
            subtitle: Text("Qty: ${e["quantity"]}"),
          );
        }).toList(),
      ),
    );
  }
}
