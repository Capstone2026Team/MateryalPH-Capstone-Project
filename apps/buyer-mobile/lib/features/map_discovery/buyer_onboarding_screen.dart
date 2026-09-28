import 'package:flutter/material.dart';

import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';

/// Industry list approved by the project owner on 2026-09-28.
const Map<String, String> kBuyerIndustries = {
  'GENERAL_CONTRACTOR': 'General contractor',
  'SUBCONTRACTOR_TRADE': 'Subcontractor or trade',
  'INDEPENDENT_BUILDER': 'Independent builder',
  'DIY_HOMEOWNER': 'DIY or homeowner',
  'OTHER': 'Other',
};

/// Optional Buyer profile onboarding. Every field may stay empty; Skip keeps the account complete.
class BuyerOnboardingScreen extends StatefulWidget {
  const BuyerOnboardingScreen({
    super.key,
    required this.repository,
    required this.initial,
  });

  final DiscoveryRepository repository;
  final BuyerOnboardingView initial;

  @override
  State<BuyerOnboardingScreen> createState() => _BuyerOnboardingScreenState();
}

class _BuyerOnboardingScreenState extends State<BuyerOnboardingScreen> {
  late final _company = TextEditingController(text: widget.initial.companyName);
  late final _position = TextEditingController(
    text: widget.initial.positionTitle,
  );
  late final _other = TextEditingController(
    text: widget.initial.industryOtherLabel,
  );
  late String? _industry = widget.initial.industry;
  late final Set<String> _categories = {...widget.initial.preferredCategoryIds};
  late int _lockVersion = widget.initial.lockVersion;
  final _form = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _company.dispose();
    _position.dispose();
    _other.dispose();
    super.dispose();
  }

  Future<void> _submit(String action) async {
    if (action != 'SKIP' && !(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await widget.repository.saveOnboarding(
        lockVersion: _lockVersion,
        action: action,
        companyName: action == 'SKIP' ? null : _company.text.trim(),
        positionTitle: action == 'SKIP' ? null : _position.text.trim(),
        industry: action == 'SKIP' ? null : _industry,
        industryOtherLabel: action == 'SKIP' || _industry != 'OTHER'
            ? null
            : _other.text.trim(),
        preferredCategoryIds: action == 'SKIP' ? null : _categories.toList(),
      );
      _lockVersion = result.lockVersion;
      if (mounted) Navigator.of(context).pop();
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error.kind == DiscoveryFailureKind.conflict
            ? 'Your profile changed on another device. Close this screen and open it again.'
            : error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(title: const Text('About your work')),
    body: SafeArea(
      child: AuthContent(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'All fields are optional. Company details are not required for independent or DIY builders.',
                style: TextStyle(color: BuyerTheme.muted),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                AuthNotice(message: _error!, isError: true),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _company,
                maxLength: 180,
                decoration: const InputDecoration(
                  labelText: 'Business or company name',
                ),
              ),
              TextFormField(
                controller: _position,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Position or role',
                ),
              ),
              DropdownButtonFormField<String?>(
                initialValue: _industry,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Contractor or industry classification',
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Prefer not to say'),
                  ),
                  for (final entry in kBuyerIndustries.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                ],
                onChanged: (value) => setState(() => _industry = value),
              ),
              if (_industry == 'OTHER') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _other,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Describe your industry',
                  ),
                  validator: (value) => (value?.trim().length ?? 0) < 2
                      ? 'Describe your industry in at least 2 characters.'
                      : null,
                ),
              ],
              const SizedBox(height: 16),
              Semantics(
                header: true,
                child: const Text(
                  'Preferred material categories',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in widget.initial.categories)
                    FilterChip(
                      label: Text(category.name),
                      selected: _categories.contains(category.id),
                      onSelected: (selected) => setState(
                        () => selected
                            ? _categories.add(category.id)
                            : _categories.remove(category.id),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _busy ? null : () => _submit('COMPLETE'),
                child: const Text('Save and finish'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _busy ? null : () => _submit('SKIP'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
