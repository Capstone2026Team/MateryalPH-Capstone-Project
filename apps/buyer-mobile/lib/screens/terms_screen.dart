import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import '../widgets/auth_content.dart';
import '../widgets/legal_content.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({
    super.key,
    required this.repository,
    required this.onAccepted,
    required this.onBack,
  });
  final AuthRepository repository;
  final VoidCallback onAccepted;
  final VoidCallback onBack;
  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final _scroll = ScrollController();
  Agreement? _terms;
  String? _error;
  bool _reachedEnd = false;
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_checkEnd);
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _terms = null;
      _error = null;
      _reachedEnd = false;
    });
    try {
      final terms = await widget.repository.loadRegistrationTerms();
      if (!mounted) return;
      setState(() => _terms = terms);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is BuyerAuthException
              ? error.message
              : 'Could not load the Terms. Please retry.',
        );
      }
    }
  }

  void _checkEnd() {
    if (_terms != null &&
        !_reachedEnd &&
        _scroll.hasClients &&
        _scroll.position.hasContentDimensions &&
        _scroll.position.extentAfter <= 4) {
      setState(() => _reachedEnd = true);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) widget.onBack();
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: widget.onBack,
          icon: const Icon(LucideIcons.arrowLeft, color: BuyerTheme.action),
        ),
        title: const Text('Terms of Service'),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Expanded(
                  child: _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AuthNotice(message: _error!, isError: true),
                                TextButton(
                                  onPressed: _load,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _terms == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: 'Loading Terms',
                          ),
                        )
                      : NotificationListener<ScrollMetricsNotification>(
                          onNotification: (_) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) _checkEnd();
                            });
                            return false;
                          },
                          child: Scrollbar(
                            controller: _scroll,
                            child: SingleChildScrollView(
                              key: const Key('terms-content'),
                              controller: _scroll,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Welcome to Materyal',
                                        ),
                                        TextSpan(
                                          text: 'PH',
                                          style: const TextStyle(
                                            color: BuyerTheme.action,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Review the current Terms before creating your Buyer account.',
                                    style: TextStyle(color: BuyerTheme.muted),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _terms!.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'Version ${_terms!.version} · Effective ${_terms!.effectiveAt.toLocal().toString().split(' ').first}',
                                    style: const TextStyle(
                                      color: BuyerTheme.muted,
                                    ),
                                  ),
                                  const Divider(),
                                  LegalContent(_terms!.content!),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'End of Terms of Service',
                                    style: TextStyle(color: BuyerTheme.muted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_reachedEnd)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Scroll to the end to continue.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: BuyerTheme.muted),
                          ),
                        ),
                      FilledButton(
                        onPressed: !_reachedEnd || _terms == null
                            ? null
                            : () {
                                widget.repository.acceptReviewedTerms(_terms!);
                                widget.onAccepted();
                              },
                        child: const Text('Accept and continue'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
