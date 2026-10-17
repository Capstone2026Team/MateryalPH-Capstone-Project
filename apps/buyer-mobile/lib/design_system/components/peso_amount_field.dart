import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

const _maxWholeDigits = 9;

/// Groups the whole part with commas while the Buyer types and keeps at most
/// two decimal places, so a long amount can be read at a glance.
class PesoAmountFormatter extends TextInputFormatter {
  const PesoAmountFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final dot = raw.indexOf('.');
    var whole = dot < 0 ? raw : raw.substring(0, dot);
    var cents = dot < 0 ? null : raw.substring(dot + 1).replaceAll('.', '');
    if (whole.length > _maxWholeDigits) {
      whole = whole.substring(0, _maxWholeDigits);
    }
    if (cents != null && cents.length > 2) cents = cents.substring(0, 2);
    final text = '${groupPesoDigits(whole)}${cents == null ? '' : '.$cents'}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

String groupPesoDigits(String digits) {
  final trimmed = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
  final out = StringBuffer();
  for (var i = 0; i < trimmed.length; i++) {
    if (i > 0 && (trimmed.length - i) % 3 == 0) out.write(',');
    out.write(trimmed[i]);
  }
  return out.toString();
}

/// Display text for an existing centavo amount, such as `1,234.50`.
String pesoFieldText(int centavos) =>
    '${groupPesoDigits('${centavos ~/ 100}')}.${(centavos % 100).toString().padLeft(2, '0')}';

/// "150 thousand", "12.35 million"; null below one thousand pesos.
String? pesoScaleLabel(int pesos) {
  const scales = [
    (1000000000, 'billion'),
    (1000000, 'million'),
    (1000, 'thousand'),
  ];
  for (final (size, name) in scales) {
    if (pesos >= size) {
      final value = (pesos / size)
          .toStringAsFixed(2)
          .replaceFirst(RegExp(r'\.?0+$'), '');
      return '$value $name';
    }
  }
  return null;
}

/// Money entry with a fixed ₱ prefix, live comma grouping and a readout that
/// shows the full amount and its scale beneath the field.
class PesoAmountField extends StatelessWidget {
  const PesoAmountField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
    this.enabled = true,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final String? helperText;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    validator: validator,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: const [PesoAmountFormatter()],
    style: Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
    decoration: InputDecoration(
      labelText: label,
      hintText: '0.00',
      prefixText: '₱ ',
      prefixStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w400,
        color: BuyerTheme.muted,
      ),
      helper: _Readout(controller: controller, helperText: helperText),
    ),
  );
}

class _Readout extends StatelessWidget {
  const _Readout({required this.controller, this.helperText});
  final TextEditingController controller;
  final String? helperText;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: controller,
    builder: (context, value, _) {
      final text = value.text;
      final whole = int.tryParse(text.split('.').first.replaceAll(',', ''));
      final scale = whole == null ? null : pesoScaleLabel(whole);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scale != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '≈ $scale pesos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BuyerTheme.action,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (helperText != null)
            Text(helperText!, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    },
  );
}
