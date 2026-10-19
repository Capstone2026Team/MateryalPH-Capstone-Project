import 'package:flutter/material.dart';

/// The Buyer explicitly chooses from the server's currently available methods.
class QuotationPaymentChoices extends StatelessWidget {
  const QuotationPaymentChoices({
    super.key,
    required this.fulfillmentMethod,
    required this.availableMethods,
    required this.value,
    required this.onChanged,
    this.nrpcRequired = false,
    this.availableOnly = false,
  });
  final String fulfillmentMethod;
  final Iterable<String> availableMethods;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool nrpcRequired;
  final bool availableOnly;

  @override
  Widget build(BuildContext context) {
    final physical = fulfillmentMethod == 'DELIVERY'
        ? 'CASH_ON_DELIVERY'
        : 'IN_STORE';
    final methods = [physical, 'ONLINE'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose payment method',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(fulfillmentMethod == 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'),
        const SizedBox(height: 8),
        RadioGroup<String>(
          groupValue: value,
          onChanged: onChanged,
          child: Column(
            children: [
              for (final method in methods)
                if (!availableOnly || availableMethods.contains(method))
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: method,
                    enabled: availableMethods.contains(method),
                    title: Text(
                      method == 'ONLINE'
                          ? 'Online payment'
                          : method == 'IN_STORE'
                          ? 'In-Store Payment'
                          : 'Cash on Delivery (COD)',
                    ),
                    subtitle: Text(
                      !availableMethods.contains(method)
                          ? 'Currently unavailable from this Vendor.'
                          : method == 'ONLINE'
                          ? 'Pay online after acceptance. The channel fee is shown before payment.'
                          : nrpcRequired
                          ? 'Pay the NRPC online first; pay the remaining balance ${method == 'IN_STORE' ? 'at pickup' : 'on delivery'}.'
                          : method == 'IN_STORE'
                          ? 'Pay the Vendor at the store on pickup.'
                          : 'Pay the Vendor in cash on delivery.',
                    ),
                  ),
            ],
          ),
        ),
        if (!methods.any(availableMethods.contains))
          const Text(
            'Payment options are unavailable. Close and reopen the quotation to refresh, or contact the Vendor.',
          ),
      ],
    );
  }
}
