import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/messaging_components.dart';
import 'messaging_repository.dart';

class ChatProductPicker extends StatefulWidget {
  const ChatProductPicker({
    super.key,
    required this.repository,
    required this.conversationId,
  });
  final MessagingRepository repository;
  final String conversationId;
  @override
  State<ChatProductPicker> createState() => _ChatProductPickerState();
}

class _ChatProductPickerState extends State<ChatProductPicker> {
  final _query = TextEditingController();
  api.ChatProductPage? _page;
  bool _loading = true;
  bool _failed = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _load([int page = 1]) async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final value = await widget.repository.products(
        widget.conversationId,
        query: _query.text.trim(),
        page: page,
      );
      if (mounted) setState(() => _page = value);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Attach product')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _query,
            onSubmitted: (_) => _load(),
            decoration: InputDecoration(
              labelText: 'Search this store',
              suffixIcon: IconButton(
                tooltip: 'Search products',
                onPressed: _loading ? null : () => _load(),
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _failed
              ? Center(
                  child: TextButton(
                    onPressed: () => _load(),
                    child: const Text('Unable to load products. Retry'),
                  ),
                )
              : ListView(
                  children: [
                    if (_page?.items.isEmpty != false)
                      const ListTile(title: Text('No available products')),
                    for (final product in _page?.items ?? <api.ChatProduct>[])
                      ChatProductCard(
                        product: product,
                        onOpen: () => Navigator.pop(context, product),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: (_page?.page ?? 1) > 1
                              ? () => _load(_page!.page - 1)
                              : null,
                          child: const Text('Previous'),
                        ),
                        TextButton(
                          onPressed: _page?.hasMore == true
                              ? () => _load(_page!.page + 1)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    ),
  );
}
