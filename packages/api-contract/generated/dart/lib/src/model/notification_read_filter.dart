//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_read_filter.g.dart';

/// NotificationReadFilter
///
/// Properties:
/// * [throughId] - Newest notification ID in the captured client inbox snapshot. Later arrivals remain unread.
/// * [category] - Exact notification category selected in the dynamic Type filter. Omit for All types. New categories are supported without a client enum change.
/// * [title] - Legacy exact display-title filter retained for older clients. New clients use category. When both filters are supplied, both must match.
@BuiltValue()
abstract class NotificationReadFilter implements Built<NotificationReadFilter, NotificationReadFilterBuilder> {
  /// Newest notification ID in the captured client inbox snapshot. Later arrivals remain unread.
  @BuiltValueField(wireName: r'through_id')
  String get throughId;

  /// Exact notification category selected in the dynamic Type filter. Omit for All types. New categories are supported without a client enum change.
  @BuiltValueField(wireName: r'category')
  String? get category;

  /// Legacy exact display-title filter retained for older clients. New clients use category. When both filters are supplied, both must match.
  @Deprecated('title has been deprecated')
  @BuiltValueField(wireName: r'title')
  String? get title;

  NotificationReadFilter._();

  factory NotificationReadFilter([void updates(NotificationReadFilterBuilder b)]) = _$NotificationReadFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationReadFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationReadFilter> get serializer => _$NotificationReadFilterSerializer();
}

class _$NotificationReadFilterSerializer implements PrimitiveSerializer<NotificationReadFilter> {
  @override
  final Iterable<Type> types = const [NotificationReadFilter, _$NotificationReadFilter];

  @override
  final String wireName = r'NotificationReadFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationReadFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'through_id';
    yield serializers.serialize(
      object.throughId,
      specifiedType: const FullType(String),
    );
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationReadFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationReadFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'through_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.throughId = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationReadFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationReadFilterBuilder();
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


