import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../design_system/components/procurement_components.dart';
import '../../widgets/buyer_account_widgets.dart';
import '../disputes/dispute_screens.dart' show openCaseFile;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import '../orders/order_models.dart' show formatManilaDateTime;
import 'support_repository.dart';

const supportPrivacyNotice =
    'MateryalPH uses your contact details, messages, references and attachments to investigate and respond to your concern. Access is limited to you and authorized administrators. Records are retained under platform retention and legal obligations. Share only relevant information. Never send passwords, one-time codes or full payment credentials. You may request access or correction through support. The full Privacy Notice is available in Profile, Terms & Agreements.';
String supportLabel(String value) => value == 'FEEDBACK_SUGGESTION'
    ? 'Feedback / Suggestion'
    : value
          .split('_')
          .map(
            (word) => word.isEmpty
                ? ''
                : '${word[0]}${word.substring(1).toLowerCase()}',
          )
          .join(' ');
String _error(Object error) => error is DiscoveryFailure
    ? error.message
    : 'The support request could not be completed. Check your connection and retry.';
String _date(DateTime value) => formatManilaDateTime(value);

class SupportRequestsScreen extends StatefulWidget {
  const SupportRequestsScreen({super.key, required this.repository});
  final SupportRepository repository;
  @override
  State<SupportRequestsScreen> createState() => _SupportRequestsScreenState();
}

class _SupportRequestsScreenState extends State<SupportRequestsScreen> {
  final _items = <api.SupportTicket>[];
  String? _cursor;
  String? _failure;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool more = false}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final page = await widget.repository.list(more ? _cursor : null);
      if (mounted) {
        setState(() {
          if (!more) _items.clear();
          _items.addAll(page.data);
          _cursor = page.meta.nextCursor;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(String id) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            SupportDetailScreen(repository: widget.repository, ticketId: id),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAccountBar(context, 'My Support Requests'),
    body: RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          FilledButton(
            onPressed: () async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) =>
                      SupportFormScreen(repository: widget.repository),
                ),
              );
              if (mounted) _load();
            },
            child: const Text('Contact Us'),
          ),
          const SizedBox(height: 16),
          if (_failure != null)
            StateMessage(
              kind: StateKind.error,
              title: 'Could not load requests',
              message: _failure!,
              actionLabel: 'Retry',
              onAction: () => _load(),
            ),
          if (_busy)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          if (!_busy && _failure == null && _items.isEmpty)
            const StateMessage(
              kind: StateKind.empty,
              title: 'No support requests yet',
              message:
                  'Contact Us to send a concern to the MateryalPH administration team.',
            ),
          for (final ticket in _items)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              title: Text(ticket.subject),
              subtitle: Text(
                '${ticket.ticketNumber}\n${supportLabel(ticket.status.name)} - ${_date(ticket.createdAt)}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open(ticket.id),
            ),
          if (_cursor != null)
            OutlinedButton(
              onPressed: _busy ? null : () => _load(more: true),
              child: const Text('Load more requests'),
            ),
        ],
      ),
    ),
  );
}

class SupportFormScreen extends StatefulWidget {
  const SupportFormScreen({super.key, required this.repository});
  final SupportRepository repository;
  @override
  State<SupportFormScreen> createState() => _SupportFormScreenState();
}

class _SupportFormScreenState extends State<SupportFormScreen> {
  final _form = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  final _reference = TextEditingController();
  api.AccountProfile? _profile;
  api.SupportCategory _category = api.SupportCategory.GENERAL_INQUIRY;
  api.SupportReferenceType? _referenceType;
  List<SupportUpload> _files = [];
  String _key = newIdempotencyKey();
  String? _failure;
  bool _loading = true;
  bool _busy = false;
  bool _privacy = false;
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final profile = await widget.repository.profile();
      if (mounted) setState(() => _profile = profile);
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _changed() {
    _key = newIdempotencyKey();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (!_privacy) {
      setState(
        () => _failure =
            'Acknowledge the support privacy notice before submitting.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final receipt = await widget.repository.create(
        category: _category,
        subject: _subject.text.trim(),
        message: _message.text.trim(),
        key: _key,
        files: _files,
        referenceType: _referenceType,
        reference: _referenceType == null ? null : _reference.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => SupportDetailScreen(
            repository: widget.repository,
            ticketId: receipt.id,
            createdTicketNumber: receipt.ticketNumber,
          ),
        ),
      );
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAccountBar(context, 'Contact Us'),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Send a concern to the MateryalPH administration team. Responses and follow-ups stay in a private support ticket.',
        ),
        const SizedBox(height: 20),
        if (_loading) const Center(child: CircularProgressIndicator()),
        if (_failure != null)
          StateMessage(
            kind: StateKind.error,
            title: 'Please try again',
            message: _failure!,
            actionLabel: _profile == null ? 'Retry account details' : null,
            onAction: _profile == null ? _loadProfile : null,
          ),
        if (_profile != null)
          Form(
            key: _form,
            onChanged: _changed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: _profile!.fullName,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _profile!.email,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Registered email',
                    helperText: 'Your account email is used for this request.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('User type: Buyer'),
                const SizedBox(height: 16),
                DropdownButtonFormField<api.SupportCategory>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Concern category',
                  ),
                  items: [
                    for (final item in api.SupportCategory.values)
                      DropdownMenuItem(
                        value: item,
                        child: Text(supportLabel(item.name)),
                      ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) => setState(() {
                          _category = value!;
                          _changed();
                        }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subject,
                  enabled: !_busy,
                  maxLength: 160,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (value) => (value?.trim().length ?? 0) < 3
                      ? 'Enter a subject of at least 3 characters.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _message,
                  enabled: !_busy,
                  minLines: 5,
                  maxLines: 10,
                  maxLength: 10000,
                  decoration: const InputDecoration(
                    labelText: 'Message / Description',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => (value?.trim().length ?? 0) < 3
                      ? 'Describe your concern in at least 3 characters.'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<api.SupportReferenceType?>(
                  initialValue: _referenceType,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Reference type (optional)',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No reference'),
                    ),
                    for (final item in api.SupportReferenceType.values)
                      DropdownMenuItem(
                        value: item,
                        child: Text(supportLabel(item.name)),
                      ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) => setState(() {
                          _referenceType = value;
                          _changed();
                        }),
                ),
                if (_referenceType != null) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reference,
                    enabled: !_busy,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: 'Existing reference number or ID',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter the existing reference.'
                        : null,
                  ),
                ],
                const SizedBox(height: 16),
                SupportAttachmentEditor(
                  files: _files,
                  enabled: !_busy,
                  onChanged: (files) => setState(() {
                    _files = files;
                    _changed();
                  }),
                ),
                const Divider(height: 32),
                const Text(supportPrivacyNotice),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'I acknowledge how my support information will be used.',
                  ),
                  value: _privacy,
                  onChanged: _busy
                      ? null
                      : (value) => setState(() {
                          _privacy = value ?? false;
                          _changed();
                        }),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(
                    _busy ? 'Submitting inquiry...' : 'Submit inquiry',
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

class SupportAttachmentEditor extends StatefulWidget {
  const SupportAttachmentEditor({
    super.key,
    required this.files,
    required this.onChanged,
    this.enabled = true,
  });
  final List<SupportUpload> files;
  final ValueChanged<List<SupportUpload>> onChanged;
  final bool enabled;
  @override
  State<SupportAttachmentEditor> createState() =>
      _SupportAttachmentEditorState();
}

class _SupportAttachmentEditorState extends State<SupportAttachmentEditor> {
  String? _error;
  bool _picking = false;
  Future<void> _pick() async {
    setState(() {
      _picking = true;
      _error = null;
    });
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );
      if (file == null) return;
      final bytes = await file.xFile.readAsBytes();
      if (!mounted) return;
      if (bytes.isEmpty || bytes.length > 3 * 1024 * 1024) {
        setState(
          () => _error = 'Each attachment must be between 1 byte and 3 MB.',
        );
        return;
      }
      widget.onChanged([...widget.files, SupportUpload(file.name, bytes)]);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'The file could not be selected. Please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Attachments (optional)',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      const Text(
        'Up to 3 JPG, PNG or PDF files, at most 3 MB each. Files are checked and stored privately.',
      ),
      for (var i = 0; i < widget.files.length; i++)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(widget.files[i].name),
          trailing: IconButton(
            tooltip: 'Remove ${widget.files[i].name}',
            onPressed: widget.enabled
                ? () => widget.onChanged([...widget.files]..removeAt(i))
                : null,
            icon: const Icon(Icons.close),
          ),
        ),
      if (_error != null)
        Text(
          _error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      OutlinedButton.icon(
        onPressed: widget.enabled && !_picking && widget.files.length < 3
            ? _pick
            : null,
        icon: const Icon(Icons.attach_file),
        label: Text(_picking ? 'Selecting file...' : 'Add attachment'),
      ),
    ],
  );
}

class SupportDetailScreen extends StatefulWidget {
  const SupportDetailScreen({
    super.key,
    required this.repository,
    required this.ticketId,
    this.createdTicketNumber,
  });
  final SupportRepository repository;
  final String ticketId;
  final String? createdTicketNumber;
  @override
  State<SupportDetailScreen> createState() => _SupportDetailScreenState();
}

class _SupportDetailScreenState extends State<SupportDetailScreen> {
  api.SupportTicket? _ticket;
  final _entries = <api.SupportEntry>[];
  final _message = TextEditingController();
  final _form = GlobalKey<FormState>();
  List<SupportUpload> _files = [];
  String? _cursor;
  String? _failure;
  String _key = newIdempotencyKey();
  bool _busy = false;
  bool _sending = false;
  String? _success;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _load({bool earlier = false}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final ticket = await widget.repository.ticket(widget.ticketId);
      final page = await widget.repository.entries(
        widget.ticketId,
        earlier ? _cursor : null,
      );
      if (mounted) {
        setState(() {
          _ticket = ticket;
          if (earlier) {
            _entries.insertAll(0, page.data);
          } else {
            _entries.clear();
            _entries.addAll(page.data);
          }
          _cursor = page.meta.nextCursor;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reply() async {
    if (_sending || !_form.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _failure = null;
      _success = null;
    });
    try {
      await widget.repository.reply(
        widget.ticketId,
        _message.text.trim(),
        _files,
        _key,
      );
      if (!mounted) return;
      setState(() {
        _message.clear();
        _files = [];
        _key = newIdempotencyKey();
        _success = 'Your reply was sent.';
      });
      await _load();
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _attachment(api.SupportAttachment file) async {
    try {
      final bytes = await widget.repository.attachment(
        widget.ticketId,
        file.id,
      );
      if (mounted) {
        await openCaseFile(context, bytes, file.originalName, file.contentType);
      }
    } catch (error) {
      if (mounted) setState(() => _failure = _error(error));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAccountBar(context, 'Support request'),
    body: RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (widget.createdTicketNumber != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Support request submitted. Ticket ${widget.createdTicketNumber}. Read responses and continue the conversation here.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_success != null)
            Semantics(liveRegion: true, child: Text(_success!)),
          OutlinedButton(
            onPressed: _busy || _sending ? null : _load,
            child: const Text('Refresh conversation'),
          ),
          if (_busy)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          if (_failure != null)
            StateMessage(
              kind: StateKind.error,
              title: 'Could not complete this action',
              message: _failure!,
            ),
          if (_ticket != null) ...[
            const SizedBox(height: 16),
            Text(
              _ticket!.ticketNumber,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              _ticket!.subject,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Status: ${supportLabel(_ticket!.status.name)}'),
            Text(supportLabel(_ticket!.category.name)),
            if (_ticket!.reference != null)
              Text(
                '${supportLabel(_ticket!.referenceType ?? 'Reference')}: ${_ticket!.reference}',
              ),
            const Divider(height: 32),
            if (_cursor != null)
              OutlinedButton(
                onPressed: _busy ? null : () => _load(earlier: true),
                child: const Text('Load earlier history'),
              ),
            for (final entry in _entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${entry.actorName} - ${supportLabel(entry.actorRole)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _date(entry.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (entry.kind != api.SupportEntryKindEnum.MESSAGE)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          entry.kind == api.SupportEntryKindEnum.STATUS_CHANGED
                              ? '${supportLabel(entry.details.fromStatus ?? '')} to ${supportLabel(entry.details.toStatus ?? '')}'
                              : '${entry.details.previousHandler ?? 'Unassigned'} to ${entry.details.newHandler ?? 'Unassigned'}',
                        ),
                      ),
                    const SizedBox(height: 8),
                    SelectableText(entry.body),
                    for (final file in entry.attachments)
                      TextButton.icon(
                        onPressed: () => _attachment(file),
                        icon: const Icon(Icons.attach_file),
                        label: Text(
                          file.originalName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            if (_ticket!.status == api.SupportStatus.CLOSED)
              const Text(
                'This request is closed. An administrator must reopen it before another reply. You can submit a new request if you need further assistance.',
              )
            else
              Form(
                key: _form,
                onChanged: () => _key = newIdempotencyKey(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _message,
                      enabled: !_sending,
                      minLines: 3,
                      maxLines: 8,
                      maxLength: 10000,
                      decoration: const InputDecoration(
                        labelText: 'Your follow-up message',
                      ),
                      validator: (value) => (value?.trim().length ?? 0) < 3
                          ? 'Enter at least 3 characters.'
                          : null,
                    ),
                    SupportAttachmentEditor(
                      files: _files,
                      enabled: !_sending,
                      onChanged: (files) => setState(() {
                        _files = files;
                        _key = newIdempotencyKey();
                      }),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _sending || _busy ? null : _reply,
                      child: Text(_sending ? 'Sending reply...' : 'Send reply'),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    ),
  );
}
