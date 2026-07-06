// lib/shared/widgets/orynta_logo.dart
//
// Orynta 2.0 — Reusable Official Branding Logo Widget

import 'package:flutter/material.dart';

class OryntaLogo extends StatelessWidget {
  const OryntaLogo({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  });

  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/orynta_logo.png',
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      semanticLabel: semanticLabel ?? 'Orynta Logo',
    );
  }
}
