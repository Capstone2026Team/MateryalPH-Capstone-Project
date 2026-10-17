import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../auth/auth_repository.dart';
import '../design_system/components/buyer_app_bar.dart';
import '../design_system/theme.dart';
import '../widgets/auth_content.dart';
import '../widgets/two_factor_widgets.dart';

/// Second sign-in step for a Buyer who turned on two-factor authentication. Resolves to true once
/// the session is saved.
Future<bool> completeTwoFactorSignIn(
  BuildContext context,
  AuthRepository repository,
  BuyerTwoFactorRequired challenge,
) async =>
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            TwoFactorSignInScreen(repository: repository, challenge: challenge),
      ),
    ) ??
    false;

class TwoFactorSignInScreen extends StatefulWidget {
  const TwoFactorSignInScreen({
    super.key,
    required this.repository,
    required this.challenge,
  });
  final AuthRepository repository;
  final BuyerTwoFactorRequired challenge;

  @override
  State<TwoFactorSignInScreen> createState() => _TwoFactorSignInScreenState();
}

class _TwoFactorSignInScreenState extends State<TwoFactorSignInScreen> {
  final _code = TextEditingController();
  final _recovery = TextEditingController();
  Timer? _timer;
  late int _remaining = widget.challenge.expiresInSeconds;
  bool _useRecovery = false;
  bool _busy = false;
  bool _ended = false;
  String? _error;
  List<String>? _replacementCodes;
  bool _savedCodes = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining--;
        if (_remaining <= 0) {
          _ended = true;
          _error = 'This sign-in expired. Go back and sign in again.';
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _recovery.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || _ended) return;
    final code = _code.text;
    final recovery = _recovery.text.trim();
    if (_useRecovery
        ? recovery.length < 8
        : !RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(
        () => _error = _useRecovery
            ? 'Enter one of your recovery codes.'
            : 'Enter the 6-digit code from your authenticator app.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_useRecovery) {
        final codes = await widget.repository.recoverTwoFactorSignIn(
          widget.challenge,
          recovery,
        );
        _timer?.cancel();
        if (!mounted) return;
        if (codes.isEmpty) {
          Navigator.of(context).pop(true);
        } else {
          setState(() => _replacementCodes = codes);
        }
      } else {
        await widget.repository.completeTwoFactorSignIn(widget.challenge, code);
        _timer?.cancel();
        if (mounted) Navigator.of(context).pop(true);
      }
    } on BuyerAuthException catch (error) {
      if (!mounted) return;
      _code.clear();
      setState(() {
        _error = error.message;
        _ended =
            error.code == 'MFA_CHALLENGE_INVALID' ||
            error.code == 'MFA_CHALLENGE_LOCKED';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    // Once a recovery code signed the Buyer in, leaving this page still finishes sign-in.
    canPop: _replacementCodes == null,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) Navigator.of(context).pop(true);
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Two-Factor Authentication'),
      body: SafeArea(
        child: AuthContent(
          child: _replacementCodes != null
              ? _newCodes(context)
              : _form(context),
        ),
      ),
    ),
  );

  Widget _form(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const _ShieldBadge(),
        const SizedBox(height: 24),
        Text(
          _useRecovery
              ? 'Use a recovery code'
              : 'Enter your authenticator code',
          textAlign: TextAlign.center,
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          _useRecovery
              ? 'Each recovery code works once. Signing in with one signs out your other devices and gives you a new set.'
              : 'Open your authenticator app and enter the 6-digit code shown for MateryalPH.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: BuyerTheme.muted, height: 1.5),
        ),
        const SizedBox(height: 28),
        if (_useRecovery)
          TextField(
            controller: _recovery,
            enabled: !_busy && !_ended,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Recovery code',
              hintText: 'XXXX-XXXX-XXXX',
              prefixIcon: Icon(LucideIcons.keyRound),
            ),
          )
        else
          AuthenticatorCodeField(
            controller: _code,
            enabled: !_busy && !_ended,
            onCompleted: _submit,
          ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          AuthNotice(message: _error!, isError: true),
        ],
        const SizedBox(height: 24),
        if (_ended)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Back to sign in'),
          )
        else
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_busy ? 'Verifying…' : 'Verify and sign in'),
          ),
        const SizedBox(height: 8),
        if (!_ended)
          TextButton(
            onPressed: _busy
                ? null
                : () => setState(() {
                    _useRecovery = !_useRecovery;
                    _error = null;
                  }),
            child: Text(
              _useRecovery
                  ? 'Use my authenticator app instead'
                  : 'Lost your phone? Use a recovery code',
            ),
          ),
      ],
    );
  }

  Widget _newCodes(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 12),
      const _ShieldBadge(),
      const SizedBox(height: 24),
      Text(
        'Save your new recovery codes',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      const Text(
        'You used a recovery code, so all your old codes stopped working. Keep these somewhere safe — they are shown only once.',
        textAlign: TextAlign.center,
        style: TextStyle(color: BuyerTheme.muted, height: 1.5),
      ),
      const SizedBox(height: 24),
      RecoveryCodesPanel(codes: _replacementCodes!),
      const SizedBox(height: 16),
      CheckboxListTile(
        value: _savedCodes,
        onChanged: (value) => setState(() => _savedCodes = value ?? false),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('I saved my new recovery codes'),
      ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: _savedCodes ? () => Navigator.of(context).pop(true) : null,
        child: const Text('Continue'),
      ),
    ],
  );
}

class _ShieldBadge extends StatelessWidget {
  const _ShieldBadge();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: BuyerTheme.brandSoft,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.shieldCheck,
        size: 36,
        color: BuyerTheme.action,
      ),
    ),
  );
}
