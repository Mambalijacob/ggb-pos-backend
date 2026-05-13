import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  final String token;
  const AnalyticsScreen({super.key, required this.token});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<AnalyticsScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = await ApiService.getSummary(widget.token);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text("Sales: ${data!["total_sales"]}"),
                Text("Profit: ${data!["total_profit"]}"),
              ],
            ),
    );
  }
}
