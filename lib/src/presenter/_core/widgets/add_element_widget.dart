
import 'package:flutter/material.dart';

class AddElementWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AddElementWidget({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  size: 42,
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
