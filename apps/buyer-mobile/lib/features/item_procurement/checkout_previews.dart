import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import 'procurement_models.dart';

/// Owner-approved design previews (2026-09-29) of pages whose features ship later: the invoice
/// request (Order Details, once an order exists) and the order confirmation (order submission).
/// They are labelled as previews, never send or store anything, and show no invented IDs or fees.
PreferredSizeWidget _bar(BuildContext context, String title) => AppBar(
  automaticallyImplyLeading: false,
  leadingWidth: 60,
  leading: Center(
    child: RoundIconButton(
      icon: LucideIcons.arrowLeft,
      tooltip: 'Back',
      filled: true,
      onPressed: () => Navigator.of(context).maybePop(),
    ),
  ),
  centerTitle: true,
  title: Text(
    title,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
  ),
);

class _Section extends StatelessWidget {
  const _Section({required this.children, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Semantics(
            header: true,
            child: Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ...children,
      ],
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field(this.label, {this.keyboard, this.helper});

  final String label;
  final String? helper;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label, helperText: helper),
    ),
  );
}

/// Request E-Invoice, as it will appear on Order Details. Nothing entered here is kept.
class EInvoiceRequestPreviewScreen extends StatefulWidget {
  const EInvoiceRequestPreviewScreen({super.key});

  @override
  State<EInvoiceRequestPreviewScreen> createState() =>
      _EInvoiceRequestPreviewScreenState();
}

class _EInvoiceRequestPreviewScreenState
    extends State<EInvoiceRequestPreviewScreen> {
  String _type = 'PERSONAL';
  bool _consent = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: _bar(context, 'Request E-Invoice'),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              enabled: false,
              label: 'Submit Request, not available in this preview',
              excludeSemantics: true,
              child: const FilledButton(
                onPressed: null,
                child: Text('Submit Request'),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Preview only — invoice requests open from Order Details once an order exists.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ],
        ),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const StatusBand(
            tone: BandTone.info,
            title: 'Design preview — nothing is saved or sent',
            message:
                'After an order exists you can request the Vendor’s invoice or a copy/correction from Order Details. Business TIN details are optional and used only for the invoice.',
          ),
          const SizedBox(height: 12),
          _Section(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Type',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: RadioGroup<String>(
                      groupValue: _type,
                      onChanged: (value) =>
                          setState(() => _type = value ?? _type),
                      child: const Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          _TypeOption(value: 'PERSONAL', label: 'Personal'),
                          _TypeOption(value: 'BUSINESS', label: 'Business'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _Section(
            title: 'Basic information',
            children: [
              _Field(
                _type == 'BUSINESS' ? 'Registered business name' : 'Full name',
              ),
              if (_type == 'BUSINESS')
                const _Field(
                  'TIN',
                  keyboard: TextInputType.number,
                  helper: '9-digit TIN plus branch code, if any',
                ),
            ],
          ),
          const _Section(
            title: 'Address',
            children: [
              _Field('Region, province, city/municipality, barangay'),
              _Field('Postal code', keyboard: TextInputType.number),
              _Field('Street name, building, house no.'),
            ],
          ),
          const _Section(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Set as default business billing information'),
                  ),
                  Switch(value: false, onChanged: null),
                ],
              ),
            ],
          ),
          const Text(
            'Disclaimer',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          for (final line in const [
            'The Vendor issues the official invoice through its registered process. MateryalPH records only your request.',
            'MateryalPH’s Purchase Order and payment confirmation are not tax invoices.',
            'If the TIN is wrong or missing, the invoice may be issued without your business details.',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $line',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BuyerTheme.border),
            ),
            child: CheckboxListTile(
              value: _consent,
              activeColor: BuyerTheme.action,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) => setState(() => _consent = value ?? false),
              title: const Text(
                'I consent to MateryalPH and the Vendor processing these details to issue my invoice, under the MateryalPH Privacy Policy.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Radio<String>(value: value),
      Text(label),
      const SizedBox(width: 4),
    ],
  );
}

/// The confirmation page as it will look after order requests are submitted. Built from the
/// current checkout preview; the transaction ID, date and payment are not invented.
class OrderPlacedPreviewScreen extends StatelessWidget {
  const OrderPlacedPreviewScreen({super.key, required this.preview});

  final CheckoutPreviewView preview;

  @override
  Widget build(BuildContext context) {
    final subtotal = preview.groups.fold<int>(
      0,
      (sum, group) => sum + group.amounts.materialsSubtotalCentavos,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: BuyerTheme.brandSoft,
                    foregroundColor: BuyerTheme.actionPressed,
                  ),
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Semantics(
                  button: true,
                  enabled: false,
                  label: 'Track Order, not available in this preview',
                  excludeSemantics: true,
                  child: const FilledButton(
                    onPressed: null,
                    child: Text('Track Order'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  LucideIcons.arrowLeft,
                  color: BuyerTheme.action,
                ),
              ),
            ),
            const StatusBand(
              tone: BandTone.info,
              title: 'Design preview — no order was created',
              message:
                  'This is how the confirmation will look after you submit order requests. Nothing was sent, reserved or charged.',
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(MateryalColorTokens.brandOrange50),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BuyerTheme.brandSoft,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.shieldCheck,
                    size: 52,
                    color: BuyerTheme.action,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order request sent!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Each Vendor reviews its request. You are asked to pay only after the Vendor confirms the final amount.',
              textAlign: TextAlign.center,
              style: TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BuyerTheme.canvas,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BuyerTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SpecificationRow(
                    'Transaction ID',
                    'Assigned when submitted',
                  ),
                  const SpecificationRow('Date', 'Set when submitted'),
                  const SizedBox(height: 8),
                  for (final group in preview.groups)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BuyerTheme.action),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _Caption('Vendor'),
                          Text(group.vendorName),
                          const SizedBox(height: 6),
                          const _Caption('Items'),
                          for (final line in group.lines)
                            Row(
                              children: [
                                Expanded(child: Text(line.displayName)),
                                Text(
                                  '${formatQuantity(line.quantity)} ${line.unitName}',
                                ),
                              ],
                            ),
                          const SizedBox(height: 6),
                          const _Caption('Delivery method'),
                          Text(switch (group.fulfillmentMethod) {
                            'DELIVERY' => 'Site Delivery',
                            'PICKUP' => 'Self-Pickup',
                            _ => 'Not chosen',
                          }),
                          const SizedBox(height: 6),
                          const _Caption('Payment method'),
                          const Text('Chosen after the Vendor confirms'),
                        ],
                      ),
                    ),
                  SpecificationRow(
                    'Materials subtotal',
                    formatPeso(subtotal),
                    strong: true,
                  ),
                  const Text(
                    'Delivery and any payment processing fee are added when confirmed.',
                    style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: BuyerTheme.action,
    ),
  );
}
