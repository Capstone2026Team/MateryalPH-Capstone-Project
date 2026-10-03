import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

/// Read only after the conversation's current authorization succeeds.
final class ChatDrafts {
  static const _storage = FlutterSecureStorage();
  static final _writes = <String, Future<void>>{};
  static Future<Map<String, dynamic>?> read(String id) async {
    await _writes[id];
    final value = await _storage.read(key: 'chat-draft-$id');
    return value == null ? null : jsonDecode(value) as Map<String, dynamic>;
  }

  static Future<void> save(String id, String text, api.ChatProduct? product) {
    final previous = _writes[id] ?? Future<void>.value();
    final write = previous
        .catchError((Object _) {})
        .then((_) => _save(id, text, product));
    _writes[id] = write;
    return write.whenComplete(() {
      if (identical(_writes[id], write)) _writes.remove(id);
    });
  }

  static Future<void> _save(
    String id,
    String text,
    api.ChatProduct? product,
  ) async {
    if (text.isEmpty && product == null) {
      await _storage.delete(key: 'chat-draft-$id');
    } else {
      await _storage.write(
        key: 'chat-draft-$id',
        value: jsonEncode({
          'text': text,
          'product': product == null
              ? null
              : api.standardSerializers.serializeWith(
                  api.ChatProduct.serializer,
                  product,
                ),
        }),
      );
    }
  }
}
