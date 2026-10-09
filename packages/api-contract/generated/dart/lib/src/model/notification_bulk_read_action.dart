//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_bulk_read_action.g.dart';

/// NotificationBulkReadAction
///
/// Properties:
/// * [read]
/// * [readCount]
/// * [readAt] - Authoritative UTC RFC 3339 read timestamp for notices changed by this action.
@BuiltValue()
abstract class NotificationBulkReadAction implements Built<NotificationBulkReadAction, NotificationBulkReadActionBuilder> {
  @BuiltValueField(wireName: r'read')
  bool get read;

  @BuiltValueField(wireName: r'read_count')
  int get readCount;

  /// Authoritative UTC RFC 3339 read timestamp for notices changed by this action.
  @BuiltValueField(wireName: r'read_at')
  String get readAt;

  NotificationBulkReadAction._();

  factory NotificationBulkReadAction([void updates(NotificationBulkReadActionBuilder b)]) = _$NotificationBulkReadAction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationBulkReadActionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationBulkReadAction> get serializer => _$NotificationBulkReadActionSerializer();
}

class _$NotificationBulkReadActionSerializer implements PrimitiveSerializer<NotificationBulkReadAction> {
  @override
  final Iterable<Type> types = const [NotificationBulkReadAction, _$NotificationBulkReadAction];

  @override
  final String wireName = r'NotificationBulkReadAction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationBulkReadAction object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'read';
    yield serializers.serialize(
      object.read,
      specifiedType: const FullType(bool),
    );
    yield r'read_count';
    yield serializers.serialize(
      object.readCount,
      specifiedType: const FullType(int),
    );
    yield r'read_at';
    yield serializers.serialize(
      object.readAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationBulkReadAction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationBulkReadActionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'read':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.read = valueDes;
          break;
        case r'read_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.readCount = valueDes;
          break;
        case r'read_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationBulkReadAction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationBulkReadActionBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


