//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_listing.g.dart';

/// SiteInspectionListing
///
/// Properties:
/// * [id]
/// * [displayName]
@BuiltValue()
abstract class SiteInspectionListing implements Built<SiteInspectionListing, SiteInspectionListingBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  SiteInspectionListing._();

  factory SiteInspectionListing([void updates(SiteInspectionListingBuilder b)]) = _$SiteInspectionListing;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionListingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionListing> get serializer => _$SiteInspectionListingSerializer();
}

class _$SiteInspectionListingSerializer implements PrimitiveSerializer<SiteInspectionListing> {
  @override
  final Iterable<Type> types = const [SiteInspectionListing, _$SiteInspectionListing];

  @override
  final String wireName = r'SiteInspectionListing';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionListing object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionListing object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionListingBuilder result,
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionListing deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionListingBuilder();
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


