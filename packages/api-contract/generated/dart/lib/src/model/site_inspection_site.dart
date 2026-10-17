//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_site.g.dart';

/// SiteInspectionSite
///
/// Properties:
/// * [locationId]
/// * [label]
/// * [kind]
/// * [formattedAddress]
@BuiltValue()
abstract class SiteInspectionSite implements Built<SiteInspectionSite, SiteInspectionSiteBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String get locationId;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  SiteInspectionSite._();

  factory SiteInspectionSite([void updates(SiteInspectionSiteBuilder b)]) = _$SiteInspectionSite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionSiteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionSite> get serializer => _$SiteInspectionSiteSerializer();
}

class _$SiteInspectionSiteSerializer implements PrimitiveSerializer<SiteInspectionSite> {
  @override
  final Iterable<Type> types = const [SiteInspectionSite, _$SiteInspectionSite];

  @override
  final String wireName = r'SiteInspectionSite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionSite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location_id';
    yield serializers.serialize(
      object.locationId,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionSite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionSiteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locationId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionSite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionSiteBuilder();
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


