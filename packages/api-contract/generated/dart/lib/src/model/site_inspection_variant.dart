//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_variant.g.dart';

/// SiteInspectionVariant
///
/// Properties:
/// * [id]
/// * [label]
@BuiltValue()
abstract class SiteInspectionVariant implements Built<SiteInspectionVariant, SiteInspectionVariantBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  SiteInspectionVariant._();

  factory SiteInspectionVariant([void updates(SiteInspectionVariantBuilder b)]) = _$SiteInspectionVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionVariant> get serializer => _$SiteInspectionVariantSerializer();
}

class _$SiteInspectionVariantSerializer implements PrimitiveSerializer<SiteInspectionVariant> {
  @override
  final Iterable<Type> types = const [SiteInspectionVariant, _$SiteInspectionVariant];

  @override
  final String wireName = r'SiteInspectionVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionVariantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionVariantBuilder();
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


