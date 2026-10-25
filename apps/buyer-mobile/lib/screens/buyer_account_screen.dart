import '../widgets/legal_content.dart';
import '../widgets/buyer_account_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../auth/auth_repository.dart';
import '../widgets/auth_content.dart';
import '../design_system/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/components/buyer_overlays.dart';
import '../design_system/components/procurement_components.dart';
import '../features/orders/order_models.dart' show formatManilaDateTime;

class BuyerAccountScreen extends StatefulWidget {
  const BuyerAccountScreen({
    super.key,
    required this.repository,
    required this.onSignedOut,
    this.initialSection = 'Profile',
  });
  final AuthRepository repository;
  final VoidCallback onSignedOut;
  final String initialSection;

  @override
  State<BuyerAccountScreen> createState() => _BuyerAccountScreenState();
}

/// Where an action's result message appears, so it shows next to the control that caused it.
enum _Scope { page, profile, identity, password, email }

class _BuyerAccountScreenState extends State<BuyerAccountScreen> {
  /// The server keeps a fresh identity check on this session for 15 minutes.
  static const _identityWindow = Duration(minutes: 15);

  AccountProfile? _profile;
  List<AccountSession> _sessions = [];
  List<AccountAgreement> _agreements = [];
  String _section = 'Profile';
  bool _busy = false;
  bool _error = false;
  String? _message;
  _Scope _messageScope = _Scope.page;
  String? _emailChangeId;
  bool _reauthenticationEmailSent = false;
  DateTime? _verifiedUntil;
  final _name = TextEditingController();
  final _company = TextEditingController();
  final _password = TextEditingController();
  final _reauthenticationCode = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _email = TextEditingController();
  final _code = TextEditingController();
  String _buyerType = 'INDIVIDUAL';
  int _page = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _section = widget.initialSection;
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _company,
      _password,
      _reauthenticationCode,
      _newPassword,
      _confirmPassword,
      _email,
      _code,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _busy = true);
    try {
      final result = await widget.repository.accountOperation(
        (api) => api.getAccountProfile(accountPortal: 'buyers'),
      );
      final profile = result.data?.data;
      if (profile == null || profile.accountType != 'BUYER') {
        throw const BuyerAuthException('Buyer access is unavailable.');
      }
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _name.text = profile.fullName;
        _company.text = profile.companyName ?? '';
        _buyerType = profile.buyerType ?? 'INDIVIDUAL';
      });
      if (_section == 'Sessions') {
        final response = await widget.repository.accountOperation(
          (api) =>
              api.listAccountSessions(accountPortal: 'buyers', page: _page),
        );
        if (mounted) {
          setState(() {
            _sessions = response.data?.data.toList() ?? [];
            _lastPage = response.data?.meta['last_page']?.asNum.toInt() ?? 1;
          });
        }
      }
      if (_section == 'Agreements') {
        final response = await widget.repository.accountOperation(
          (api) => api.listAccountAgreements(accountPortal: 'buyers'),
        );
        if (mounted) {
          setState(() => _agreements = response.data?.data.toList() ?? []);
        }
      }
    } catch (error) {
      if (error is BuyerSessionExpired) {
        await _signedOut();
        return;
      }
      if (mounted) {
        setState(() {
          _message = error is BuyerAuthException
              ? error.message
              : 'Could not load your account. Retry when connected.';
          _messageScope = _Scope.page;
          _error = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Runs an account request. [message] is shown on success next to [scope]; null shows nothing.
  Future<void> _act(
    Future<void> Function() operation,
    String? message, {
    bool reload = true,
    _Scope scope = _Scope.page,
  }) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await operation();
      if (mounted) {
        setState(() {
          _message = message;
          _messageScope = scope;
          _error = false;
        });
      }
      if (reload && mounted) await _load();
    } catch (error) {
      if (error is BuyerSessionExpired) {
        await _signedOut();
        return;
      }
      if (mounted) {
        setState(() {
          _message = error is BuyerAuthException
              ? error.message
              : 'The request could not finish. Please retry.';
          _messageScope = scope;
          _error = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String message) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => BuyerDialog(
          title: const Text('Confirm account action'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(88, 48),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> _signedOut() async {
    await widget.repository.clearAccountSession();
    if (mounted) widget.onSignedOut();
  }

  String _time(String? value) {
    final parsed = value == null ? null : DateTime.tryParse(value);
    return parsed == null
        ? 'Not available'
        : '${parsed.toUtc().add(const Duration(hours: 8)).toString().substring(0, 16)} (Asia/Manila)';
  }

  bool get _identityVerified =>
      _verifiedUntil?.isAfter(DateTime.now()) ?? false;

  bool get _profileChanged {
    final profile = _profile;
    if (profile == null) return false;
    return _name.text.trim() != profile.fullName ||
        _buyerType != (profile.buyerType ?? 'INDIVIDUAL') ||
        (_buyerType == 'BUSINESS' &&
            _company.text.trim() != (profile.companyName ?? ''));
  }

  Future<void> _saveProfile() => _act(
    () async {
      await widget.repository.accountOperation(
        (api) => api.updateAccountProfile(
          accountPortal: 'buyers',
          accountProfileUpdate: AccountProfileUpdate(
            (b) => b
              ..fullName = _name.text.trim()
              ..lockVersion = _profile!.lockVersion
              ..buyerType = _buyerType == 'BUSINESS'
                  ? AccountProfileUpdateBuyerTypeEnum.BUSINESS
                  : AccountProfileUpdateBuyerTypeEnum.INDIVIDUAL
              ..companyName = _company.text.trim(),
          ),
        ),
      );
    },
    'Profile saved.',
    scope: _Scope.profile,
  );

  Future<void> _openSecurity() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BuyerAccountScreen(
          repository: widget.repository,
          onSignedOut: widget.onSignedOut,
          initialSection: 'Security',
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _reauthenticate(AccountReauthentication request) => _act(
    () async {
      await widget.repository.accountOperation(
        (api) => api.reauthenticateAccount(
          accountPortal: 'buyers',
          accountReauthentication: request,
        ),
      );
      if (mounted) {
        setState(() {
          _verifiedUntil = DateTime.now().add(_identityWindow);
          _reauthenticationEmailSent = false;
        });
      }
    },
    null,
    reload: false,
    scope: _Scope.identity,
  );

  Future<void> _verifyPassword() {
    final password = _password.text;
    _password.clear();
    return _reauthenticate(
      AccountReauthentication((b) => b.password = password),
    );
  }

  Future<void> _verifyEmailCode() {
    final code = _reauthenticationCode.text.trim();
    _reauthenticationCode.clear();
    return _reauthenticate(AccountReauthentication((b) => b.emailCode = code));
  }

  Future<void> _sendReauthenticationEmail() {
    final resend = _reauthenticationEmailSent;
    return _act(
      () async {
        await widget.repository.accountOperation(
          (api) =>
              api.sendAccountReauthenticationEmail(accountPortal: 'buyers'),
        );
        if (mounted) setState(() => _reauthenticationEmailSent = true);
      },
      resend ? 'A new code was sent to your current email.' : null,
      reload: false,
      scope: _Scope.identity,
    );
  }

  Future<void> _changePassword() => _act(
    () async {
      final password = _newPassword.text;
      final confirmation = _confirmPassword.text;
      _newPassword.clear();
      _confirmPassword.clear();
      await widget.repository.accountOperation(
        (api) => api.changeAccountPassword(
          accountPortal: 'buyers',
          accountPasswordChange: AccountPasswordChange(
            (b) => b
              ..password = password
              ..passwordConfirmation = confirmation,
          ),
        ),
      );
    },
    'Password changed. Other sessions were signed out.',
    reload: false,
    scope: _Scope.password,
  );

  Future<void> _startEmailChange() => _act(
    () async {
      final response = await widget.repository.accountOperation(
        (api) => api.startAccountEmailChange(
          accountPortal: 'buyers',
          accountEmailChange: AccountEmailChange(
            (b) => b.email = _email.text.trim(),
          ),
        ),
      );
      if (mounted) {
        setState(() => _emailChangeId = response.data?.data.id);
      }
    },
    'Check your new email for the verification code.',
    reload: false,
    scope: _Scope.email,
  );

  Future<void> _confirmEmailChange() async {
    if (!await _confirm(
      'Change your primary email and sign out all devices?',
    )) {
      return;
    }
    await _act(
      () async {
        final code = _code.text;
        _code.clear();
        await widget.repository.accountOperation(
          (api) => api.confirmAccountEmailChange(
            accountPortal: 'buyers',
            accountCodeConfirmation: AccountCodeConfirmation(
              (b) => b
                ..id = _emailChangeId!
                ..code = code,
            ),
          ),
        );
        await _signedOut();
      },
      'Email changed.',
      reload: false,
      scope: _Scope.email,
    );
  }

  Widget _notice(_Scope scope) => _message == null || _messageScope != scope
      ? const SizedBox.shrink()
      : Padding(
          padding: scope == _Scope.page
              ? const EdgeInsets.only(bottom: 20)
              : const EdgeInsets.only(top: 16),
          child: AuthNotice(message: _message!, isError: _error),
        );

  Widget _codeField(TextEditingController controller, String label) =>
      TextField(
        controller: controller,
        enabled: !_busy,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 6,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(LucideIcons.mailCheck),
          counterText: '',
        ),
      );

  static const _sectionGap = Padding(
    padding: EdgeInsets.symmetric(vertical: 28),
    child: Divider(height: 1),
  );

  Widget _button(String label, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: FilledButton(onPressed: _busy ? null : action, child: Text(label)),
  );
  Widget _dangerButton(String label, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: _busy ? null : action,
      child: Text(label),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAccountBar(
        context,
        _section == 'Profile'
            ? 'Edit Account Details'
            : _section == 'Sessions'
            ? 'Sessions / Devices'
            : _section,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                children: [
                  if (_profile == null)
                    _busy
                        ? const Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: 'Loading your account',
                              ),
                            ),
                          )
                        : StateMessage(
                            kind: StateKind.error,
                            title: 'Your account could not be loaded',
                            message:
                                _message ??
                                'Check your connection and try again.',
                            actionLabel: 'Retry',
                            onAction: _load,
                          )
                  else ...[
                    SizedBox(
                      height: 4,
                      child: _busy
                          ? const LinearProgressIndicator(
                              semanticsLabel: 'Loading',
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _notice(_Scope.page),
                    ...switch (_section) {
                      'Profile' => _profileSection(context),
                      'Security' => _securitySection(context),
                      'Sessions' => _sessionsSection(context),
                      'Agreements' => _agreementsSection(context),
                      _ => const <Widget>[],
                    },
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _profileSection(BuildContext context) {
    final profile = _profile!;
    final emailHidden = profile.emailMasked ?? profile.email.contains('***');
    final phone = profile.mobileE164?.trim();
    final createdAt = DateTime.tryParse(profile.createdAt ?? '');
    return [
      BuyerAccountSection(
        icon: LucideIcons.userPen,
        title: 'Personal information',
        description: 'Your name and the type of buyer you are on MateryalPH.',
        children: [
          TextField(
            controller: _name,
            enabled: !_busy,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(LucideIcons.userRound),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            isExpanded: true,
            icon: const Icon(LucideIcons.chevronDown),
            initialValue: _buyerType,
            decoration: InputDecoration(
              labelText: 'Buyer type',
              prefixIcon: Icon(
                _buyerType == 'BUSINESS'
                    ? LucideIcons.building2
                    : LucideIcons.user,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'INDIVIDUAL', child: Text('Individual')),
              DropdownMenuItem(value: 'BUSINESS', child: Text('Business')),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _buyerType = value ?? 'INDIVIDUAL'),
          ),
          if (_buyerType == 'BUSINESS') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _company,
              enabled: !_busy,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.organizationName],
              decoration: const InputDecoration(
                labelText: 'Company name',
                prefixIcon: Icon(LucideIcons.building2),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: Listenable.merge([_name, _company]),
            builder: (context, _) => FilledButton(
              onPressed: _busy || !_profileChanged || _name.text.trim().isEmpty
                  ? null
                  : _saveProfile,
              child: const Text('Save changes'),
            ),
          ),
          _notice(_Scope.profile),
        ],
      ),
      _sectionGap,
      BuyerAccountSection(
        icon: LucideIcons.idCard,
        title: 'Contact details',
        description: 'The email and phone number registered to your account.',
        children: [
          BuyerDetailGroup(
            rows: [
              emailHidden
                  ? BuyerDetailRow(
                      icon: LucideIcons.mail,
                      label: 'Email',
                      value:
                          'Verify your identity to view your full email address.',
                      valueMuted: true,
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(44, 44),
                          ),
                          icon: const Icon(LucideIcons.shieldCheck, size: 18),
                          label: const Text('Verify identity'),
                          onPressed: _busy ? null : _openSecurity,
                        ),
                      ),
                    )
                  : BuyerDetailRow(
                      icon: LucideIcons.mail,
                      label: 'Email',
                      value: profile.email,
                      trailing: TextButton(
                        onPressed: _busy ? null : _openSecurity,
                        child: const Text('Change'),
                      ),
                    ),
              BuyerDetailRow(
                icon: LucideIcons.phone,
                label: 'Phone number',
                value: phone?.isNotEmpty == true
                    ? phone!
                    : 'Phone number not added',
                valueMuted: phone?.isNotEmpty != true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                LucideIcons.calendarDays,
                size: 16,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  createdAt == null
                      ? 'Account created: Not available'
                      : 'Account created ${formatManilaDateTime(createdAt)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<Widget> _securitySection(BuildContext context) => [
    BuyerAccountSection(
      icon: LucideIcons.shieldCheck,
      title: 'Verify your identity',
      description:
          'Required before you change your password or primary email. A check stays valid for 15 minutes.',
      children: [
        if (_identityVerified)
          StatusBand(
            tone: BandTone.success,
            title: 'Identity verified',
            message:
                'You can change your password or primary email until ${formatManilaDateTime(_verifiedUntil!)}.',
          )
        else if (!_reauthenticationEmailSent) ...[
          PasswordField(
            controller: _password,
            label: 'Current password',
            enabled: !_busy,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) {
              if (!_busy) _verifyPassword();
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _verifyPassword,
            child: const Text('Verify identity'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _busy ? null : _sendReauthenticationEmail,
            icon: const Icon(LucideIcons.mail, size: 18),
            label: const Text('Send email verification instead'),
          ),
        ] else ...[
          const Text(
            'Enter the 6-digit code we sent to your current email.',
            style: TextStyle(color: BuyerTheme.ink, height: 1.45),
          ),
          const SizedBox(height: 16),
          _codeField(_reauthenticationCode, 'Email verification code'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _verifyEmailCode,
            child: const Text('Verify email code'),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              TextButton(
                onPressed: _busy ? null : _sendReauthenticationEmail,
                child: const Text('Send a new code'),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() {
                        _reauthenticationEmailSent = false;
                        _reauthenticationCode.clear();
                        _message = null;
                      }),
                child: const Text('Use password instead'),
              ),
            ],
          ),
        ],
        _notice(_Scope.identity),
      ],
    ),
    _sectionGap,
    BuyerAccountSection(
      icon: LucideIcons.keyRound,
      title: 'Change password',
      description:
          'Choose a password you don’t use anywhere else. Changing it signs out your other devices.',
      children: [
        PasswordField(
          controller: _newPassword,
          label: 'New password',
          enabled: !_busy,
          helper: 'At least 14 characters with upper/lowercase and a number.',
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: 16),
        PasswordField(
          controller: _confirmPassword,
          label: 'Confirm new password',
          enabled: !_busy,
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _changePassword,
          child: const Text('Update password'),
        ),
        _notice(_Scope.password),
      ],
    ),
    _sectionGap,
    BuyerAccountSection(
      icon: LucideIcons.mail,
      title: 'Change primary email',
      description:
          'We’ll send a code to the new address. Confirming the change signs out all your devices.',
      children: [
        TextField(
          controller: _email,
          enabled: !_busy,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: 'New email',
            prefixIcon: Icon(LucideIcons.atSign),
          ),
        ),
        const SizedBox(height: 16),
        if (_emailChangeId == null)
          FilledButton(
            onPressed: _busy ? null : _startEmailChange,
            child: const Text('Send verification code'),
          )
        else ...[
          _codeField(_code, 'New-email verification code'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _confirmEmailChange,
            child: const Text('Confirm email and sign out'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : _startEmailChange,
            child: const Text('Send a new code'),
          ),
        ],
        _notice(_Scope.email),
      ],
    ),
    const SizedBox(height: 32),
    const StatusBand(
      tone: BandTone.info,
      title: 'Keep your account safe',
      message:
          'Never share passwords or verification codes. If you did not authorize an account change, contact MateryalPH support.',
    ),
  ];

  List<Widget> _sessionsSection(BuildContext context) => [
    if (_sessions.isEmpty) const Text('No active sessions.'),
    ..._sessions.map(
      (session) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${session.description}${session.current ? ' · Current device' : ''}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('Signed in: ${_time(session.createdAt)}'),
          Text('Last active: ${_time(session.lastActiveAt)}'),
          TextButton(
            onPressed: _busy
                ? null
                : () async {
                    if (!await _confirm('Sign out this device?')) {
                      return;
                    }
                    await _act(
                      () async {
                        await widget.repository.accountOperation(
                          (api) => api.revokeAccountSession(
                            accountPortal: 'buyers',
                            sessionId: session.id,
                          ),
                        );
                        if (session.current) await _signedOut();
                      },
                      'Device signed out.',
                      reload: !session.current,
                    );
                  },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Revoke session'),
          ),
          const Divider(),
        ],
      ),
    ),
    if (_lastPage > 1)
      Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: _page > 1 && !_busy
                ? () {
                    setState(() => _page--);
                    _load();
                  }
                : null,
            child: const Text('Previous'),
          ),
          Text('Page $_page of $_lastPage'),
          TextButton(
            onPressed: _page < _lastPage && !_busy
                ? () {
                    setState(() => _page++);
                    _load();
                  }
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    _dangerButton('Sign out other devices', () async {
      if (!await _confirm('Sign out all other devices?')) return;
      await _act(() async {
        await widget.repository.accountOperation(
          (api) => api.revokeAccountSessions(
            accountPortal: 'buyers',
            accountSessionRevocation: AccountSessionRevocation(
              (b) => b.scope = AccountSessionRevocationScopeEnum.OTHERS,
            ),
          ),
        );
      }, 'Other devices signed out.');
    }),
    _dangerButton('Sign out all devices', () async {
      if (!await _confirm('Sign out every device, including this one?')) {
        return;
      }
      await _act(
        () async {
          await widget.repository.accountOperation(
            (api) => api.revokeAccountSessions(
              accountPortal: 'buyers',
              accountSessionRevocation: AccountSessionRevocation(
                (b) => b.scope = AccountSessionRevocationScopeEnum.ALL,
              ),
            ),
          );
          await _signedOut();
        },
        'All devices signed out.',
        reload: false,
      );
    }),
    const SizedBox(height: 8),
    TextButton(
      onPressed: _busy ? null : _load,
      child: const Text('Refresh account'),
    ),
  ];

  List<Widget> _agreementsSection(BuildContext context) => [
    if (_agreements.isEmpty) const Text('No agreements are available.'),
    ..._agreements.map(
      (agreement) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${agreement.title} · Version ${agreement.version}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            agreement.acceptedAt != null
                ? 'Accepted ${_time(agreement.acceptedAt)}'
                : agreement.requiresAcceptance
                ? 'Acceptance required'
                : 'Not yet accepted',
          ),
          const SizedBox(height: 12),
          LegalContent(
            agreement.content ??
                'Approved text is not available yet. Contact support for the published copy.',
          ),
          const SizedBox(height: 16),
          if (agreement.contentAvailable && agreement.acceptedAt == null)
            _button(
              agreement.code == 'PRIVACY_NOTICE'
                  ? 'Acknowledge Privacy Notice'
                  : 'Accept this version',
              () => _act(() async {
                await widget.repository.accountOperation(
                  (api) => api.acceptAccountAgreements(
                    accountPortal: 'buyers',
                    accountAgreementAcceptance: AccountAgreementAcceptance(
                      (b) => b.versionIds.add(agreement.id),
                    ),
                  ),
                );
              }, 'Agreement recorded.'),
            ),
          const Divider(height: 32),
        ],
      ),
    ),
    const SizedBox(height: 8),
    TextButton(
      onPressed: _busy ? null : _load,
      child: const Text('Refresh account'),
    ),
  ];
}
