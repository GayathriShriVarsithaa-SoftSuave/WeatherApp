import 'package:flutter/material.dart';

class AdditionalInformation extends StatefulWidget {
  final String title;
  final IconData icon;
  final String value;
  const AdditionalInformation({super.key, required this.icon, required this.title, required this.value});
  State<StatefulWidget> createState() {
    return _AdditionalInformation();
  }
}

class _AdditionalInformation extends State<AdditionalInformation> {
  @override
  Widget build(BuildContext context) {
    return (Card(
      elevation: 10,
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(widget.icon),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            Text(widget.value.toString()),
          ],
        ),
      ),
    ));
  }
}
