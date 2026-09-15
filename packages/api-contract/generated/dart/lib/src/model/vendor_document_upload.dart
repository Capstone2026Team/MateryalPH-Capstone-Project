//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_document_upload.g.dart';

/// VendorDocumentUpload
///
/// Properties:
/// * [id]
/// * [documentId]
/// * [version]
/// * [scanState]
/// * [environment]
@BuiltValue()
abstract class VendorDocumentUpload implements Built<VendorDocumentUpload, VendorDocumentUploadBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'document_id')
  String get documentId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'scan_state')
  String get scanState;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  VendorDocumentUpload._();

  factory VendorDocumentUpload([void updates(VendorDocumentUploadBuilder b)]) = _$VendorDocumentUpload;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDocumentUploadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDocumentUpload> get serializer => _$VendorDocumentUploadSerializer();
}

class _$VendorDocumentUploadSerializer implements PrimitiveSerializer<VendorDocumentUpload> {
  @override
  final Iterable<Type> types = const [VendorDocumentUpload, _$VendorDocumentUpload];

  @override
  final String wireName = r'VendorDocumentUpload';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDocumentUpload object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'document_id';
    yield serializers.serialize(
      object.documentId,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDocumentUpload object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDocumentUploadBuilder result,
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
        case r'document_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanState = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDocumentUpload deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDocumentUploadBuilder();
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


