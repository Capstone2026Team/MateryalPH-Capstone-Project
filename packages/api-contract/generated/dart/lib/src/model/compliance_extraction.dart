//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_extraction.g.dart';

/// ComplianceExtraction
///
/// Properties:
/// * [source_]
/// * [status]
/// * [confidence]
/// * [suggestions]
/// * [assistanceOnly]
@BuiltValue()
abstract class ComplianceExtraction implements Built<ComplianceExtraction, ComplianceExtractionBuilder> {
  @BuiltValueField(wireName: r'source')
  ComplianceExtractionSource_Enum? get source_;
  // enum source_Enum {  OCR,  QR,  ,  };

  @BuiltValueField(wireName: r'status')
  ComplianceExtractionStatusEnum get status;
  // enum statusEnum {  EXTRACTED,  UNAVAILABLE,  FAILED,  NOT_REQUESTED,  };

  @BuiltValueField(wireName: r'confidence')
  num? get confidence;

  @BuiltValueField(wireName: r'suggestions')
  BuiltMap<String, String> get suggestions;

  @BuiltValueField(wireName: r'assistance_only')
  bool? get assistanceOnly;

  ComplianceExtraction._();

  factory ComplianceExtraction([void updates(ComplianceExtractionBuilder b)]) = _$ComplianceExtraction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceExtractionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceExtraction> get serializer => _$ComplianceExtractionSerializer();
}

class _$ComplianceExtractionSerializer implements PrimitiveSerializer<ComplianceExtraction> {
  @override
  final Iterable<Type> types = const [ComplianceExtraction, _$ComplianceExtraction];

  @override
  final String wireName = r'ComplianceExtraction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceExtraction object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType.nullable(ComplianceExtractionSource_Enum),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ComplianceExtractionStatusEnum),
    );
    if (object.confidence != null) {
      yield r'confidence';
      yield serializers.serialize(
        object.confidence,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'suggestions';
    yield serializers.serialize(
      object.suggestions,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.assistanceOnly != null) {
      yield r'assistance_only';
      yield serializers.serialize(
        object.assistanceOnly,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceExtraction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceExtractionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComplianceExtractionSource_Enum),
          ) as ComplianceExtractionSource_Enum?;
          if (valueDes == null) continue;
          result.source_ = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceExtractionStatusEnum),
          ) as ComplianceExtractionStatusEnum;
          result.status = valueDes;
          break;
        case r'confidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.confidence = valueDes;
          break;
        case r'suggestions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.suggestions.replace(valueDes);
          break;
        case r'assistance_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.assistanceOnly = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceExtraction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceExtractionBuilder();
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


class ComplianceExtractionSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OCR')
  static const ComplianceExtractionSource_Enum OCR = _$complianceExtractionSourceEnum_OCR;
  @BuiltValueEnumConst(wireName: r'QR')
  static const ComplianceExtractionSource_Enum QR = _$complianceExtractionSourceEnum_QR;

  static Serializer<ComplianceExtractionSource_Enum> get serializer => _$complianceExtractionSourceEnumSerializer;

  const ComplianceExtractionSource_Enum._(String name): super(name);

  static BuiltSet<ComplianceExtractionSource_Enum> get values => _$complianceExtractionSourceEnumValues;
  static ComplianceExtractionSource_Enum valueOf(String name) => _$complianceExtractionSourceEnumValueOf(name);
}

class ComplianceExtractionStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXTRACTED')
  static const ComplianceExtractionStatusEnum EXTRACTED = _$complianceExtractionStatusEnum_EXTRACTED;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const ComplianceExtractionStatusEnum UNAVAILABLE = _$complianceExtractionStatusEnum_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const ComplianceExtractionStatusEnum FAILED = _$complianceExtractionStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'NOT_REQUESTED')
  static const ComplianceExtractionStatusEnum NOT_REQUESTED = _$complianceExtractionStatusEnum_NOT_REQUESTED;

  static Serializer<ComplianceExtractionStatusEnum> get serializer => _$complianceExtractionStatusEnumSerializer;

  const ComplianceExtractionStatusEnum._(String name): super(name);

  static BuiltSet<ComplianceExtractionStatusEnum> get values => _$complianceExtractionStatusEnumValues;
  static ComplianceExtractionStatusEnum valueOf(String name) => _$complianceExtractionStatusEnumValueOf(name);
}

