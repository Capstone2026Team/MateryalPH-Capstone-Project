import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import '../design_system/components/buyer_app_bar.dart';

import '../widgets/auth_content.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import 'risk_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authRepository,
    required this.onAuthenticated,
    required this.onRegister,
    required this.onForgotPassword,
    required this.onBack,
    this.onGoogle,
  });

  final AuthRepository authRepository;
  final VoidCallback onAuthenticated;
  final VoidCallback onRegister;
  final VoidCallback onForgotPassword;
  final VoidCallback onBack;
  final Future<void> Function()? onGoogle;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit({String? proof}) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.authRepository.login(
        email: _email.text,
        password: _password.text,
        proof: proof,
      );
      if (mounted) widget.onAuthenticated();
    } on BuyerRiskChallenge catch (challenge) {
      if (!mounted) return;
      final token = await requestRiskProof(
        context,
        widget.authRepository,
        challenge,
        _email.text,
      );
      if (mounted && token != null) await _submit(proof: token);
    } on StateError catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, '', onBack: widget.onBack),
      body: SafeArea(
        top: false,
        child: AuthContent(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(height: 42),
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Continue to your workspace.',
                    style: TextStyle(color: BuyerTheme.muted),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _email,
                    enabled: !_submitting,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(LucideIcons.mail),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!email.contains('@') || !email.contains('.')) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    enabled: !_submitting,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: _obscurePassword,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitting ? null : _submit(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(LucideIcons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? LucideIcons.eye
                              : LucideIcons.eyeOff,
                        ),
                      ),
                    ),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Enter your password.'
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _submitting ? null : widget.onForgotPassword,
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  if (_error != null) ...[
                    AuthNotice(message: _error!, isError: true),
                    const SizedBox(height: 16),
                  ],
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: Text(_submitting ? 'Signing in…' : 'Sign in'),
                  ),
                  if (widget.onGoogle != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Or sign in with',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: BuyerTheme.muted),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _submitting
                          ? null
                          : () async {
                              setState(() => _submitting = true);
                              try {
                                await widget.onGoogle!();
                              } finally {
                                if (mounted) {
                                  setState(() => _submitting = false);
                                }
                              }
                            },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, size: 32),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Continue with Google',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _submitting ? null : widget.onRegister,
                    child: const Text('New to MateryalPH? Create an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
