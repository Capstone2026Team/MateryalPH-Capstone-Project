import 'package:flutter/material.dart';

class BrandWithoutNameLockup extends StatelessWidget {
  const BrandWithoutNameLockup({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'MateryalPH',
      image: true,
      child: Image.asset(
        'assets/branding/materyalph-mark.png',
        height: compact ? 48 : 96,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
