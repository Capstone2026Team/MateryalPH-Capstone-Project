import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../widgets/brandwithoutname_lockup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.onGoogle,
  });
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final Future<void> Function() onGoogle;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _openingGoogle = false;

  Future<void> _google() async {
    setState(() => _openingGoogle = true);
    try {
      await widget.onGoogle();
    } finally {
      if (mounted) setState(() => _openingGoogle = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 44).clamp(
                    0,
                    double.infinity,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (constraints.maxHeight * .14).clamp(24, 112),
                      ),
                      child: Column(
                        children: [
                          const BrandWithoutNameLockup(),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Welcome to Materyal'),
                                TextSpan(
                                  text: 'PH',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(height: 24),
                          Text(
                            'A better start for your next build.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Create your Buyer account to connect with construction-material suppliers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: BuyerTheme.muted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          onPressed: _openingGoogle ? null : widget.onRegister,
                          child: const Text('Create buyer account'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _openingGoogle ? null : _google,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.g_mobiledata, size: 32),
                              const SizedBox(width: 8),
                              Text(
                                _openingGoogle
                                    ? 'Opening Google…'
                                    : 'Continue with Google',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _openingGoogle ? null : widget.onLogin,
                          child: const Text('Already have an account? Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
