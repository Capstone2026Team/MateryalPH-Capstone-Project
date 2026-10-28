import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../theme.dart';
import 'peso_amount_field.dart';
import 'specification_chips.dart';

String _money(int centavos) => '₱${pesoFieldText(centavos)}';
String _quantity(String value) => value.contains('.')
    ? value.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
    : value;
String _specificationLabel(String code) => code
    .split(RegExp('[_-]+'))
    .map((word) {
      final unit = word.toLowerCase();
      if (const {'mm', 'cm', 'm', 'kg', 'psi', 'mpa'}.contains(unit)) {
        return '(${unit == 'mpa'
            ? 'MPa'
            : unit == 'psi'
            ? 'PSI'
            : word})';
      }
      return word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}';
    })
    .join(' ');

class QuotationMaterialLines extends StatelessWidget {
  const QuotationMaterialLines({super.key, required this.lines});
  final Iterable<api.ChatQuotationLine> lines;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Materials', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      for (final line in lines) _MaterialLine(line: line),
    ],
  );
}

class _MaterialLine extends StatelessWidget {
  const _MaterialLine({required this.line});
  final api.ChatQuotationLine line;

  @override
  Widget build(BuildContext context) {
    final details = <SpecificationDetail>[
      if (line.brand?.trim().isNotEmpty == true)
        (label: 'Brand', value: line.brand!, unit: null),
      if (line.variantLabel?.trim().isNotEmpty == true)
        (label: 'Variant', value: line.variantLabel!, unit: null),
      for (final entry
          in line.specifications?.entries ?? <MapEntry<String, String>>[])
        if (entry.value.trim().isNotEmpty)
          (
            label: _specificationLabel(entry.key),
            value: entry.value,
            unit: null,
          ),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.description,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '${_quantity(line.quantity)} ${line.unitCode} × ${_money(line.unitPriceCentavos)}',
            style: const TextStyle(color: BuyerTheme.muted),
          ),
          const SizedBox(height: 8),
          if (details.isNotEmpty)
            SpecificationChips(details: details)
          else
            const Text(
              'Technical details not recorded for this quotation.',
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
        ],
      ),
    );
  }
}

class QuotationPaymentBreakdown extends StatelessWidget {
  const QuotationPaymentBreakdown({
    super.key,
    required this.content,
    this.selectedPaymentMethod,
    this.accepted = false,
  });
  final api.ChatQuotationContent content;
  final String? selectedPaymentMethod;
  final bool accepted;

  @override
  Widget build(BuildContext context) {
    final money = content.commercial;
    final discount = content.discount;
    final materialDiscount = money.vendorDiscountCentavos;
    final directPhysical =
        selectedPaymentMethod != null &&
        selectedPaymentMethod != 'ONLINE' &&
        money.nrpcCentavos == 0;
    final deliveryDiscount =
        discount?.scope.name == 'DELIVERY' && discount!.deductionCentavos > 0
        ? discount
        : null;
    final materialDiscountLabel =
        'Vendor discount (materials${discount?.scope.name == 'MATERIALS' ? ' · ${discount!.percent}%' : ''})';
    final destination = content.destination;
    final restriction = destination?['heavy_vehicle_restriction']?.value;
    String address(String key) {
      final point = destination?[key]?.value;
      return point is Map && point['formatted_address'] is String
          ? point['formatted_address'] as String
          : 'Not recorded';
    }

    final instructions = destination?['access_instructions']?.value;
    final arrangement = content.delivery?['arrangement']?.value;
    final formulaFee = content.delivery?['formula_charge_centavos']?.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 28),
        const Text(
          'Payment breakdown',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (materialDiscount > 0 && money.materialsGrossCentavos != null)
          _QuotationRow(
            'Materials subtotal',
            _money(money.materialsGrossCentavos!),
          ),
        if (materialDiscount > 0)
          _QuotationRow(materialDiscountLabel, '− ${_money(materialDiscount)}'),
        _QuotationRow(
          materialDiscount > 0 ? 'Materials after discounts' : 'Materials',
          _money(money.materialsPayableCentavos),
        ),
        _QuotationRow(
          'Included VAT (in materials)',
          _money(money.materialsVatCentavos),
          muted: true,
        ),
        if (content.delivery?['fee_overridden']?.value == true &&
            formulaFee is int)
          _QuotationRow(
            'System-calculated delivery fee',
            _money(formulaFee),
            muted: true,
          ),
        if (deliveryDiscount != null) ...[
          _QuotationRow(
            'Delivery subtotal',
            _money(deliveryDiscount.basisCentavos),
          ),
          _QuotationRow(
            'Vendor discount (delivery · ${deliveryDiscount.percent}%)',
            '− ${_money(deliveryDiscount.deductionCentavos)}',
          ),
          _QuotationRow(
            'Delivery after discounts',
            _money(money.deliveryCentavos),
          ),
        ] else
          _QuotationRow(
            content.fulfillmentMethod == 'PICKUP'
                ? 'Delivery (Self-Pickup)'
                : 'Delivery',
            _money(money.deliveryCentavos),
          ),
        const Text(
          'VAT is already included in the materials amount.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        const Divider(height: 28),
        _QuotationRow(
          'Total before processing fee',
          _money(money.commercialTotalCentavos),
          strong: true,
        ),
        _QuotationRow(
          'Processing fee',
          directPhysical ? 'Not applicable' : 'Pending',
          muted: true,
        ),
        Text(
          directPhysical
              ? 'No online processing fee for this payment method.'
              : 'Calculated when a payment channel is selected.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        if (money.nrpcCentavos > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            decoration: BoxDecoration(
              color: BuyerTheme.canvas,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _QuotationRow(
              'NRPC included in total',
              _money(money.nrpcCentavos),
            ),
          ),
        ],
        const Divider(height: 28),
        const Text(
          'Fulfillment & payment',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _QuotationRow(
          'Fulfillment',
          content.fulfillmentMethod == 'PICKUP'
              ? 'Self-Pickup'
              : 'Site Delivery',
        ),
        _QuotationRow('Fulfillment date', content.fulfillmentDate),
        if (content.fulfillmentMethod == 'DELIVERY') ...[
          _QuotationRow('Delivery destination', address('intended')),
          _QuotationRow(
            'Heavy-vehicle restriction',
            restriction == 'YES'
                ? 'Yes — alternative drop-off'
                : restriction == 'NO'
                ? 'No known restriction'
                : 'Not recorded',
          ),
          if (restriction == 'YES')
            _QuotationRow(
              'Vehicle drop-off used for delivery fee',
              address('alternate_drop_off'),
            ),
          if (instructions is String && instructions.isNotEmpty)
            _QuotationRow('Access & unloading instructions', instructions),
          if (arrangement is String && arrangement.isNotEmpty)
            _QuotationRow('Delivery arrangement', arrangement),
        ],
        _QuotationRow(
          'Payment method',
          const {
                'ONLINE': 'Online payment',
                'CASH_ON_DELIVERY': 'Cash on Delivery',
                'IN_STORE': 'In-Store Payment',
              }[selectedPaymentMethod] ??
              selectedPaymentMethod ??
              (accepted
                  ? 'See Order Details'
                  : 'Buyer selects before accepting'),
        ),
      ],
    );
  }
}

/// Amounts stay aligned until text scaling or a long amount needs a full row.
class _QuotationRow extends StatelessWidget {
  const _QuotationRow(
    this.label,
    this.value, {
    this.strong = false,
    this.muted = false,
  });
  final String label;
  final String value;
  final bool strong;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: strong ? 17 : 14,
      fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
      color: muted ? BuyerTheme.muted : BuyerTheme.ink,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = TextPainter(
            text: TextSpan(text: value, style: style),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout();
          final stacked = constraints.maxWidth - painter.width - 12 < 120;
          painter.dispose();
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: style),
                const SizedBox(height: 4),
                Text(value, style: style),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: style)),
              const SizedBox(width: 12),
              Text(value, style: style, textAlign: TextAlign.right),
            ],
          );
        },
      ),
    );
  }
}
