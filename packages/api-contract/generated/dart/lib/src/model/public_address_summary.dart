//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_address_summary.g.dart';

/// PublicAddressSummary
///
/// Properties:
/// * [formattedAddress]
/// * [cityMunicipality]
/// * [province]
@BuiltValue()
abstract class PublicAddressSummary implements Built<PublicAddressSummary, PublicAddressSummaryBuilder> {
  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  @BuiltValueField(wireName: r'city_municipality')
  String? get cityMunicipality;

  @BuiltValueField(wireName: r'province')
  String? get province;

  PublicAddressSummary._();

  factory PublicAddressSummary([void updates(PublicAddressSummaryBuilder b)]) = _$PublicAddressSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicAddressSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicAddressSummary> get serializer => _$PublicAddressSummarySerializer();
}

class _$PublicAddressSummarySerializer implements PrimitiveSerializer<PublicAddressSummary> {
  @override
  final Iterable<Type> types = const [PublicAddressSummary, _$PublicAddressSummary];

  @override
  final String wireName = r'PublicAddressSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicAddressSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'city_municipality';
    yield object.cityMunicipality == null ? null : serializers.serialize(
      object.cityMunicipality,
      specifiedType: const FullType.nullable(String),
    );
    yield r'province';
    yield object.province == null ? null : serializers.serialize(
      object.province,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicAddressSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicAddressSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        case r'city_municipality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityMunicipality = valueDes;
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.province = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicAddressSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicAddressSummaryBuilder();
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


