//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_commercial_version.g.dart';

/// OrderCommercialVersion
///
/// Properties:
/// * [current]
/// * [accepted]
/// * [kind]
/// * [contentHash]
/// * [recordedAt]
@BuiltValue()
abstract class OrderCommercialVersion implements Built<OrderCommercialVersion, OrderCommercialVersionBuilder> {
  @BuiltValueField(wireName: r'current')
  int get current;

  @BuiltValueField(wireName: r'accepted')
  int? get accepted;

  @BuiltValueField(wireName: r'kind')
  OrderCommercialVersionKindEnum? get kind;
  // enum kindEnum {  SUBMITTED,  VENDOR_CONFIRMED,  AUTO_ACCEPTED,  ,  };

  @BuiltValueField(wireName: r'content_hash')
  String? get contentHash;

  @BuiltValueField(wireName: r'recorded_at')
  DateTime? get recordedAt;

  OrderCommercialVersion._();

  factory OrderCommercialVersion([void updates(OrderCommercialVersionBuilder b)]) = _$OrderCommercialVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderCommercialVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderCommercialVersion> get serializer => _$OrderCommercialVersionSerializer();
}

class _$OrderCommercialVersionSerializer implements PrimitiveSerializer<OrderCommercialVersion> {
  @override
  final Iterable<Type> types = const [OrderCommercialVersion, _$OrderCommercialVersion];

  @override
  final String wireName = r'OrderCommercialVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderCommercialVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(int),
    );
    yield r'accepted';
    yield object.accepted == null ? null : serializers.serialize(
      object.accepted,
      specifiedType: const FullType.nullable(int),
    );
    yield r'kind';
    yield object.kind == null ? null : serializers.serialize(
      object.kind,
      specifiedType: const FullType.nullable(OrderCommercialVersionKindEnum),
    );
    yield r'content_hash';
    yield object.contentHash == null ? null : serializers.serialize(
      object.contentHash,
      specifiedType: const FullType.nullable(String),
    );
    yield r'recorded_at';
    yield object.recordedAt == null ? null : serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderCommercialVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderCommercialVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.current = valueDes;
          break;
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.accepted = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderCommercialVersionKindEnum),
          ) as OrderCommercialVersionKindEnum?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contentHash = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderCommercialVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderCommercialVersionBuilder();
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


class OrderCommercialVersionKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const OrderCommercialVersionKindEnum SUBMITTED = _$orderCommercialVersionKindEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'VENDOR_CONFIRMED')
  static const OrderCommercialVersionKindEnum VENDOR_CONFIRMED = _$orderCommercialVersionKindEnum_VENDOR_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'AUTO_ACCEPTED')
  static const OrderCommercialVersionKindEnum AUTO_ACCEPTED = _$orderCommercialVersionKindEnum_AUTO_ACCEPTED;

  static Serializer<OrderCommercialVersionKindEnum> get serializer => _$orderCommercialVersionKindEnumSerializer;

  const OrderCommercialVersionKindEnum._(String name): super(name);

  static BuiltSet<OrderCommercialVersionKindEnum> get values => _$orderCommercialVersionKindEnumValues;
  static OrderCommercialVersionKindEnum valueOf(String name) => _$orderCommercialVersionKindEnumValueOf(name);
}

