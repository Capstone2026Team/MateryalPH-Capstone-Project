//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_reason.g.dart';

/// AutoAcceptReason
///
/// Properties:
/// * [code]
/// * [listingVariantId]
@BuiltValue()
abstract class AutoAcceptReason implements Built<AutoAcceptReason, AutoAcceptReasonBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'listing_variant_id')
  String? get listingVariantId;

  AutoAcceptReason._();

  factory AutoAcceptReason([void updates(AutoAcceptReasonBuilder b)]) = _$AutoAcceptReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptReason> get serializer => _$AutoAcceptReasonSerializer();
}

class _$AutoAcceptReasonSerializer implements PrimitiveSerializer<AutoAcceptReason> {
  @override
  final Iterable<Type> types = const [AutoAcceptReason, _$AutoAcceptReason];

  @override
  final String wireName = r'AutoAcceptReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'listing_variant_id';
    yield object.listingVariantId == null ? null : serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptReason object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptReasonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingVariantId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptReasonBuilder();
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


