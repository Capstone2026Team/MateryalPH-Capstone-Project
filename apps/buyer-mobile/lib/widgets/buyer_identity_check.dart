import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import '../auth/auth_repository.dart';
import '../design_system/components/buyer_overlays.dart';
import '../design_system/theme.dart';
import 'auth_content.dart';

enum _IdentityResult { verified, expired }

/// Asks the Buyer to prove it is them (password, or a code sent to the current email) before a
/// security change. The server keeps the proof on this session for 15 minutes. Returns false when
/// the Buyer cancels and throws [BuyerSessionExpired] when the session ended meanwhile.
Future<bool> confirmBuyerIdentity(
  BuildContext context,
  AuthRepository repository, {
  required String reason,
}) async {
  final result = await showBuyerBottomSheet<_IdentityResult>(
    context: context,
    builder: (_) => _IdentityCheckSheet(repository: repository, reason: reason),
  );
  if (result == _IdentityResult.expired) throw const BuyerSessionExpired();
  return result == _IdentityResult.verified;
}

class _IdentityCheckSheet extends StatefulWidget {
  const _IdentityCheckSheet({required this.repository, required this.reason});
  final AuthRepository repository;
  final String reason;

  @override
  State<_IdentityCheckSheet> createState() => _IdentityCheckSheetState();
}

class _IdentityCheckSheetState extends State<_IdentityCheckSheet> {
  final _password = TextEditingController();
  final _emailCode = TextEditingController();
  bool _useEmail = false;
  bool _emailSent = false;
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _emailCode.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on BuyerSessionExpired {
      if (mounted) Navigator.of(context).pop(_IdentityResult.expired);
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() => _run(() async {
    final password = _password.text;
    final code = _emailCode.text.trim();
    if (_useEmail ? !RegExp(r'^\d{6}$').hasMatch(code) : password.isEmpty) {
      throw BuyerAuthException(
        _useEmail
            ? 'Enter the 6-digit code from your email.'
            : 'Enter your current password.',
      );
    }
    _password.clear();
    _emailCode.clear();
    await widget.repository.accountOperation(
      (api) => api.reauthenticateAccount(
        accountPortal: 'buyers',
        accountReauthentication: AccountReauthentication(
          (b) => _useEmail ? b.emailCode = code : b.password = password,
        ),
      ),
    );
    if (mounted) Navigator.of(context).pop(_IdentityResult.verified);
  });

  Future<void> _sendEmail() => _run(() async {
    await widget.repository.accountOperation(
      (api) => api.sendAccountReauthenticationEmail(accountPortal: 'buyers'),
    );
    if (mounted) setState(() => _emailSent = true);
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        4,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Confirm it’s you',
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.reason,
              style: const TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 20),
            if (!_useEmail)
              TextField(
                controller: _password,
                enabled: !_busy,
                autofocus: true,
                obscureText: _obscure,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => _busy ? null : _verify(),
                decoration: InputDecoration(
                  labelText: 'Current password',
                  prefixIcon: const Icon(LucideIcons.lock),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure ? LucideIcons.eye : LucideIcons.eyeOff),
                  ),
                ),
              )
            else if (!_emailSent)
              const Text(
                'We’ll send a 6-digit code to the email on your account.',
              )
            else
              TextField(
                controller: _emailCode,
                enabled: !_busy,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                onSubmitted: (_) => _busy ? null : _verify(),
                decoration: const InputDecoration(
                  labelText: 'Email code',
                  prefixIcon: Icon(LucideIcons.mail),
                  counterText: '',
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              AuthNotice(message: _error!, isError: true),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy
                  ? null
                  : _useEmail && !_emailSent
                  ? _sendEmail
                  : _verify,
              child: Text(
                _busy
                    ? 'Please wait…'
                    : _useEmail && !_emailSent
                    ? 'Send code'
                    : 'Verify',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _useEmail = !_useEmail;
                      _error = null;
                    }),
              child: Text(
                _useEmail
                    ? 'Use my password instead'
                    : 'Forgot password? Email me a code',
              ),
            ),
            if (_useEmail && _emailSent)
              TextButton(
                onPressed: _busy ? null : _sendEmail,
                child: const Text('Send a new code'),
              ),
          ],
        ),
      ),
    );
  }
}
