//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/compliance_reference_result.dart';
import 'package:materyalph_api_client/src/model/compliance_register_record.dart';
import 'package:materyalph_api_client/src/model/compliance_lookup_register.dart';
import 'package:materyalph_api_client/src/model/marking_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_lookup.g.dart';

/// ComplianceLookup
///
/// Properties:
/// * [markingType]
/// * [number]
/// * [result]
/// * [reason]
/// * [message]
/// * [canVerifyAutomatically]
/// * [register]
/// * [record]
@BuiltValue()
abstract class ComplianceLookup implements Built<ComplianceLookup, ComplianceLookupBuilder> {
  @BuiltValueField(wireName: r'marking_type')
  MarkingType get markingType;
  // enum markingTypeEnum {  PS_MARK,  ICC_STICKER,  };

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'result')
  ComplianceReferenceResult get result;
  // enum resultEnum {  MATCHED,  UNMATCHED,  UNCERTAIN,  UNAVAILABLE,  };

  @BuiltValueField(wireName: r'reason')
  ComplianceLookupReasonEnum? get reason;
  // enum reasonEnum {  NO_ACTIVE_REGISTER,  NUMBER_FORMAT,  CERTIFICATE_NUMBER_GIVEN,  NUMBER_NOT_FOUND,  PRODUCT_NOT_COVERED,  RECORD_EXPIRED,  ,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'can_verify_automatically')
  bool get canVerifyAutomatically;

  @BuiltValueField(wireName: r'register')
  ComplianceLookupRegister? get register;

  @BuiltValueField(wireName: r'record')
  ComplianceRegisterRecord? get record;

  ComplianceLookup._();

  factory ComplianceLookup([void updates(ComplianceLookupBuilder b)]) = _$ComplianceLookup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceLookupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceLookup> get serializer => _$ComplianceLookupSerializer();
}

class _$ComplianceLookupSerializer implements PrimitiveSerializer<ComplianceLookup> {
  @override
  final Iterable<Type> types = const [ComplianceLookup, _$ComplianceLookup];

  @override
  final String wireName = r'ComplianceLookup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceLookup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marking_type';
    yield serializers.serialize(
      object.markingType,
      specifiedType: const FullType(MarkingType),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(ComplianceReferenceResult),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(ComplianceLookupReasonEnum),
      );
    }
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'can_verify_automatically';
    yield serializers.serialize(
      object.canVerifyAutomatically,
      specifiedType: const FullType(bool),
    );
    if (object.register != null) {
      yield r'register';
      yield serializers.serialize(
        object.register,
        specifiedType: const FullType.nullable(ComplianceLookupRegister),
      );
    }
    if (object.record != null) {
      yield r'record';
      yield serializers.serialize(
        object.record,
        specifiedType: const FullType.nullable(ComplianceRegisterRecord),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceLookup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceLookupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MarkingType),
          ) as MarkingType;
          result.markingType = valueDes;
          break;
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.number = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceReferenceResult),
          ) as ComplianceReferenceResult;
          result.result = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComplianceLookupReasonEnum),
          ) as ComplianceLookupReasonEnum?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'can_verify_automatically':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canVerifyAutomatically = valueDes;
          break;
        case r'register':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComplianceLookupRegister),
          ) as ComplianceLookupRegister?;
          if (valueDes == null) continue;
          result.register.replace(valueDes);
          break;
        case r'record':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComplianceRegisterRecord),
          ) as ComplianceRegisterRecord?;
          if (valueDes == null) continue;
          result.record.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceLookup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceLookupBuilder();
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


class ComplianceLookupReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NO_ACTIVE_REGISTER')
  static const ComplianceLookupReasonEnum NO_ACTIVE_REGISTER = _$complianceLookupReasonEnum_NO_ACTIVE_REGISTER;
  @BuiltValueEnumConst(wireName: r'NUMBER_FORMAT')
  static const ComplianceLookupReasonEnum NUMBER_FORMAT = _$complianceLookupReasonEnum_NUMBER_FORMAT;
  @BuiltValueEnumConst(wireName: r'CERTIFICATE_NUMBER_GIVEN')
  static const ComplianceLookupReasonEnum CERTIFICATE_NUMBER_GIVEN = _$complianceLookupReasonEnum_CERTIFICATE_NUMBER_GIVEN;
  @BuiltValueEnumConst(wireName: r'NUMBER_NOT_FOUND')
  static const ComplianceLookupReasonEnum NUMBER_NOT_FOUND = _$complianceLookupReasonEnum_NUMBER_NOT_FOUND;
  @BuiltValueEnumConst(wireName: r'PRODUCT_NOT_COVERED')
  static const ComplianceLookupReasonEnum PRODUCT_NOT_COVERED = _$complianceLookupReasonEnum_PRODUCT_NOT_COVERED;
  @BuiltValueEnumConst(wireName: r'RECORD_EXPIRED')
  static const ComplianceLookupReasonEnum RECORD_EXPIRED = _$complianceLookupReasonEnum_RECORD_EXPIRED;

  static Serializer<ComplianceLookupReasonEnum> get serializer => _$complianceLookupReasonEnumSerializer;

  const ComplianceLookupReasonEnum._(String name): super(name);

  static BuiltSet<ComplianceLookupReasonEnum> get values => _$complianceLookupReasonEnumValues;
  static ComplianceLookupReasonEnum valueOf(String name) => _$complianceLookupReasonEnumValueOf(name);
}

