import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  final String token;
  const InventoryScreen({super.key, required this.token});

  @override
  State<InventoryScreen> createState() => _InventoryState();
}

class _InventoryState extends State<InventoryScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    products = await ApiService.getInventory(widget.token);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          final quantity = p["quantity"] ?? p["stock"] ?? 0;
          final low = p["low_stock"] ?? quantity < 5;

          return ListTile(
            title: Text(p["name"]),
            subtitle: Text("Stock: $quantity"),
            trailing: Text("TZS ${p["price"]}"),
            tileColor: low ? Colors.red[100] : null,
          );
        },
      ),
    );
  }
}
