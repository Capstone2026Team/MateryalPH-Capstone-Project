//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_adjustment_prepare_request.g.dart';

/// TaxAdjustmentPrepareRequest
///
/// Properties:
/// * [correctedWithheldCentavos]
/// * [reason]
/// * [certificateImpact]
/// * [evidenceReference]
@BuiltValue()
abstract class TaxAdjustmentPrepareRequest implements Built<TaxAdjustmentPrepareRequest, TaxAdjustmentPrepareRequestBuilder> {
  @BuiltValueField(wireName: r'corrected_withheld_centavos')
  int get correctedWithheldCentavos;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'certificate_impact')
  TaxAdjustmentPrepareRequestCertificateImpactEnum get certificateImpact;
  // enum certificateImpactEnum {  NONE,  REISSUE_REQUIRED,  AMENDMENT_REQUIRED,  };

  @BuiltValueField(wireName: r'evidence_reference')
  String? get evidenceReference;

  TaxAdjustmentPrepareRequest._();

  factory TaxAdjustmentPrepareRequest([void updates(TaxAdjustmentPrepareRequestBuilder b)]) = _$TaxAdjustmentPrepareRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxAdjustmentPrepareRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxAdjustmentPrepareRequest> get serializer => _$TaxAdjustmentPrepareRequestSerializer();
}

class _$TaxAdjustmentPrepareRequestSerializer implements PrimitiveSerializer<TaxAdjustmentPrepareRequest> {
  @override
  final Iterable<Type> types = const [TaxAdjustmentPrepareRequest, _$TaxAdjustmentPrepareRequest];

  @override
  final String wireName = r'TaxAdjustmentPrepareRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxAdjustmentPrepareRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'corrected_withheld_centavos';
    yield serializers.serialize(
      object.correctedWithheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'certificate_impact';
    yield serializers.serialize(
      object.certificateImpact,
      specifiedType: const FullType(TaxAdjustmentPrepareRequestCertificateImpactEnum),
    );
    if (object.evidenceReference != null) {
      yield r'evidence_reference';
      yield serializers.serialize(
        object.evidenceReference,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxAdjustmentPrepareRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxAdjustmentPrepareRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'corrected_withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.correctedWithheldCentavos = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'certificate_impact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxAdjustmentPrepareRequestCertificateImpactEnum),
          ) as TaxAdjustmentPrepareRequestCertificateImpactEnum;
          result.certificateImpact = valueDes;
          break;
        case r'evidence_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxAdjustmentPrepareRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxAdjustmentPrepareRequestBuilder();
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


class TaxAdjustmentPrepareRequestCertificateImpactEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const TaxAdjustmentPrepareRequestCertificateImpactEnum NONE = _$taxAdjustmentPrepareRequestCertificateImpactEnum_NONE;
  @BuiltValueEnumConst(wireName: r'REISSUE_REQUIRED')
  static const TaxAdjustmentPrepareRequestCertificateImpactEnum REISSUE_REQUIRED = _$taxAdjustmentPrepareRequestCertificateImpactEnum_REISSUE_REQUIRED;
  @BuiltValueEnumConst(wireName: r'AMENDMENT_REQUIRED')
  static const TaxAdjustmentPrepareRequestCertificateImpactEnum AMENDMENT_REQUIRED = _$taxAdjustmentPrepareRequestCertificateImpactEnum_AMENDMENT_REQUIRED;

  static Serializer<TaxAdjustmentPrepareRequestCertificateImpactEnum> get serializer => _$taxAdjustmentPrepareRequestCertificateImpactEnumSerializer;

  const TaxAdjustmentPrepareRequestCertificateImpactEnum._(String name): super(name);

  static BuiltSet<TaxAdjustmentPrepareRequestCertificateImpactEnum> get values => _$taxAdjustmentPrepareRequestCertificateImpactEnumValues;
  static TaxAdjustmentPrepareRequestCertificateImpactEnum valueOf(String name) => _$taxAdjustmentPrepareRequestCertificateImpactEnumValueOf(name);
}

