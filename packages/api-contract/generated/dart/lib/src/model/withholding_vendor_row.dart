//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/withholding_calculation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_vendor_row.g.dart';

/// WithholdingVendorRow
///
/// Properties:
/// * [vendorId]
/// * [vendorName]
/// * [withholdingEntity]
/// * [assessmentCount]
/// * [withheldCentavos]
/// * [reviewRequired]
/// * [calculation]
/// * [filingIssues] - Specific source conditions behind review_required. These do not prevent reading the calculation; existing filing-package safeguards remain enforced separately.
@BuiltValue()
abstract class WithholdingVendorRow implements Built<WithholdingVendorRow, WithholdingVendorRowBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'vendor_name')
  String get vendorName;

  @BuiltValueField(wireName: r'withholding_entity')
  String get withholdingEntity;

  @BuiltValueField(wireName: r'assessment_count')
  int get assessmentCount;

  @BuiltValueField(wireName: r'withheld_centavos')
  int get withheldCentavos;

  @BuiltValueField(wireName: r'review_required')
  int get reviewRequired;

  @BuiltValueField(wireName: r'calculation')
  WithholdingCalculation get calculation;

  /// Specific source conditions behind review_required. These do not prevent reading the calculation; existing filing-package safeguards remain enforced separately.
  @BuiltValueField(wireName: r'filing_issues')
  BuiltSet<WithholdingVendorRowFilingIssuesEnum> get filingIssues;
  // enum filingIssuesEnum {  CALCULATION_INCOMPLETE,  RECONCILIATION_EXCEPTION,  TAX_PROFILE_MISSING,  REPORTING_CODE_MISSING,  TAX_ADJUSTMENT_OPEN,  };

  WithholdingVendorRow._();

  factory WithholdingVendorRow([void updates(WithholdingVendorRowBuilder b)]) = _$WithholdingVendorRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingVendorRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingVendorRow> get serializer => _$WithholdingVendorRowSerializer();
}

class _$WithholdingVendorRowSerializer implements PrimitiveSerializer<WithholdingVendorRow> {
  @override
  final Iterable<Type> types = const [WithholdingVendorRow, _$WithholdingVendorRow];

  @override
  final String wireName = r'WithholdingVendorRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingVendorRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'vendor_name';
    yield serializers.serialize(
      object.vendorName,
      specifiedType: const FullType(String),
    );
    yield r'withholding_entity';
    yield serializers.serialize(
      object.withholdingEntity,
      specifiedType: const FullType(String),
    );
    yield r'assessment_count';
    yield serializers.serialize(
      object.assessmentCount,
      specifiedType: const FullType(int),
    );
    yield r'withheld_centavos';
    yield serializers.serialize(
      object.withheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'review_required';
    yield serializers.serialize(
      object.reviewRequired,
      specifiedType: const FullType(int),
    );
    yield r'calculation';
    yield serializers.serialize(
      object.calculation,
      specifiedType: const FullType(WithholdingCalculation),
    );
    yield r'filing_issues';
    yield serializers.serialize(
      object.filingIssues,
      specifiedType: const FullType(BuiltSet, [FullType(WithholdingVendorRowFilingIssuesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingVendorRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingVendorRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorName = valueDes;
          break;
        case r'withholding_entity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.withholdingEntity = valueDes;
          break;
        case r'assessment_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessmentCount = valueDes;
          break;
        case r'withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withheldCentavos = valueDes;
          break;
        case r'review_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewRequired = valueDes;
          break;
        case r'calculation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingCalculation),
          ) as WithholdingCalculation;
          result.calculation.replace(valueDes);
          break;
        case r'filing_issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(WithholdingVendorRowFilingIssuesEnum)]),
          ) as BuiltSet<WithholdingVendorRowFilingIssuesEnum>;
          result.filingIssues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingVendorRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingVendorRowBuilder();
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


class WithholdingVendorRowFilingIssuesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CALCULATION_INCOMPLETE')
  static const WithholdingVendorRowFilingIssuesEnum CALCULATION_INCOMPLETE = _$withholdingVendorRowFilingIssuesEnum_CALCULATION_INCOMPLETE;
  @BuiltValueEnumConst(wireName: r'RECONCILIATION_EXCEPTION')
  static const WithholdingVendorRowFilingIssuesEnum RECONCILIATION_EXCEPTION = _$withholdingVendorRowFilingIssuesEnum_RECONCILIATION_EXCEPTION;
  @BuiltValueEnumConst(wireName: r'TAX_PROFILE_MISSING')
  static const WithholdingVendorRowFilingIssuesEnum TAX_PROFILE_MISSING = _$withholdingVendorRowFilingIssuesEnum_TAX_PROFILE_MISSING;
  @BuiltValueEnumConst(wireName: r'REPORTING_CODE_MISSING')
  static const WithholdingVendorRowFilingIssuesEnum REPORTING_CODE_MISSING = _$withholdingVendorRowFilingIssuesEnum_REPORTING_CODE_MISSING;
  @BuiltValueEnumConst(wireName: r'TAX_ADJUSTMENT_OPEN')
  static const WithholdingVendorRowFilingIssuesEnum TAX_ADJUSTMENT_OPEN = _$withholdingVendorRowFilingIssuesEnum_TAX_ADJUSTMENT_OPEN;

  static Serializer<WithholdingVendorRowFilingIssuesEnum> get serializer => _$withholdingVendorRowFilingIssuesEnumSerializer;

  const WithholdingVendorRowFilingIssuesEnum._(String name): super(name);

  static BuiltSet<WithholdingVendorRowFilingIssuesEnum> get values => _$withholdingVendorRowFilingIssuesEnumValues;
  static WithholdingVendorRowFilingIssuesEnum valueOf(String name) => _$withholdingVendorRowFilingIssuesEnumValueOf(name);
}

