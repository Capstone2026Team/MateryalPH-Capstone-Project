import 'package:flutter/foundation.dart';

@immutable
class InvoiceBillingInput {
  const InvoiceBillingInput({
    required this.name,
    required this.address,
    this.tin,
    this.details,
  });

  final String name;
  final String address;
  final String? tin;
  final String? details;
}
