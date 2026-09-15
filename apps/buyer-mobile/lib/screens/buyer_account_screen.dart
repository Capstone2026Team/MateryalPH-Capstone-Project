import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../auth/auth_repository.dart';
import '../widgets/auth_content.dart';

class BuyerAccountScreen extends StatefulWidget {
  const BuyerAccountScreen({
    super.key,
    required this.repository,
    required this.onSignedOut,
  });
  final AuthRepository repository;
  final VoidCallback onSignedOut;

  @override
  State<BuyerAccountScreen> createState() => _BuyerAccountScreenState();
}

class _BuyerAccountScreenState extends State<BuyerAccountScreen> {
  AccountProfile? _profile;
  List<AccountSession> _sessions = [];
  List<AccountAgreement> _agreements = [];
  String _section = 'Profile';
  bool _busy = false;
  bool _error = false;
  String? _message;
  String? _emailChangeId;
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
          _error = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _act(
    Future<void> Function() operation,
    String message, {
    bool reload = true,
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
        builder: (context) => AlertDialog(
          title: const Text('Confirm account action'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
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

  Widget _field(
    String label,
    TextEditingController controller, {
    bool secret = false,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      obscureText: secret,
      keyboardType: keyboard,
      autocorrect: !secret,
      enableSuggestions: !secret,
      decoration: InputDecoration(labelText: label),
    ),
  );
  Widget _button(String label, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: FilledButton(onPressed: _busy ? null : action, child: Text(label)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_section)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (_busy) const LinearProgressIndicator(),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: AuthNotice(message: _message!, isError: _error),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Profile', 'Security', 'Sessions', 'Agreements']
                    .map(
                      (item) => ChoiceChip(
                        label: Text(item),
                        selected: _section == item,
                        onSelected: _busy
                            ? null
                            : (_) {
                                setState(() {
                                  _section = item;
                                  _page = 1;
                                  _message = null;
                                });
                                _load();
                              },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              if (_profile == null) ...[
                const Text('Your account could not be loaded yet.'),
                _button('Retry', _load),
              ] else if (_section == 'Profile') ...[
                Text(
                  'Personal information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                _field('Full name', _name),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _buyerType,
                  decoration: const InputDecoration(labelText: 'Buyer type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'INDIVIDUAL',
                      child: Text('Individual'),
                    ),
                    DropdownMenuItem(
                      value: 'BUSINESS',
                      child: Text('Business'),
                    ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) =>
                            setState(() => _buyerType = value ?? 'INDIVIDUAL'),
                ),
                const SizedBox(height: 16),
                if (_buyerType == 'BUSINESS') _field('Company name', _company),
                _button(
                  'Save profile',
                  () => _act(() async {
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
                  }, 'Profile saved.'),
                ),
                Text('Email: ${_profile!.email}'),
                const SizedBox(height: 12),
                Text('Account created: ${_time(_profile!.createdAt)}'),
              ] else if (_section == 'Security') ...[
                Text(
                  'Verify your identity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Verify before changing your password or primary email.',
                ),
                const SizedBox(height: 16),
                _field('Current password', _password, secret: true),
                _button(
                  'Verify identity',
                  () => _act(
                    () async {
                      final password = _password.text;
                      _password.clear();
                      await widget.repository.accountOperation(
                        (api) => api.reauthenticateAccount(
                          accountPortal: 'buyers',
                          accountReauthentication: AccountReauthentication(
                            (b) => b.password = password,
                          ),
                        ),
                      );
                    },
                    'Identity verified for 15 minutes.',
                    reload: false,
                  ),
                ),
                _button(
                  'Send email verification instead',
                  () => _act(
                    () async {
                      await widget.repository.accountOperation(
                        (api) => api.sendAccountReauthenticationEmail(
                          accountPortal: 'buyers',
                        ),
                      );
                    },
                    'A verification code was sent to your current email.',
                    reload: false,
                  ),
                ),
                _field(
                  'Current-email verification code',
                  _reauthenticationCode,
                ),
                _button(
                  'Verify email code',
                  () => _act(
                    () async {
                      final code = _reauthenticationCode.text;
                      _reauthenticationCode.clear();
                      await widget.repository.accountOperation(
                        (api) => api.reauthenticateAccount(
                          accountPortal: 'buyers',
                          accountReauthentication: AccountReauthentication(
                            (b) => b.emailCode = code,
                          ),
                        ),
                      );
                    },
                    'Identity verified for 15 minutes.',
                    reload: false,
                  ),
                ),
                const Divider(height: 32),
                Text(
                  'Change password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _field(
                  'New password (at least 14 characters)',
                  _newPassword,
                  secret: true,
                ),
                _field('Confirm new password', _confirmPassword, secret: true),
                _button(
                  'Change password',
                  () => _act(
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
                  ),
                ),
                const Divider(height: 32),
                Text(
                  'Change primary email',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _field(
                  'New email',
                  _email,
                  keyboard: TextInputType.emailAddress,
                ),
                _button(
                  'Send email verification',
                  () => _act(
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
                  ),
                ),
                if (_emailChangeId != null) ...[
                  _field(
                    'New-email verification code',
                    _code,
                    keyboard: TextInputType.number,
                  ),
                  _button('Confirm email and sign out', () async {
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
                    );
                  }),
                ],
                const Text(
                  'Never share passwords or verification codes. If you did not authorize an account change, contact MateryalPH support.',
                ),
              ] else if (_section == 'Sessions') ...[
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
                        child: const Text('Revoke session'),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                if (_lastPage > 1)
                  Row(
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
                      Expanded(child: Text('Page $_page of $_lastPage')),
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
                _button('Sign out other devices', () async {
                  if (!await _confirm('Sign out all other devices?')) return;
                  await _act(() async {
                    await widget.repository.accountOperation(
                      (api) => api.revokeAccountSessions(
                        accountPortal: 'buyers',
                        accountSessionRevocation: AccountSessionRevocation(
                          (b) => b.scope =
                              AccountSessionRevocationScopeEnum.OTHERS,
                        ),
                      ),
                    );
                  }, 'Other devices signed out.');
                }),
                _button('Sign out all devices', () async {
                  if (!await _confirm(
                    'Sign out every device, including this one?',
                  )) {
                    return;
                  }
                  await _act(
                    () async {
                      await widget.repository.accountOperation(
                        (api) => api.revokeAccountSessions(
                          accountPortal: 'buyers',
                          accountSessionRevocation: AccountSessionRevocation(
                            (b) =>
                                b.scope = AccountSessionRevocationScopeEnum.ALL,
                          ),
                        ),
                      );
                      await _signedOut();
                    },
                    'All devices signed out.',
                    reload: false,
                  );
                }),
              ] else if (_section == 'Agreements') ...[
                if (_agreements.isEmpty)
                  const Text('No agreements are available.'),
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
                      Text(
                        agreement.content ??
                            'Approved text is not available yet. Contact support for the published copy.',
                      ),
                      const SizedBox(height: 16),
                      if (agreement.contentAvailable &&
                          agreement.acceptedAt == null)
                        _button(
                          agreement.code == 'PRIVACY_NOTICE'
                              ? 'Acknowledge Privacy Notice'
                              : 'Accept this version',
                          () => _act(() async {
                            await widget.repository.accountOperation(
                              (api) => api.acceptAccountAgreements(
                                accountPortal: 'buyers',
                                accountAgreementAcceptance:
                                    AccountAgreementAcceptance(
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
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: _busy ? null : _load,
                child: const Text('Refresh account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
