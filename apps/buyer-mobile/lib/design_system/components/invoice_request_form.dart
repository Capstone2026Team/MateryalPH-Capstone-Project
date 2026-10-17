import 'package:flutter/material.dart';

import '../../core/invoice_billing_input.dart';
import '../../features/map_discovery/discovery_models.dart';
import '../theme.dart';
import 'buyer_app_bar.dart';
import 'procurement_components.dart';

export '../../core/invoice_billing_input.dart';

/// Shared billing and request form for Checkout and Order Details.
class InvoiceRequestFormScreen extends StatefulWidget {
  const InvoiceRequestFormScreen({
    super.key,
    required this.onSubmit,
    required this.notice,
    this.initial,
    this.tinMasked,
    this.requestKind,
    this.submitLabel = 'Save invoice details',
  });

  final Future<void> Function(InvoiceBillingInput input) onSubmit;
  final String notice;
  final InvoiceBillingInput? initial;
  final String? tinMasked;
  final String? requestKind;
  final String submitLabel;

  @override
  State<InvoiceRequestFormScreen> createState() =>
      _InvoiceRequestFormScreenState();
}

class _InvoiceRequestFormScreenState extends State<InvoiceRequestFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _street = TextEditingController(text: widget.initial?.address);
  late final _tin = TextEditingController(text: widget.initial?.tin);
  final _region = TextEditingController();
  final _postal = TextEditingController();
  final _details = TextEditingController();
  late String _type = widget.initial?.tin != null || widget.tinMasked != null
      ? 'BUSINESS'
      : 'PERSONAL';
  bool _consent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _street,
      _tin,
      _region,
      _postal,
      _details,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _address => [
    _street.text,
    _region.text,
    _postal.text,
  ].map((part) => part.trim()).where((part) => part.isNotEmpty).join(', ');

  Future<void> _submit() async {
    if (_busy || !_consent || !_form.currentState!.validate()) return;
    final tin = _type == 'BUSINESS' ? _tin.text.trim() : '';
    final input = InvoiceBillingInput(
      name: _name.text.trim(),
      address: _address,
      tin: tin.isEmpty ? null : tin,
      details: widget.requestKind == null ? null : _details.text.trim(),
    );
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSubmit(input);
      if (mounted) {
        setState(() => _busy = false);
        Navigator.of(context).pop(input);
      }
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Unable to save. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _section(String title, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      border: Border.all(color: BuyerTheme.border),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    ),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLength = 180,
    TextInputType? keyboard,
    String? helper,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      controller: controller,
      enabled: !_busy,
      maxLength: maxLength,
      keyboardType: keyboard,
      minLines: keyboard == TextInputType.multiline ? 3 : 1,
      maxLines: keyboard == TextInputType.multiline ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        helperMaxLines: 3,
        counterText: '',
      ),
      validator: validator,
    ),
  );

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Request E-Invoice'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton(
            onPressed: _busy || !_consent ? null : _submit,
            child: Text(_busy ? 'Saving…' : widget.submitLabel),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              StatusBand(
                tone: BandTone.info,
                title: 'Vendor-issued invoice',
                message: widget.notice,
              ),
              const SizedBox(height: 12),
              if (_error != null) ...[
                StatusBand(tone: BandTone.danger, title: _error!),
                const SizedBox(height: 12),
              ],
              _section('Type', [
                RadioGroup<String>(
                  groupValue: _type,
                  onChanged: (value) {
                    if (!_busy && value != null) setState(() => _type = value);
                  },
                  child: Wrap(
                    children: [
                      for (final option in const {
                        'PERSONAL': 'Personal',
                        'BUSINESS': 'Business',
                      }.entries)
                        InkWell(
                          onTap: _busy
                              ? null
                              : () => setState(() => _type = option.key),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(value: option.key, enabled: !_busy),
                              Text(option.value),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ]),
              _section('Basic information', [
                _field(
                  _name,
                  _type == 'BUSINESS'
                      ? 'Registered business name'
                      : 'Full name',
                  validator: (value) => (value?.trim().length ?? 0) < 2
                      ? 'Enter at least 2 characters.'
                      : null,
                ),
                if (_type == 'BUSINESS')
                  _field(
                    _tin,
                    'TIN (optional)',
                    keyboard: TextInputType.number,
                    maxLength: 20,
                    helper: widget.tinMasked == null
                        ? '9- to 14-digit TIN, including branch code if any.'
                        : 'Saved: ${widget.tinMasked}. Enter the TIN again to retain it, or leave blank to remove it.',
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(
                        RegExp(r'\D'),
                        '',
                      );
                      return (value ?? '').trim().isNotEmpty &&
                              (digits.length < 9 || digits.length > 14)
                          ? 'Enter a 9- to 14-digit TIN or leave blank.'
                          : null;
                    },
                  ),
              ]),
              _section('Address', [
                _field(
                  _region,
                  'Region, province, city/municipality, barangay',
                  maxLength: 250,
                ),
                _field(
                  _postal,
                  'Postal code (optional)',
                  keyboard: TextInputType.number,
                  maxLength: 12,
                ),
                _field(
                  _street,
                  'Street name, building, house no. / billing address',
                  maxLength: 500,
                  validator: (_) =>
                      _address.length < 10 || _address.length > 500
                      ? 'Enter a complete billing address (10–500 characters).'
                      : null,
                ),
              ]),
              if (widget.requestKind != null)
                _section('Request details', [
                  _field(
                    _details,
                    widget.requestKind == 'CORRECTION'
                        ? 'What needs correcting'
                        : 'Details for the Vendor',
                    maxLength: 2000,
                    keyboard: TextInputType.multiline,
                    validator: (value) => (value?.trim().length ?? 0) < 10
                        ? 'Describe your request in at least 10 characters.'
                        : null,
                  ),
                ]),
              const Text(
                'The Vendor issues the official invoice through its registered process. MateryalPH records your details and requests. Purchase Orders and payment confirmations are not tax invoices.',
                style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _consent,
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _consent = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I consent to MateryalPH and the Vendor processing these details for my invoice under the MateryalPH Privacy Policy.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
