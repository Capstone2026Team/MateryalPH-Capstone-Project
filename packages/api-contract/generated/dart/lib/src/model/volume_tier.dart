//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'volume_tier.g.dart';

/// VolumeTier
///
/// Properties:
/// * [priceVersionId]
/// * [minimumQuantity]
/// * [amountCentavos]
@BuiltValue()
abstract class VolumeTier implements Built<VolumeTier, VolumeTierBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'minimum_quantity')
  String get minimumQuantity;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  VolumeTier._();

  factory VolumeTier([void updates(VolumeTierBuilder b)]) = _$VolumeTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VolumeTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VolumeTier> get serializer => _$VolumeTierSerializer();
}

class _$VolumeTierSerializer implements PrimitiveSerializer<VolumeTier> {
  @override
  final Iterable<Type> types = const [VolumeTier, _$VolumeTier];

  @override
  final String wireName = r'VolumeTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VolumeTier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'minimum_quantity';
    yield serializers.serialize(
      object.minimumQuantity,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VolumeTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VolumeTierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
          break;
        case r'minimum_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minimumQuantity = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VolumeTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VolumeTierBuilder();
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


