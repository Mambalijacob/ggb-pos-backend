import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'inventory_screen.dart';
import 'cart_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;
  const DashboardScreen({required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  Map<String, dynamic>? summary;
  Map<String, dynamic>? prediction;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    summary = await ApiService.getSummary(widget.token);
    prediction = await ApiService.getPrediction(widget.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: summary == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text("Sales: ${summary!["total_sales"]}"),
                Text("Profit: ${summary!["total_profit"]}"),
                Text("Orders: ${summary!["total_orders"]}"),
                const SizedBox(height: 10),
                Text("AI Prediction: ${prediction?["next_month"] ?? 0}"),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InventoryScreen(token: widget.token),
                    ),
                  ),
                  child: Text("Inventory"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(token: widget.token),
                    ),
                  ),
                  child: Text("Cart"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnalyticsScreen(token: widget.token),
                    ),
                  ),
                  child: Text("Analytics"),
                ),
              ],
            ),
    );
  }
}
