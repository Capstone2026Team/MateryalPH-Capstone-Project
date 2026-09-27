//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/compliance_path.dart';
import 'package:materyalph_api_client/src/model/compliance_extraction.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_evidence.g.dart';

/// ComplianceEvidence
///
/// Properties:
/// * [evidenceId]
/// * [fileId]
/// * [path]
/// * [evidenceKind]
/// * [contentType]
/// * [byteSize]
/// * [scanState]
/// * [extraction]
@BuiltValue()
abstract class ComplianceEvidence implements Built<ComplianceEvidence, ComplianceEvidenceBuilder> {
  @BuiltValueField(wireName: r'evidence_id')
  String get evidenceId;

  @BuiltValueField(wireName: r'file_id')
  String get fileId;

  @BuiltValueField(wireName: r'path')
  CompliancePath get path;
  // enum pathEnum {  PHOTO_OCR,  QR,  MANUAL,  };

  @BuiltValueField(wireName: r'evidence_kind')
  ComplianceEvidenceEvidenceKindEnum get evidenceKind;
  // enum evidenceKindEnum {  MARKING_PHOTO,  QR_IMAGE,  };

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'byte_size')
  int get byteSize;

  @BuiltValueField(wireName: r'scan_state')
  String get scanState;

  @BuiltValueField(wireName: r'extraction')
  ComplianceExtraction get extraction;

  ComplianceEvidence._();

  factory ComplianceEvidence([void updates(ComplianceEvidenceBuilder b)]) = _$ComplianceEvidence;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceEvidenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceEvidence> get serializer => _$ComplianceEvidenceSerializer();
}

class _$ComplianceEvidenceSerializer implements PrimitiveSerializer<ComplianceEvidence> {
  @override
  final Iterable<Type> types = const [ComplianceEvidence, _$ComplianceEvidence];

  @override
  final String wireName = r'ComplianceEvidence';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'evidence_id';
    yield serializers.serialize(
      object.evidenceId,
      specifiedType: const FullType(String),
    );
    yield r'file_id';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(CompliancePath),
    );
    yield r'evidence_kind';
    yield serializers.serialize(
      object.evidenceKind,
      specifiedType: const FullType(ComplianceEvidenceEvidenceKindEnum),
    );
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'byte_size';
    yield serializers.serialize(
      object.byteSize,
      specifiedType: const FullType(int),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(String),
    );
    yield r'extraction';
    yield serializers.serialize(
      object.extraction,
      specifiedType: const FullType(ComplianceExtraction),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceEvidenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'evidence_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evidenceId = valueDes;
          break;
        case r'file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompliancePath),
          ) as CompliancePath;
          result.path = valueDes;
          break;
        case r'evidence_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceEvidenceEvidenceKindEnum),
          ) as ComplianceEvidenceEvidenceKindEnum;
          result.evidenceKind = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'byte_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.byteSize = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanState = valueDes;
          break;
        case r'extraction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceExtraction),
          ) as ComplianceExtraction;
          result.extraction.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceEvidence deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceEvidenceBuilder();
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


class ComplianceEvidenceEvidenceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MARKING_PHOTO')
  static const ComplianceEvidenceEvidenceKindEnum MARKING_PHOTO = _$complianceEvidenceEvidenceKindEnum_MARKING_PHOTO;
  @BuiltValueEnumConst(wireName: r'QR_IMAGE')
  static const ComplianceEvidenceEvidenceKindEnum QR_IMAGE = _$complianceEvidenceEvidenceKindEnum_QR_IMAGE;

  static Serializer<ComplianceEvidenceEvidenceKindEnum> get serializer => _$complianceEvidenceEvidenceKindEnumSerializer;

  const ComplianceEvidenceEvidenceKindEnum._(String name): super(name);

  static BuiltSet<ComplianceEvidenceEvidenceKindEnum> get values => _$complianceEvidenceEvidenceKindEnumValues;
  static ComplianceEvidenceEvidenceKindEnum valueOf(String name) => _$complianceEvidenceEvidenceKindEnumValueOf(name);
}

