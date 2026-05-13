import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'inventory_screen.dart';
import 'cart_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;
  const DashboardScreen({super.key, required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  Map<String, dynamic>? summary;
  Map<String, dynamic>? prediction;

  num get sales => summary?["total_sales"] ?? summary?["sales"] ?? 0;
  num get profit => summary?["total_profit"] ?? summary?["profit"] ?? 0;
  num get orders => summary?["total_orders"] ?? summary?["orders"] ?? 0;
  num get predictedSales =>
      prediction?["next_month"] ?? prediction?["predicted_next_day"] ?? 0;

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
      appBar: AppBar(title: const Text("Dashboard")),
      body: summary == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text("Sales: $sales"),
                Text("Profit: $profit"),
                Text("Orders: $orders"),
                const SizedBox(height: 10),
                Text("AI Prediction: $predictedSales"),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InventoryScreen(token: widget.token),
                    ),
                  ),
                  child: const Text("Inventory"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(token: widget.token),
                    ),
                  ),
                  child: const Text("Cart"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnalyticsScreen(token: widget.token),
                    ),
                  ),
                  child: const Text("Analytics"),
                ),
              ],
            ),
    );
  }
}
