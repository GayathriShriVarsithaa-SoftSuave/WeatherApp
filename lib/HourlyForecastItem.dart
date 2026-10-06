import 'package:flutter/material.dart';

class HourlyForecast extends StatefulWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });
  @override
  State<StatefulWidget> createState() {
    return _HourlyForecast();
  }
}

class _HourlyForecast extends State<HourlyForecast> {
  @override
  Widget build(BuildContext context) {
    return (Card(
      elevation: 10,
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsetsGeometry.all(6),
        child: Column(
          children: [
            Text(
              widget.time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Icon(widget.icon),
            const SizedBox(height: 8),
            Text(widget.temp),
          ],
        ),
      ),
    ));
  }
}
