import 'package:flutter/material.dart';

class StockIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const StockIndicator(
      {super.key,
      required this.color,
      required this.text,
      required this.isSquare,
      this.size = 16,
      this.textColor = const Color(0xff505050)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size,
          height: size * 2,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color
          ),
        ),
        const SizedBox(width: 10,),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
