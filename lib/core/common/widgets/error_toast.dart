import 'package:flutter/material.dart';

class ErrorToast extends StatelessWidget {
  final String message;

  const ErrorToast({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
