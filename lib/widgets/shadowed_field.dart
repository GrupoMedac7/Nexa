import 'package:flutter/material.dart';

class ShadowedField extends StatelessWidget {
  final Widget field;
  const ShadowedField({
    super.key,
    required this.field
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: field,
    );
  }
}