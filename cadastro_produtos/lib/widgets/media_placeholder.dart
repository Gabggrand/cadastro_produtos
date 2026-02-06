import 'package:flutter/material.dart';

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt),
              SizedBox(height: 4),
              Text("Adicionar\nFotos", textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )),
      ],
    );
  }
}
