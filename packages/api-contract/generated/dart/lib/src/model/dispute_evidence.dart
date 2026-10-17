//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_evidence.g.dart';

/// DisputeEvidence
///
/// Properties:
/// * [fileId]
/// * [label]
/// * [description]
/// * [contentType]
/// * [name]
/// * [byteSize]
/// * [url]
/// * [expiresAt]
@BuiltValue()
abstract class DisputeEvidence implements Built<DisputeEvidence, DisputeEvidenceBuilder> {
  @BuiltValueField(wireName: r'file_id')
  String get fileId;

  @BuiltValueField(wireName: r'label')
  DisputeEvidenceLabelEnum get label;
  // enum labelEnum {  ORIGINAL,  SUPPLEMENTAL,  RESPONSE,  CLARIFICATION,  APPEAL,  FULFILLMENT,  REMEDY,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'byte_size')
  int get byteSize;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  DisputeEvidence._();

  factory DisputeEvidence([void updates(DisputeEvidenceBuilder b)]) = _$DisputeEvidence;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeEvidenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeEvidence> get serializer => _$DisputeEvidenceSerializer();
}

class _$DisputeEvidenceSerializer implements PrimitiveSerializer<DisputeEvidence> {
  @override
  final Iterable<Type> types = const [DisputeEvidence, _$DisputeEvidence];

  @override
  final String wireName = r'DisputeEvidence';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'file_id';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(DisputeEvidenceLabelEnum),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'byte_size';
    yield serializers.serialize(
      object.byteSize,
      specifiedType: const FullType(int),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeEvidenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeEvidenceLabelEnum),
          ) as DisputeEvidenceLabelEnum;
          result.label = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'byte_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.byteSize = valueDes;
          break;
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  DisputeEvidence deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeEvidenceBuilder();
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


class DisputeEvidenceLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORIGINAL')
  static const DisputeEvidenceLabelEnum ORIGINAL = _$disputeEvidenceLabelEnum_ORIGINAL;
  @BuiltValueEnumConst(wireName: r'SUPPLEMENTAL')
  static const DisputeEvidenceLabelEnum SUPPLEMENTAL = _$disputeEvidenceLabelEnum_SUPPLEMENTAL;
  @BuiltValueEnumConst(wireName: r'RESPONSE')
  static const DisputeEvidenceLabelEnum RESPONSE = _$disputeEvidenceLabelEnum_RESPONSE;
  @BuiltValueEnumConst(wireName: r'CLARIFICATION')
  static const DisputeEvidenceLabelEnum CLARIFICATION = _$disputeEvidenceLabelEnum_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'APPEAL')
  static const DisputeEvidenceLabelEnum APPEAL = _$disputeEvidenceLabelEnum_APPEAL;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const DisputeEvidenceLabelEnum FULFILLMENT = _$disputeEvidenceLabelEnum_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'REMEDY')
  static const DisputeEvidenceLabelEnum REMEDY = _$disputeEvidenceLabelEnum_REMEDY;

  static Serializer<DisputeEvidenceLabelEnum> get serializer => _$disputeEvidenceLabelEnumSerializer;

  const DisputeEvidenceLabelEnum._(String name): super(name);

  static BuiltSet<DisputeEvidenceLabelEnum> get values => _$disputeEvidenceLabelEnumValues;
  static DisputeEvidenceLabelEnum valueOf(String name) => _$disputeEvidenceLabelEnumValueOf(name);
}

