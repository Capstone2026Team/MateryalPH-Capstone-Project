import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import '../auth/auth_repository.dart';
import '../design_system/components/buyer_overlays.dart';
import '../design_system/theme.dart';
import '../widgets/auth_content.dart';
import '../widgets/buyer_account_widgets.dart';
import '../widgets/buyer_identity_check.dart';

/// Buyer account deletion. Shows what is kept and anything still open before the Buyer types the
/// confirmation phrase; the server re-checks everything and needs a fresh identity check.
class BuyerDeleteAccountScreen extends StatefulWidget {
  const BuyerDeleteAccountScreen({
    super.key,
    required this.repository,
    required this.onSignedOut,
  });
  final AuthRepository repository;
  final VoidCallback onSignedOut;

  @override
  State<BuyerDeleteAccountScreen> createState() =>
      _BuyerDeleteAccountScreenState();
}

class _BuyerDeleteAccountScreenState extends State<BuyerDeleteAccountScreen> {
  final _phrase = TextEditingController();
  BuyerAccountDeletionPreview? _preview;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _phrase.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _phrase.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await widget.repository.accountOperation(
        (api) => api.getBuyerAccountDeletionPreview(),
      );
      if (mounted) setState(() => _preview = response.data?.data);
    } on BuyerSessionExpired {
      if (mounted) widget.onSignedOut();
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Could not load this page. Check your connection and retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool get _phraseMatches =>
      _preview != null && _phrase.text.trim() == _preview!.confirmationPhrase;

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'You’ll be signed out on every device and can’t sign in to this account again. This can’t be undone.',
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete account'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep my account'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Future<BuyerAccountDeletionResult?> request() async =>
        (await widget.repository.accountOperation(
          (api) => api.deleteBuyerAccount(
            buyerAccountDeletionRequest: BuyerAccountDeletionRequest(
              (b) => b.confirmation =
                  BuyerAccountDeletionRequestConfirmationEnum.DELETE,
            ),
          ),
        )).data?.data;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      BuyerAccountDeletionResult? result;
      try {
        result = await request();
      } on BuyerAuthException catch (error) {
        if (!error.needsRecentAuthentication || !mounted) rethrow;
        final verified = await confirmBuyerIdentity(
          context,
          widget.repository,
          reason: 'Enter your password to delete your account.',
        );
        if (!verified) return;
        result = await request();
      }
      await widget.repository.clearAccountSession();
      if (!mounted) return;
      setState(() => _busy = false);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => BuyerDialog(
          title: const Text('Your account was deleted'),
          content: Text(
            'You’ve been signed out. Records we must keep by law are retained and minimized.'
            '${result?.reference == null ? '' : '\n\nReference: ${result!.reference}'}',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) widget.onSignedOut();
    } on BuyerSessionExpired {
      if (mounted) widget.onSignedOut();
    } on BuyerAuthException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
      if (error.code == 'ACCOUNT_DELETION_BLOCKED') await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAccountBar(context, 'Delete Account'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: AuthContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_busy)
                  const LinearProgressIndicator(semanticsLabel: 'Loading'),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.userX,
                      size: 36,
                      color: colors.error,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  header: true,
                  child: Text(
                    'Delete your MateryalPH account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This permanently closes your Buyer account. You can’t undo it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BuyerTheme.muted, height: 1.5),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  AuthNotice(message: _error!, isError: true),
                ],
                if (preview == null && !_busy) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(onPressed: _load, child: const Text('Retry')),
                ],
                if (preview != null) ...[
                  const BuyerSectionLabel('What happens'),
                  const _Point(
                    icon: LucideIcons.logOut,
                    text:
                        'You’re signed out on every device and can’t sign in again.',
                  ),
                  const _Point(
                    icon: LucideIcons.eyeOff,
                    text:
                        'Your profile, saved locations, cart and favorites are no longer available.',
                  ),
                  const _Point(
                    icon: LucideIcons.mail,
                    text:
                        'We email you a confirmation with a reference number.',
                  ),
                  if (!preview.canDelete) ...[
                    const SizedBox(height: 8),
                    _Blockers(blockers: preview.blockers),
                  ],
                  const BuyerSectionLabel('What we keep'),
                  const Text(
                    'Some records must be kept by law even after deletion. We keep only what’s needed and remove your direct identity when it’s no longer required.',
                    style: TextStyle(color: BuyerTheme.muted, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  for (final record in preview.retainedRecords)
                    _Point(
                      icon: LucideIcons.archive,
                      text: record.category,
                      detail: record.purpose,
                    ),
                  const BuyerSectionLabel('Confirm'),
                  TextField(
                    controller: _phrase,
                    enabled: !_busy && preview.canDelete,
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText:
                          'Type ${preview.confirmationPhrase} to confirm',
                      helperText: 'You’ll also confirm your password.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.error,
                    ),
                    onPressed: _busy || !preview.canDelete || !_phraseMatches
                        ? null
                        : _delete,
                    icon: const Icon(LucideIcons.trash2, size: 20),
                    label: Text(_busy ? 'Please wait…' : 'Delete my account'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).maybePop(),
                    child: const Text('Keep my account'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Blockers extends StatelessWidget {
  const _Blockers({required this.blockers});
  final BuyerAccountDeletionBlockers blockers;

  @override
  Widget build(BuildContext context) {
    String count(int value, String one, String many) =>
        '$value ${value == 1 ? one : many}';
    final items = [
      if (blockers.activeOrders > 0)
        count(blockers.activeOrders, 'open order', 'open orders'),
      if (blockers.activeDisputes > 0)
        count(blockers.activeDisputes, 'open dispute', 'open disputes'),
      if (blockers.pendingRefunds > 0)
        count(
          blockers.pendingRefunds,
          'refund in progress',
          'refunds in progress',
        ),
    ];
    return AuthNotice(
      isError: true,
      message:
          'You can delete your account after these are finished or closed: ${items.join(', ')}.',
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text, this.detail});
  final IconData icon;
  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: BuyerTheme.muted),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(height: 1.5, color: BuyerTheme.ink),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: const TextStyle(
                    height: 1.4,
                    fontSize: 13,
                    color: BuyerTheme.muted,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
