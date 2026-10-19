import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

class ProjectInquiryList extends StatefulWidget {
  const ProjectInquiryList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRefresh,
    this.loadingMore = false,
    this.loadMoreError,
  });
  final List<api.ConversationView> items;
  final ValueChanged<String> onSelect;
  final bool hasMore;
  final bool loadingMore;
  final String? loadMoreError;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  @override
  State<ProjectInquiryList> createState() => _ProjectInquiryListState();
}

class _ProjectInquiryListState extends State<ProjectInquiryList> {
  final _scroll = ScrollController();
  bool _loadScheduled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_loadNearEnd);
    _scheduleLoad();
  }

  @override
  void didUpdateWidget(covariant ProjectInquiryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleLoad();
  }

  void _scheduleLoad() {
    if (_loadScheduled) return;
    _loadScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScheduled = false;
      if (mounted) _loadNearEnd();
    });
  }

  void _loadNearEnd() {
    if (_scroll.hasClients &&
        _scroll.position.hasContentDimensions &&
        _scroll.position.extentAfter < 400 &&
        widget.hasMore &&
        !widget.loadingMore &&
        widget.loadMoreError == null) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: widget.onRefresh,
    child: NotificationListener<ScrollMetricsNotification>(
      onNotification: (_) {
        _scheduleLoad();
        return false;
      },
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: widget.items.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Open quotation inquiries for current Work Packages. Each inquiry keeps its own conversation and quotation history.',
              ),
            );
          }
          if (index == widget.items.length + 1) {
            return Column(
              children: [
                if (widget.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No open project quotation inquiries. Start one from a Work Package’s Vendor comparison.',
                    ),
                  ),
                if (widget.loadingMore)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Loading more project inquiries',
                    ),
                  ),
                if (widget.loadMoreError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Text(widget.loadMoreError!),
                        TextButton(
                          onPressed: widget.onLoadMore,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
          final row = widget.items[index - 1];
          return Column(
            key: ValueKey(row.id),
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                title: Text(row.inquiryLabel ?? 'Project inquiry'),
                subtitle: Text(
                  row.lastMessagePreview?.isNotEmpty == true
                      ? row.lastMessagePreview!
                      : 'Open project conversation',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: row.unreadCount > 0
                    ? Badge(
                        label: Text('${row.unreadCount}'),
                        child: const Icon(Icons.chevron_right),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () => widget.onSelect(row.id),
              ),
              const Divider(height: 1),
            ],
          );
        },
      ),
    ),
  );
}
