//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tax_profile_evidence_versions_inner.g.dart';

/// VendorTaxProfileEvidenceVersionsInner
///
/// Properties:
/// * [id]
/// * [version]
@BuiltValue()
abstract class VendorTaxProfileEvidenceVersionsInner implements Built<VendorTaxProfileEvidenceVersionsInner, VendorTaxProfileEvidenceVersionsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  VendorTaxProfileEvidenceVersionsInner._();

  factory VendorTaxProfileEvidenceVersionsInner([void updates(VendorTaxProfileEvidenceVersionsInnerBuilder b)]) = _$VendorTaxProfileEvidenceVersionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTaxProfileEvidenceVersionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTaxProfileEvidenceVersionsInner> get serializer => _$VendorTaxProfileEvidenceVersionsInnerSerializer();
}

class _$VendorTaxProfileEvidenceVersionsInnerSerializer implements PrimitiveSerializer<VendorTaxProfileEvidenceVersionsInner> {
  @override
  final Iterable<Type> types = const [VendorTaxProfileEvidenceVersionsInner, _$VendorTaxProfileEvidenceVersionsInner];

  @override
  final String wireName = r'VendorTaxProfileEvidenceVersionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTaxProfileEvidenceVersionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTaxProfileEvidenceVersionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTaxProfileEvidenceVersionsInnerBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTaxProfileEvidenceVersionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTaxProfileEvidenceVersionsInnerBuilder();
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


