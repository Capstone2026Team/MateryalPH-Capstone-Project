//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/withholding_vendor_row.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_register.g.dart';

/// WithholdingRegister
///
/// Properties:
/// * [month]
/// * [periodStart]
/// * [periodEnd]
/// * [environment]
/// * [assignmentStatus]
/// * [platformWithheldCentavos]
/// * [providerWithheldCentavos]
/// * [vendorCount]
/// * [assessmentCount]
/// * [reviewRequired]
/// * [vendors]
@BuiltValue()
abstract class WithholdingRegister implements Built<WithholdingRegister, WithholdingRegisterBuilder> {
  @BuiltValueField(wireName: r'month')
  String get month;

  @BuiltValueField(wireName: r'period_start')
  String get periodStart;

  @BuiltValueField(wireName: r'period_end')
  String get periodEnd;

  @BuiltValueField(wireName: r'environment')
  WithholdingRegisterEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'assignment_status')
  WithholdingRegisterAssignmentStatusEnum get assignmentStatus;
  // enum assignmentStatusEnum {  UNCONFIRMED,  };

  @BuiltValueField(wireName: r'platform_withheld_centavos')
  int get platformWithheldCentavos;

  @BuiltValueField(wireName: r'provider_withheld_centavos')
  int get providerWithheldCentavos;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'assessment_count')
  int get assessmentCount;

  @BuiltValueField(wireName: r'review_required')
  int get reviewRequired;

  @BuiltValueField(wireName: r'vendors')
  BuiltList<WithholdingVendorRow> get vendors;

  WithholdingRegister._();

  factory WithholdingRegister([void updates(WithholdingRegisterBuilder b)]) = _$WithholdingRegister;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingRegisterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingRegister> get serializer => _$WithholdingRegisterSerializer();
}

class _$WithholdingRegisterSerializer implements PrimitiveSerializer<WithholdingRegister> {
  @override
  final Iterable<Type> types = const [WithholdingRegister, _$WithholdingRegister];

  @override
  final String wireName = r'WithholdingRegister';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(String),
    );
    yield r'period_end';
    yield serializers.serialize(
      object.periodEnd,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(WithholdingRegisterEnvironmentEnum),
    );
    yield r'assignment_status';
    yield serializers.serialize(
      object.assignmentStatus,
      specifiedType: const FullType(WithholdingRegisterAssignmentStatusEnum),
    );
    yield r'platform_withheld_centavos';
    yield serializers.serialize(
      object.platformWithheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'provider_withheld_centavos';
    yield serializers.serialize(
      object.providerWithheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'assessment_count';
    yield serializers.serialize(
      object.assessmentCount,
      specifiedType: const FullType(int),
    );
    yield r'review_required';
    yield serializers.serialize(
      object.reviewRequired,
      specifiedType: const FullType(int),
    );
    yield r'vendors';
    yield serializers.serialize(
      object.vendors,
      specifiedType: const FullType(BuiltList, [FullType(WithholdingVendorRow)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingRegisterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.month = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodStart = valueDes;
          break;
        case r'period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodEnd = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingRegisterEnvironmentEnum),
          ) as WithholdingRegisterEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'assignment_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingRegisterAssignmentStatusEnum),
          ) as WithholdingRegisterAssignmentStatusEnum;
          result.assignmentStatus = valueDes;
          break;
        case r'platform_withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.platformWithheldCentavos = valueDes;
          break;
        case r'provider_withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.providerWithheldCentavos = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'assessment_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessmentCount = valueDes;
          break;
        case r'review_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewRequired = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WithholdingVendorRow)]),
          ) as BuiltList<WithholdingVendorRow>;
          result.vendors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingRegister deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingRegisterBuilder();
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


class WithholdingRegisterEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const WithholdingRegisterEnvironmentEnum TEST = _$withholdingRegisterEnvironmentEnum_TEST;

  static Serializer<WithholdingRegisterEnvironmentEnum> get serializer => _$withholdingRegisterEnvironmentEnumSerializer;

  const WithholdingRegisterEnvironmentEnum._(String name): super(name);

  static BuiltSet<WithholdingRegisterEnvironmentEnum> get values => _$withholdingRegisterEnvironmentEnumValues;
  static WithholdingRegisterEnvironmentEnum valueOf(String name) => _$withholdingRegisterEnvironmentEnumValueOf(name);
}

class WithholdingRegisterAssignmentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNCONFIRMED')
  static const WithholdingRegisterAssignmentStatusEnum UNCONFIRMED = _$withholdingRegisterAssignmentStatusEnum_UNCONFIRMED;

  static Serializer<WithholdingRegisterAssignmentStatusEnum> get serializer => _$withholdingRegisterAssignmentStatusEnumSerializer;

  const WithholdingRegisterAssignmentStatusEnum._(String name): super(name);

  static BuiltSet<WithholdingRegisterAssignmentStatusEnum> get values => _$withholdingRegisterAssignmentStatusEnumValues;
  static WithholdingRegisterAssignmentStatusEnum valueOf(String name) => _$withholdingRegisterAssignmentStatusEnumValueOf(name);
}

