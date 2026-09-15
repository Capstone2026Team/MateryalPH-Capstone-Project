//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_download_link.g.dart';

/// VendorDownloadLink
///
/// Properties:
/// * [url]
/// * [expiresAt]
@BuiltValue()
abstract class VendorDownloadLink implements Built<VendorDownloadLink, VendorDownloadLinkBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  VendorDownloadLink._();

  factory VendorDownloadLink([void updates(VendorDownloadLinkBuilder b)]) = _$VendorDownloadLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDownloadLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDownloadLink> get serializer => _$VendorDownloadLinkSerializer();
}

class _$VendorDownloadLinkSerializer implements PrimitiveSerializer<VendorDownloadLink> {
  @override
  final Iterable<Type> types = const [VendorDownloadLink, _$VendorDownloadLink];

  @override
  final String wireName = r'VendorDownloadLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDownloadLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDownloadLink object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDownloadLinkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDownloadLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDownloadLinkBuilder();
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


