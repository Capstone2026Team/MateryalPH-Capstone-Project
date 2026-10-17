import 'package:flutter/material.dart';

import '../../design_system/components/invoice_request_form.dart';

/// Legacy design-capture entry point. Checkout uses the same shared form with a retained draft.
class EInvoiceRequestPreviewScreen extends StatelessWidget {
  const EInvoiceRequestPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) => InvoiceRequestFormScreen(
    notice:
        'Preview only. Open Checkout to save billing details with your order, or Order Details to request a copy or correction.',
    onSubmit: (_) async {},
  );
}
