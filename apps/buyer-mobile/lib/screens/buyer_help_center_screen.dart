import '../features/support/support_repository.dart';
import '../features/support/support_screens.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/components/procurement_components.dart';
import '../design_system/theme.dart';
import '../widgets/buyer_account_widgets.dart';

/// One question and its answer. Answers restate approved workflow rules only.
class HelpAnswer {
  const HelpAnswer(this.question, this.answer);
  final String question;
  final String answer;

  bool matches(String query) =>
      question.toLowerCase().contains(query) ||
      answer.toLowerCase().contains(query);
}

class HelpTopic {
  const HelpTopic(this.title, this.icon, this.answers);
  final String title;
  final IconData icon;
  final List<HelpAnswer> answers;
}

const buyerHelpTopics = <HelpTopic>[
  HelpTopic('Orders', LucideIcons.package, [
    HelpAnswer(
      'When is my order confirmed?',
      'Each Vendor reviews its own order request. Your order is confirmed when the Vendor accepts it; '
          'some stores accept eligible Item-Based orders automatically. Until then, Orders shows it as '
          'waiting for the Vendor, and you can still withdraw it.',
    ),
    HelpAnswer(
      'The Vendor changed my order. What should I do?',
      'If the Vendor reduces a quantity, adds a discount or adds a non-refundable preparation cost, '
          'review the change in Order Details. You have 24 hours to approve or reject it. If you reject '
          'it, the request is cancelled; if you do not reply in time, it expires.',
    ),
    HelpAnswer(
      'Where are my Purchase Order and invoice?',
      'Order Details shows the Purchase Order and any invoice the Vendor has uploaded, and lets you '
          'request a copy or correction. The Purchase Order and payment confirmation are not the '
          'Vendor’s tax invoice.',
    ),
  ]),
  HelpTopic('Payments', LucideIcons.wallet, [
    HelpAnswer(
      'How do I pay for an online order?',
      'Tap Pay in Order Details and choose one of the methods shown, such as a card, GCash, Maya, '
          'GrabPay or ShopeePay. You have 45 minutes once the order is awaiting payment; after that '
          'the order expires.',
    ),
    HelpAnswer(
      'I paid, but the order still shows unpaid.',
      'An order is marked paid only after the payment provider confirms it to MateryalPH, not when '
          'the payment page closes. Pull down on Order Details to refresh. Pay again only if the '
          'payment shows as failed or expired.',
    ),
    HelpAnswer(
      'Why is there a payment processing fee?',
      'Online payments list the payment processing fee as its own line so you can see what the '
          'payment provider charges, separate from the materials and delivery fee.',
    ),
    HelpAnswer(
      'Can I pay cash on delivery or in store?',
      'Only when the Vendor offers it; it then appears as a payment option. The Vendor records the '
          'cash it receives, and you can confirm or dispute that record in Order Details.',
    ),
  ]),
  HelpTopic('Delivery & Pickup', LucideIcons.truck, [
    HelpAnswer(
      'How do I track my order?',
      'Order Details shows each fulfillment milestone, and you get in-app and push notifications as '
          'it moves. Use Fulfillment Messages on the order to coordinate pickup or delivery with the '
          'Vendor’s team.',
    ),
    HelpAnswer(
      'What happens after delivery or pickup?',
      'Check the proof of delivery and tap Confirm Receipt. If you do nothing, the order is confirmed '
          'automatically 48 hours after delivery or pickup, with reminders before then. Reporting a '
          'problem pauses the automatic confirmation.',
    ),
  ]),
  HelpTopic('Cancellations & Refunds', LucideIcons.rotateCcw, [
    HelpAnswer(
      'Can I cancel my order?',
      'Before the Vendor confirms, you can withdraw the request. After confirmation and before '
          'preparation starts, cancelling takes effect right away and anything you paid is refunded in '
          'full. During '
          'Processing, send a cancellation request with a reason; the Vendor has 24 hours to finalize '
          'it. Cancellation is not available once the order is Ready for Pickup or Out for Delivery — '
          'report a problem instead.',
    ),
    HelpAnswer(
      'Where does my refund go?',
      'Online payments are refunded to the original payment method; MateryalPH never asks for a '
          'different card, e-wallet or bank account. Cash paid to the Vendor is reimbursed by the '
          'Vendor, and you confirm when it reaches you. Follow each refund under Cancellations & '
          'Refunds.',
    ),
    HelpAnswer(
      'What is a non-refundable preparation cost (NRPC)?',
      'It covers work the Vendor prepares only for your order. It must be shown before you accept, '
          'and it is part of the order total, not added to it. If the Vendor cancels, you get it back. '
          'If you cancel during Processing, the Vendor may keep it only with evidence of preparation.',
    ),
  ]),
  HelpTopic('Problems & Disputes', LucideIcons.scale, [
    HelpAnswer(
      'Something is wrong with my order.',
      'Open the order and tap Report a Problem. Choose the issue, the affected items and the remedy '
          'you want, and add evidence. You get a Case ID to follow under Disputes.',
    ),
    HelpAnswer(
      'How is a dispute decided?',
      'The Vendor responds first, and you can agree on a resolution together. Otherwise MateryalPH '
          'reviews the case. One appeal is allowed per case, within 5 business days of the decision, '
          'with new relevant evidence; the appeal decision is final. An awarded refund appears as a '
          'separate refund on the case.',
    ),
  ]),
  HelpTopic('Reviews', LucideIcons.star, [
    HelpAnswer(
      'When can I rate a Vendor?',
      'After an order is completed, rate the Vendor and each product within 14 days. Ratings stay '
          'hidden until the Vendor also rates you or the 14 days end. You can correct a submitted '
          'review within 24 hours.',
    ),
  ]),
  HelpTopic('Account & Security', LucideIcons.shieldCheck, [
    HelpAnswer(
      'How do I keep my account secure?',
      'Turn on Two-Factor Authentication in Account Setting and check Sessions / Devices for '
          'devices you do not recognize. Never share your password, one-time codes or recovery codes '
          'in messages.',
    ),
    HelpAnswer(
      'How do I delete my account?',
      'Open Account Setting, then Delete Account. Deletion is unavailable while an order is still '
          'open, a dispute is active or a refund is pending. Order, payment, dispute and review records '
          'are retained, not deleted.',
    ),
  ]),
  HelpTopic('Terms & Agreements', LucideIcons.fileCheck, [
    HelpAnswer(
      'Where can I read the Terms I accepted?',
      'Open Profile, then Terms & Agreements. Each agreement shows its version, its full text and '
          'when you accepted it.',
    ),
    HelpAnswer(
      'What if a new version needs my acceptance?',
      'Terms & Agreements marks it as Acceptance required. Read the new version and tap Accept this '
          'version. The Privacy Notice is acknowledged separately from the Terms of Service.',
    ),
  ]),
];

/// Answers to common Buyer questions, browsed by topic or found by search.
class BuyerHelpCenterScreen extends StatefulWidget {
  const BuyerHelpCenterScreen({super.key, this.supportRepository});
  final SupportRepository? supportRepository;

  @override
  State<BuyerHelpCenterScreen> createState() => _BuyerHelpCenterScreenState();
}

class _BuyerHelpCenterScreenState extends State<BuyerHelpCenterScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final searching = _query.isNotEmpty;
    final topics = [
      for (final topic in buyerHelpTopics)
        HelpTopic(topic.title, topic.icon, [
          for (final answer in topic.answers)
            if (searching && answer.matches(_query)) answer,
        ]),
    ].where((topic) => topic.answers.isNotEmpty).toList();
    final found = topics.fold(0, (sum, topic) => sum + topic.answers.length);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAccountBar(context, 'Help Center'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            PillSearchField(
              controller: _search,
              hintText: 'Search help topics',
              onChanged: (value) =>
                  setState(() => _query = value.trim().toLowerCase()),
              onClear: searching ? _clear : null,
            ),
            if (searching)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 8),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    found == 1 ? '1 answer found' : '$found answers found',
                    style: const TextStyle(color: BuyerTheme.muted),
                  ),
                ),
              ),
            if (widget.supportRepository != null) ...[
              const BuyerSectionLabel('Contact MateryalPH'),
              BuyerMenuRow(
                label: 'Contact Us',
                icon: LucideIcons.mail,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SupportFormScreen(
                      repository: widget.supportRepository!,
                    ),
                  ),
                ),
              ),
              BuyerMenuRow(
                label: 'My Support Requests',
                icon: LucideIcons.messagesSquare,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SupportRequestsScreen(
                      repository: widget.supportRepository!,
                    ),
                  ),
                ),
              ),
            ],
            if (!searching) ...[
              const BuyerSectionLabel('Get help with'),
              for (final topic in buyerHelpTopics)
                BuyerMenuRow(
                  label: topic.title,
                  icon: topic.icon,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BuyerHelpTopicScreen(topic: topic),
                    ),
                  ),
                ),
            ],
            if (searching && topics.isEmpty)
              StateMessage(
                kind: StateKind.empty,
                compact: true,
                title: 'No answers found',
                message:
                    'Try another word, such as refund, payment or delivery.',
                actionLabel: 'Clear search',
                onAction: _clear,
              ),
            for (final topic in topics) ...[
              BuyerSectionLabel(topic.title),
              for (final answer in topic.answers)
                _AnswerTile(
                  key: ValueKey((answer.question, searching)),
                  answer: answer,
                  expanded: searching,
                ),
            ],
            if (!searching) ...[
              const SizedBox(height: 28),
              const _StillNeedHelp(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Every question and answer in one topic.
class BuyerHelpTopicScreen extends StatelessWidget {
  const BuyerHelpTopicScreen({super.key, required this.topic});
  final HelpTopic topic;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, topic.title),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          for (final answer in topic.answers)
            _AnswerTile(answer: answer, expanded: false),
          const SizedBox(height: 28),
          const _StillNeedHelp(),
        ],
      ),
    ),
  );
}

class _StillNeedHelp extends StatelessWidget {
  const _StillNeedHelp();

  @override
  Widget build(BuildContext context) => const StatusBand(
    tone: BandTone.info,
    title: 'Still need help?',
    message:
        'For platform concerns, choose Contact Us in Help Center. '
        'Message the Vendor from the order, or follow your case under Disputes. '
        'Decisions and refunds on a case appear in that case.',
  );
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({super.key, required this.answer, required this.expanded});
  final HelpAnswer answer;
  final bool expanded;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ExpansionTile(
        initiallyExpanded: expanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        expandedAlignment: Alignment.centerLeft,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: BuyerTheme.action,
        collapsedIconColor: BuyerTheme.muted,
        title: Text(
          answer.question,
          style: const TextStyle(
            color: BuyerTheme.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            answer.answer,
            style: const TextStyle(color: BuyerTheme.muted, height: 1.45),
          ),
        ],
      ),
      const Divider(height: 1),
    ],
  );
}
