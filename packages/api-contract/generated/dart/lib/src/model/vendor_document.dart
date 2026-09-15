//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_document.g.dart';

/// VendorDocument
///
/// Properties:
/// * [reviewReason]
/// * [verifiedReference]
/// * [verifiedIssuedOn]
/// * [verifiedExpiresOn]
/// * [verifiedExpiryNotApplicable]
/// * [id]
/// * [documentType]
/// * [status]
/// * [version]
/// * [environment]
/// * [evidenceOrigin]
/// * [scanState]
/// * [createdAt]
@BuiltValue()
abstract class VendorDocument implements Built<VendorDocument, VendorDocumentBuilder> {
  @BuiltValueField(wireName: r'review_reason')
  String? get reviewReason;

  @BuiltValueField(wireName: r'verified_reference')
  String? get verifiedReference;

  @BuiltValueField(wireName: r'verified_issued_on')
  String? get verifiedIssuedOn;

  @BuiltValueField(wireName: r'verified_expires_on')
  String? get verifiedExpiresOn;

  @BuiltValueField(wireName: r'verified_expiry_not_applicable')
  bool get verifiedExpiryNotApplicable;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'document_type')
  String get documentType;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'evidence_origin')
  String get evidenceOrigin;

  @BuiltValueField(wireName: r'scan_state')
  String get scanState;

  @BuiltValueField(wireName: r'created_at')
  String get createdAt;

  VendorDocument._();

  factory VendorDocument([void updates(VendorDocumentBuilder b)]) = _$VendorDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDocument> get serializer => _$VendorDocumentSerializer();
}

class _$VendorDocumentSerializer implements PrimitiveSerializer<VendorDocument> {
  @override
  final Iterable<Type> types = const [VendorDocument, _$VendorDocument];

  @override
  final String wireName = r'VendorDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review_reason';
    yield object.reviewReason == null ? null : serializers.serialize(
      object.reviewReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verified_reference';
    yield object.verifiedReference == null ? null : serializers.serialize(
      object.verifiedReference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verified_issued_on';
    yield object.verifiedIssuedOn == null ? null : serializers.serialize(
      object.verifiedIssuedOn,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verified_expires_on';
    yield object.verifiedExpiresOn == null ? null : serializers.serialize(
      object.verifiedExpiresOn,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verified_expiry_not_applicable';
    yield serializers.serialize(
      object.verifiedExpiryNotApplicable,
      specifiedType: const FullType(bool),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'document_type';
    yield serializers.serialize(
      object.documentType,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'evidence_origin';
    yield serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType(String),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDocumentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewReason = valueDes;
          break;
        case r'verified_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedReference = valueDes;
          break;
        case r'verified_issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedIssuedOn = valueDes;
          break;
        case r'verified_expires_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedExpiresOn = valueDes;
          break;
        case r'verified_expiry_not_applicable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verifiedExpiryNotApplicable = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'document_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentType = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evidenceOrigin = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanState = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDocumentBuilder();
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


