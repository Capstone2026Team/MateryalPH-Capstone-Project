//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_attribution.g.dart';

/// ProviderAttribution
///
/// Properties:
/// * [provider]
/// * [text]
@BuiltValue()
abstract class ProviderAttribution implements Built<ProviderAttribution, ProviderAttributionBuilder> {
  @BuiltValueField(wireName: r'provider')
  ProviderAttributionProviderEnum get provider;
  // enum providerEnum {  GOOGLE,  };

  @BuiltValueField(wireName: r'text')
  String get text;

  ProviderAttribution._();

  factory ProviderAttribution([void updates(ProviderAttributionBuilder b)]) = _$ProviderAttribution;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderAttributionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderAttribution> get serializer => _$ProviderAttributionSerializer();
}

class _$ProviderAttributionSerializer implements PrimitiveSerializer<ProviderAttribution> {
  @override
  final Iterable<Type> types = const [ProviderAttribution, _$ProviderAttribution];

  @override
  final String wireName = r'ProviderAttribution';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderAttribution object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ProviderAttributionProviderEnum),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProviderAttribution object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderAttributionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderAttributionProviderEnum),
          ) as ProviderAttributionProviderEnum;
          result.provider = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProviderAttribution deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderAttributionBuilder();
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


class ProviderAttributionProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GOOGLE')
  static const ProviderAttributionProviderEnum GOOGLE = _$providerAttributionProviderEnum_GOOGLE;

  static Serializer<ProviderAttributionProviderEnum> get serializer => _$providerAttributionProviderEnumSerializer;

  const ProviderAttributionProviderEnum._(String name): super(name);

  static BuiltSet<ProviderAttributionProviderEnum> get values => _$providerAttributionProviderEnumValues;
  static ProviderAttributionProviderEnum valueOf(String name) => _$providerAttributionProviderEnumValueOf(name);
}

