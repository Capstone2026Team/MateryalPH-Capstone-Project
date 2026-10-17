import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/auth_repository.dart';
import '../design_system/components/buyer_overlays.dart';
import '../design_system/theme.dart';
import '../widgets/auth_content.dart';
import '../widgets/buyer_account_widgets.dart';
import '../widgets/buyer_identity_check.dart';
import '../widgets/two_factor_widgets.dart';

/// Opens an otpauth:// link in an installed authenticator app. Replaceable in tests.
typedef AuthenticatorLauncher = Future<bool> Function(Uri uri);

Future<bool> _launchAuthenticator(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException {
    return false;
  }
}

/// Optional authenticator-app two-factor authentication for the Buyer: set up with one tap, a QR
/// code or a copyable key; save recovery codes; regenerate them; or turn 2FA off.
class BuyerTwoFactorScreen extends StatefulWidget {
  const BuyerTwoFactorScreen({
    super.key,
    required this.repository,
    required this.onSignedOut,
    this.launchAuthenticator = _launchAuthenticator,
  });
  final AuthRepository repository;
  final VoidCallback onSignedOut;
  final AuthenticatorLauncher launchAuthenticator;

  @override
  State<BuyerTwoFactorScreen> createState() => _BuyerTwoFactorScreenState();
}

class _BuyerTwoFactorScreenState extends State<BuyerTwoFactorScreen> {
  final _code = TextEditingController();
  bool? _enrolled;
  BuyerTwoFactorEnrollment? _setup;
  List<String>? _codes;
  bool _codesSaved = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() => _run(() async {
    final response = await widget.repository.accountOperation(
      (api) => api.getAccountSecurity(accountPortal: 'buyers'),
    );
    if (mounted) setState(() => _enrolled = response.data?.data.totpEnrolled);
  });

  /// Runs an action; when the server asks for a fresh identity check, asks once and retries.
  Future<void> _run(
    Future<void> Function() action, {
    String? identityReason,
  }) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      try {
        await action();
      } on BuyerAuthException catch (error) {
        final reason = identityReason;
        if (!error.needsRecentAuthentication || reason == null || !mounted) {
          rethrow;
        }
        final verified = await confirmBuyerIdentity(
          context,
          widget.repository,
          reason: reason,
        );
        if (!verified) return;
        await action();
      }
    } on BuyerSessionExpired {
      if (mounted) widget.onSignedOut();
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Something went wrong. Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _start() => _run(
    () async {
      final response = await widget.repository.accountOperation(
        (api) => api.startBuyerTwoFactor(),
      );
      if (mounted) setState(() => _setup = response.data?.data);
    },
    identityReason: 'Enter your password to set up two-factor authentication.',
  );

  Future<void> _confirm() async {
    final code = _code.text;
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(
        () =>
            _error = 'Enter the 6-digit code shown in your authenticator app.',
      );
      return;
    }
    await _run(
      () async {
        final response = await widget.repository.accountOperation(
          (api) => api.confirmBuyerTwoFactor(
            buyerTwoFactorConfirmation: BuyerTwoFactorConfirmation(
              (b) => b.code = code,
            ),
          ),
        );
        if (!mounted) return;
        setState(() {
          _codes = response.data?.data.recoveryCodes.toList() ?? const [];
          _codesSaved = false;
          _setup = null;
          _enrolled = true;
        });
      },
      identityReason:
          'Your identity check expired. Enter your password to finish turning on 2FA.',
    );
    if (_error != null) _code.clear();
  }

  Future<void> _regenerate() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: const Text('Get new recovery codes?'),
        content: const Text(
          'Your current recovery codes will stop working right away.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Get new codes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (proceed == true) await _replaceCodes();
  }

  Future<void> _replaceCodes() => _run(
    () async {
      final response = await widget.repository.accountOperation(
        (api) => api.replaceAccountRecoveryCodes(accountPortal: 'buyers'),
      );
      if (!mounted) return;
      setState(() {
        _codes = response.data?.data.recoveryCodes.toList() ?? const [];
        _codesSaved = false;
      });
    },
    identityReason:
        'Enter your password to get new recovery codes. Your current codes will stop working.',
  );

  Future<void> _turnOff() async {
    final turnedOff = await showBuyerBottomSheet<bool>(
      context: context,
      builder: (_) => _TurnOffSheet(repository: widget.repository),
    );
    if (turnedOff == null) return;
    if (!turnedOff) {
      widget.onSignedOut();
      return;
    }
    if (!mounted) return;
    setState(() => _enrolled = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-factor authentication is off.')),
    );
  }

  Future<void> _openApp() async {
    final setup = _setup;
    final uri = setup == null ? null : Uri.tryParse(setup.provisioningUri);
    if (uri == null) return;
    final opened = await widget.launchAuthenticator(uri);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No authenticator app opened. Install one, or copy the setup key below.',
          ),
        ),
      );
    }
  }

  Future<void> _copyKey() async {
    final setup = _setup;
    if (setup == null) return;
    await Clipboard.setData(ClipboardData(text: setup.secret));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Setup key copied. Paste it in your authenticator app.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, 'Two-Factor Authentication'),
    body: SafeArea(
      child: AuthContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_busy) const LinearProgressIndicator(semanticsLabel: 'Loading'),
            if (_error != null) ...[
              const SizedBox(height: 12),
              AuthNotice(message: _error!, isError: true),
              const SizedBox(height: 4),
            ],
            if (_codes != null)
              _codesView(context)
            else if (_setup != null)
              _setupView(context)
            else if (_enrolled == true)
              _enabledView(context)
            else if (_enrolled == false)
              _introView(context)
            else if (!_busy)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: OutlinedButton(
                  onPressed: _load,
                  child: const Text('Retry'),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _hero(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: BuyerTheme.brandSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 38, color: BuyerTheme.action),
        ),
      ),
      const SizedBox(height: 20),
      Semantics(
        header: true,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        body,
        textAlign: TextAlign.center,
        style: const TextStyle(color: BuyerTheme.muted, height: 1.5),
      ),
      const SizedBox(height: 24),
    ],
  );

  Widget _introView(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _hero(
        context,
        icon: LucideIcons.shieldCheck,
        title: 'Add a second step to sign in',
        body:
            'After your password, you’ll enter a 6-digit code from an authenticator app on your phone. Someone with only your password can’t get in.',
      ),
      const _Benefit(
        icon: LucideIcons.lockKeyhole,
        text:
            'Blocks sign-ins that use a stolen password, including Google sign-in.',
      ),
      const _Benefit(
        icon: LucideIcons.wifiOff,
        text:
            'Codes come from the app, so they work even without signal or SMS.',
      ),
      const _Benefit(
        icon: LucideIcons.keyRound,
        text: 'Recovery codes get you back in if you lose your phone.',
      ),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: _busy ? null : _start,
        icon: const Icon(LucideIcons.shieldPlus, size: 20),
        label: const Text('Set up authenticator'),
      ),
    ],
  );

  Widget _setupView(BuildContext context) {
    final setup = _setup!;
    final groupedKey = RegExp(
      '.{1,4}',
    ).allMatches(setup.secret).map((match) => match.group(0)).join(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        TwoFactorStep(
          number: 1,
          title: 'Get an authenticator app',
          child: const Text(
            'Use Google Authenticator, Microsoft Authenticator or any app that shows 6-digit codes.',
            style: TextStyle(color: BuyerTheme.muted, height: 1.5),
          ),
        ),
        TwoFactorStep(
          number: 2,
          title: 'Add MateryalPH to the app',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : _openApp,
                icon: const Icon(LucideIcons.externalLink, size: 20),
                label: const Text('Open authenticator app'),
              ),
              const SizedBox(height: 6),
              const Text(
                'On this phone, this adds MateryalPH in one tap.',
                style: TextStyle(color: BuyerTheme.muted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BuyerTheme.canvas,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BuyerTheme.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: setup.provisioningUri,
                        size: 176,
                        backgroundColor: Colors.white,
                        semanticsLabel:
                            'QR code to add MateryalPH to an authenticator app',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Using another device? Scan this QR code with its authenticator app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: BuyerTheme.muted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Or enter this setup key',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 6, 4, 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BuyerTheme.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        groupedKey,
                        semanticsLabel:
                            'Setup key ${setup.secret.split('').join(' ')}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          height: 1.5,
                          color: BuyerTheme.ink,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _copyKey,
                      icon: const Icon(LucideIcons.copy, size: 18),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Account: ${setup.issuer} (${setup.accountName}) · Time-based',
                style: const TextStyle(color: BuyerTheme.muted, fontSize: 13),
              ),
            ],
          ),
        ),
        TwoFactorStep(
          number: 3,
          title: 'Enter the 6-digit code',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Type the code the app shows for MateryalPH to confirm it’s set up.',
                style: TextStyle(color: BuyerTheme.muted, height: 1.5),
              ),
              const SizedBox(height: 12),
              AuthenticatorCodeField(
                controller: _code,
                enabled: !_busy,
                autofocus: false,
                onCompleted: _confirm,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _confirm,
                child: Text(_busy ? 'Turning on…' : 'Turn on 2FA'),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _busy
              ? null
              : () => setState(() {
                  _setup = null;
                  _code.clear();
                  _error = null;
                }),
          child: const Text('Cancel setup'),
        ),
      ],
    );
  }

  Widget _codesView(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _hero(
        context,
        icon: LucideIcons.keyRound,
        title: 'Save your recovery codes',
        body:
            'If you lose your phone, sign in with one of these codes. Each works once. They are shown only now — copy them to a password manager or write them down.',
      ),
      RecoveryCodesPanel(codes: _codes!),
      const SizedBox(height: 12),
      CheckboxListTile(
        value: _codesSaved,
        onChanged: (value) => setState(() => _codesSaved = value ?? false),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('I saved my recovery codes'),
      ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: _codesSaved ? () => setState(() => _codes = null) : null,
        child: const Text('Done'),
      ),
    ],
  );

  Widget _enabledView(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _hero(
        context,
        icon: LucideIcons.shieldCheck,
        title: 'Two-factor authentication is on',
        body:
            'Every time you sign in — with your password or Google — you’ll also enter a code from your authenticator app.',
      ),
      const BuyerSectionLabel('Recovery'),
      BuyerMenuRow(
        label: 'Get new recovery codes',
        icon: LucideIcons.keyRound,
        onTap: _busy ? () {} : _regenerate,
      ),
      const BuyerSectionLabel('Turn off'),
      BuyerMenuRow(
        label: 'Turn off two-factor authentication',
        icon: LucideIcons.shieldOff,
        destructive: true,
        onTap: _busy ? () {} : _turnOff,
      ),
    ],
  );
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: BuyerTheme.action),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.5, color: BuyerTheme.ink),
          ),
        ),
      ],
    ),
  );
}

/// Turning 2FA off needs a fresh identity check plus a current authenticator or recovery code.
/// Pops true when turned off, false when the session ended.
class _TurnOffSheet extends StatefulWidget {
  const _TurnOffSheet({required this.repository});
  final AuthRepository repository;

  @override
  State<_TurnOffSheet> createState() => _TurnOffSheetState();
}

class _TurnOffSheetState extends State<_TurnOffSheet> {
  final _code = TextEditingController();
  final _recovery = TextEditingController();
  bool _useRecovery = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    _recovery.dispose();
    super.dispose();
  }

  Future<void> _disable() async {
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
    Future<void> request() => widget.repository.accountOperation(
      (api) => api.disableBuyerTwoFactor(
        buyerTwoFactorDisable: BuyerTwoFactorDisable(
          (b) => _useRecovery ? b.recoveryCode = recovery : b.code = code,
        ),
      ),
    );
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      try {
        await request();
      } on BuyerAuthException catch (error) {
        if (!error.needsRecentAuthentication || !mounted) rethrow;
        final verified = await confirmBuyerIdentity(
          context,
          widget.repository,
          reason: 'Enter your password to turn off two-factor authentication.',
        );
        if (!verified) return;
        await request();
      }
      if (mounted) Navigator.of(context).pop(true);
    } on BuyerSessionExpired {
      if (mounted) Navigator.of(context).pop(false);
    } on BuyerAuthException catch (error) {
      if (!mounted) return;
      _code.clear();
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
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
              'Turn off two-factor authentication?',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your account will be protected by your password only. Your recovery codes will stop working.',
            style: TextStyle(color: BuyerTheme.muted, height: 1.5),
          ),
          const SizedBox(height: 20),
          if (_useRecovery)
            TextField(
              controller: _recovery,
              enabled: !_busy,
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Recovery code',
                prefixIcon: Icon(LucideIcons.keyRound),
              ),
            )
          else
            AuthenticatorCodeField(
              controller: _code,
              enabled: !_busy,
              onCompleted: _disable,
            ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            AuthNotice(message: _error!, isError: true),
          ],
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: _busy ? null : _disable,
            child: Text(_busy ? 'Turning off…' : 'Turn off 2FA'),
          ),
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
                  : 'Can’t use the app? Use a recovery code',
            ),
          ),
        ],
      ),
    ),
  );
}
