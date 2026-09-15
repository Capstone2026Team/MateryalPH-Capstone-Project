//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_store_media.g.dart';

/// VendorStoreMedia
///
/// Properties:
/// * [id]
/// * [kind]
/// * [altText]
/// * [reviewStatus]
/// * [scanState]
@BuiltValue()
abstract class VendorStoreMedia implements Built<VendorStoreMedia, VendorStoreMediaBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  VendorStoreMediaKindEnum get kind;
  // enum kindEnum {  LOGO,  BANNER,  PROMOTIONAL,  };

  @BuiltValueField(wireName: r'alt_text')
  String get altText;

  @BuiltValueField(wireName: r'review_status')
  String get reviewStatus;

  @BuiltValueField(wireName: r'scan_state')
  String get scanState;

  VendorStoreMedia._();

  factory VendorStoreMedia([void updates(VendorStoreMediaBuilder b)]) = _$VendorStoreMedia;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStoreMediaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStoreMedia> get serializer => _$VendorStoreMediaSerializer();
}

class _$VendorStoreMediaSerializer implements PrimitiveSerializer<VendorStoreMedia> {
  @override
  final Iterable<Type> types = const [VendorStoreMedia, _$VendorStoreMedia];

  @override
  final String wireName = r'VendorStoreMedia';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStoreMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(VendorStoreMediaKindEnum),
    );
    yield r'alt_text';
    yield serializers.serialize(
      object.altText,
      specifiedType: const FullType(String),
    );
    yield r'review_status';
    yield serializers.serialize(
      object.reviewStatus,
      specifiedType: const FullType(String),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStoreMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStoreMediaBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorStoreMediaKindEnum),
          ) as VendorStoreMediaKindEnum;
          result.kind = valueDes;
          break;
        case r'alt_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.altText = valueDes;
          break;
        case r'review_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewStatus = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStoreMedia deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStoreMediaBuilder();
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


class VendorStoreMediaKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOGO')
  static const VendorStoreMediaKindEnum LOGO = _$vendorStoreMediaKindEnum_LOGO;
  @BuiltValueEnumConst(wireName: r'BANNER')
  static const VendorStoreMediaKindEnum BANNER = _$vendorStoreMediaKindEnum_BANNER;
  @BuiltValueEnumConst(wireName: r'PROMOTIONAL')
  static const VendorStoreMediaKindEnum PROMOTIONAL = _$vendorStoreMediaKindEnum_PROMOTIONAL;

  static Serializer<VendorStoreMediaKindEnum> get serializer => _$vendorStoreMediaKindEnumSerializer;

  const VendorStoreMediaKindEnum._(String name): super(name);

  static BuiltSet<VendorStoreMediaKindEnum> get values => _$vendorStoreMediaKindEnumValues;
  static VendorStoreMediaKindEnum valueOf(String name) => _$vendorStoreMediaKindEnumValueOf(name);
}

