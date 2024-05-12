import "package:flutter/material.dart";

class AdditionalDataItem extends StatelessWidget {
  final IconData icon;
  final String type, value;

  const AdditionalDataItem(
      {super.key, required this.icon, required this.type, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(type),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
