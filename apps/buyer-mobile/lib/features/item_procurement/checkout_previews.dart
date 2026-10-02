import 'package:flutter/material.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';

/// Owner-approved design preview (2026-09-29) of the invoice request, which ships with Order Details'
/// invoice feature. It is labelled as a preview, never sends or stores anything, and shows no invented IDs.
PreferredSizeWidget _bar(BuildContext context, String title) =>
    buyerAppBar(context, title);

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
