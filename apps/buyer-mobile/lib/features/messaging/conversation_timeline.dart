import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

/// Published terms retain their place in the conversation when their status changes.
class ConversationTimelineEntry {
  ConversationTimelineEntry.message(api.ChatMessage value)
    : message = value,
      quotation = null,
      timestamp = value.sentAt,
      id = 'message-${value.id}';

  ConversationTimelineEntry.quotation(api.ChatQuotationVersion value)
    : message = null,
      quotation = value,
      timestamp = value.publishedAt,
      id = 'quotation-${value.id}';

  final api.ChatMessage? message;
  final api.ChatQuotationVersion? quotation;
  final String timestamp;
  final String id;
}

List<ConversationTimelineEntry> conversationTimeline(
  Iterable<api.ChatMessage> messages,
  Iterable<api.ChatQuotationVersion> quotations,
) =>
    [
      ...messages.map(ConversationTimelineEntry.message),
      ...quotations.map(ConversationTimelineEntry.quotation),
    ]..sort((a, b) {
      final time = DateTime.parse(
        a.timestamp,
      ).compareTo(DateTime.parse(b.timestamp));
      return time != 0 ? time : a.id.compareTo(b.id);
    });
