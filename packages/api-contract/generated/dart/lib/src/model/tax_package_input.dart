//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_package_input.g.dart';

/// TaxPackageInput
///
/// Properties:
/// * [form]
/// * [periodStart]
/// * [withholdingEntity]
/// * [vendorOrganizationId]
@BuiltValue()
abstract class TaxPackageInput implements Built<TaxPackageInput, TaxPackageInputBuilder> {
  @BuiltValueField(wireName: r'form')
  TaxPackageInputFormEnum get form;
  // enum formEnum {  2307,  0619-E,  1601-EQ,  QAP,  1604-E,  ANNUAL_ALPHALIST,  };

  @BuiltValueField(wireName: r'period_start')
  String get periodStart;

  @BuiltValueField(wireName: r'withholding_entity')
  TaxPackageInputWithholdingEntityEnum get withholdingEntity;
  // enum withholdingEntityEnum {  DEMO_PLATFORM_WITHHOLDER,  DEMO_PROVIDER_WITHHOLDER,  };

  @BuiltValueField(wireName: r'vendor_organization_id')
  String? get vendorOrganizationId;

  TaxPackageInput._();

  factory TaxPackageInput([void updates(TaxPackageInputBuilder b)]) = _$TaxPackageInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxPackageInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxPackageInput> get serializer => _$TaxPackageInputSerializer();
}

class _$TaxPackageInputSerializer implements PrimitiveSerializer<TaxPackageInput> {
  @override
  final Iterable<Type> types = const [TaxPackageInput, _$TaxPackageInput];

  @override
  final String wireName = r'TaxPackageInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxPackageInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'form';
    yield serializers.serialize(
      object.form,
      specifiedType: const FullType(TaxPackageInputFormEnum),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(String),
    );
    yield r'withholding_entity';
    yield serializers.serialize(
      object.withholdingEntity,
      specifiedType: const FullType(TaxPackageInputWithholdingEntityEnum),
    );
    if (object.vendorOrganizationId != null) {
      yield r'vendor_organization_id';
      yield serializers.serialize(
        object.vendorOrganizationId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxPackageInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxPackageInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'form':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxPackageInputFormEnum),
          ) as TaxPackageInputFormEnum;
          result.form = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodStart = valueDes;
          break;
        case r'withholding_entity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxPackageInputWithholdingEntityEnum),
          ) as TaxPackageInputWithholdingEntityEnum;
          result.withholdingEntity = valueDes;
          break;
        case r'vendor_organization_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorOrganizationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxPackageInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxPackageInputBuilder();
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


class TaxPackageInputFormEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'2307')
  static const TaxPackageInputFormEnum n2307 = _$taxPackageInputFormEnum_n2307;
  @BuiltValueEnumConst(wireName: r'0619-E')
  static const TaxPackageInputFormEnum n0619e = _$taxPackageInputFormEnum_n0619e;
  @BuiltValueEnumConst(wireName: r'1601-EQ')
  static const TaxPackageInputFormEnum n1601eQ = _$taxPackageInputFormEnum_n1601eQ;
  @BuiltValueEnumConst(wireName: r'QAP')
  static const TaxPackageInputFormEnum QAP = _$taxPackageInputFormEnum_QAP;
  @BuiltValueEnumConst(wireName: r'1604-E')
  static const TaxPackageInputFormEnum n1604e = _$taxPackageInputFormEnum_n1604e;
  @BuiltValueEnumConst(wireName: r'ANNUAL_ALPHALIST')
  static const TaxPackageInputFormEnum ANNUAL_ALPHALIST = _$taxPackageInputFormEnum_ANNUAL_ALPHALIST;

  static Serializer<TaxPackageInputFormEnum> get serializer => _$taxPackageInputFormEnumSerializer;

  const TaxPackageInputFormEnum._(String name): super(name);

  static BuiltSet<TaxPackageInputFormEnum> get values => _$taxPackageInputFormEnumValues;
  static TaxPackageInputFormEnum valueOf(String name) => _$taxPackageInputFormEnumValueOf(name);
}

class TaxPackageInputWithholdingEntityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEMO_PLATFORM_WITHHOLDER')
  static const TaxPackageInputWithholdingEntityEnum DEMO_PLATFORM_WITHHOLDER = _$taxPackageInputWithholdingEntityEnum_DEMO_PLATFORM_WITHHOLDER;
  @BuiltValueEnumConst(wireName: r'DEMO_PROVIDER_WITHHOLDER')
  static const TaxPackageInputWithholdingEntityEnum DEMO_PROVIDER_WITHHOLDER = _$taxPackageInputWithholdingEntityEnum_DEMO_PROVIDER_WITHHOLDER;

  static Serializer<TaxPackageInputWithholdingEntityEnum> get serializer => _$taxPackageInputWithholdingEntityEnumSerializer;

  const TaxPackageInputWithholdingEntityEnum._(String name): super(name);

  static BuiltSet<TaxPackageInputWithholdingEntityEnum> get values => _$taxPackageInputWithholdingEntityEnumValues;
  static TaxPackageInputWithholdingEntityEnum valueOf(String name) => _$taxPackageInputWithholdingEntityEnumValueOf(name);
}

