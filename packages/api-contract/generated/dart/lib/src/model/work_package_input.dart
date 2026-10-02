//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/work_package_line_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_input.g.dart';

/// WorkPackageInput
///
/// Properties:
/// * [lockVersion]
/// * [name]
/// * [description]
/// * [budgetCentavos]
/// * [siteId]
/// * [radiusKm]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [siteContact]
/// * [heavyVehicleRestriction]
/// * [alternateDropOffLocationId]
/// * [accessInstructions]
/// * [lines]
@BuiltValue()
abstract class WorkPackageInput implements Built<WorkPackageInput, WorkPackageInputBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'site_id')
  String get siteId;

  @BuiltValueField(wireName: r'radius_km')
  WorkPackageInputRadiusKmEnum get radiusKm;
  // enum radiusKmEnum {  5,  10,  20,  30,  40,  50,  };

  @BuiltValueField(wireName: r'fulfillment_method')
  WorkPackageInputFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  @BuiltValueField(wireName: r'payment_method')
  WorkPackageInputPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  };

  @BuiltValueField(wireName: r'site_contact')
  String? get siteContact;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  WorkPackageInputHeavyVehicleRestrictionEnum? get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  YES,  NO,  };

  @BuiltValueField(wireName: r'alternate_drop_off_location_id')
  String? get alternateDropOffLocationId;

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  @BuiltValueField(wireName: r'lines')
  BuiltList<WorkPackageLineInput> get lines;

  WorkPackageInput._();

  factory WorkPackageInput([void updates(WorkPackageInputBuilder b)]) = _$WorkPackageInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageInput> get serializer => _$WorkPackageInputSerializer();
}

class _$WorkPackageInputSerializer implements PrimitiveSerializer<WorkPackageInput> {
  @override
  final Iterable<Type> types = const [WorkPackageInput, _$WorkPackageInput];

  @override
  final String wireName = r'WorkPackageInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'site_id';
    yield serializers.serialize(
      object.siteId,
      specifiedType: const FullType(String),
    );
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(WorkPackageInputRadiusKmEnum),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(WorkPackageInputFulfillmentMethodEnum),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(WorkPackageInputPaymentMethodEnum),
    );
    if (object.siteContact != null) {
      yield r'site_contact';
      yield serializers.serialize(
        object.siteContact,
        specifiedType: const FullType(String),
      );
    }
    if (object.heavyVehicleRestriction != null) {
      yield r'heavy_vehicle_restriction';
      yield serializers.serialize(
        object.heavyVehicleRestriction,
        specifiedType: const FullType(WorkPackageInputHeavyVehicleRestrictionEnum),
      );
    }
    if (object.alternateDropOffLocationId != null) {
      yield r'alternate_drop_off_location_id';
      yield serializers.serialize(
        object.alternateDropOffLocationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType(String),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageLineInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lockVersion = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.budgetCentavos = valueDes;
          break;
        case r'site_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.siteId = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageInputRadiusKmEnum),
          ) as WorkPackageInputRadiusKmEnum;
          result.radiusKm = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageInputFulfillmentMethodEnum),
          ) as WorkPackageInputFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageInputPaymentMethodEnum),
          ) as WorkPackageInputPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'site_contact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.siteContact = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkPackageInputHeavyVehicleRestrictionEnum),
          ) as WorkPackageInputHeavyVehicleRestrictionEnum?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off_location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateDropOffLocationId = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageLineInput)]),
          ) as BuiltList<WorkPackageLineInput>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageInputBuilder();
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


class WorkPackageInputRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 5)
  static const WorkPackageInputRadiusKmEnum number5 = _$workPackageInputRadiusKmEnum_number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const WorkPackageInputRadiusKmEnum number10 = _$workPackageInputRadiusKmEnum_number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const WorkPackageInputRadiusKmEnum number20 = _$workPackageInputRadiusKmEnum_number20;
  @BuiltValueEnumConst(wireNumber: 30)
  static const WorkPackageInputRadiusKmEnum number30 = _$workPackageInputRadiusKmEnum_number30;
  @BuiltValueEnumConst(wireNumber: 40)
  static const WorkPackageInputRadiusKmEnum number40 = _$workPackageInputRadiusKmEnum_number40;
  @BuiltValueEnumConst(wireNumber: 50)
  static const WorkPackageInputRadiusKmEnum number50 = _$workPackageInputRadiusKmEnum_number50;

  static Serializer<WorkPackageInputRadiusKmEnum> get serializer => _$workPackageInputRadiusKmEnumSerializer;

  const WorkPackageInputRadiusKmEnum._(String name): super(name);

  static BuiltSet<WorkPackageInputRadiusKmEnum> get values => _$workPackageInputRadiusKmEnumValues;
  static WorkPackageInputRadiusKmEnum valueOf(String name) => _$workPackageInputRadiusKmEnumValueOf(name);
}

class WorkPackageInputFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const WorkPackageInputFulfillmentMethodEnum PICKUP = _$workPackageInputFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const WorkPackageInputFulfillmentMethodEnum DELIVERY = _$workPackageInputFulfillmentMethodEnum_DELIVERY;

  static Serializer<WorkPackageInputFulfillmentMethodEnum> get serializer => _$workPackageInputFulfillmentMethodEnumSerializer;

  const WorkPackageInputFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<WorkPackageInputFulfillmentMethodEnum> get values => _$workPackageInputFulfillmentMethodEnumValues;
  static WorkPackageInputFulfillmentMethodEnum valueOf(String name) => _$workPackageInputFulfillmentMethodEnumValueOf(name);
}

class WorkPackageInputPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const WorkPackageInputPaymentMethodEnum ONLINE = _$workPackageInputPaymentMethodEnum_ONLINE;

  static Serializer<WorkPackageInputPaymentMethodEnum> get serializer => _$workPackageInputPaymentMethodEnumSerializer;

  const WorkPackageInputPaymentMethodEnum._(String name): super(name);

  static BuiltSet<WorkPackageInputPaymentMethodEnum> get values => _$workPackageInputPaymentMethodEnumValues;
  static WorkPackageInputPaymentMethodEnum valueOf(String name) => _$workPackageInputPaymentMethodEnumValueOf(name);
}

class WorkPackageInputHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'YES')
  static const WorkPackageInputHeavyVehicleRestrictionEnum YES = _$workPackageInputHeavyVehicleRestrictionEnum_YES;
  @BuiltValueEnumConst(wireName: r'NO')
  static const WorkPackageInputHeavyVehicleRestrictionEnum NO = _$workPackageInputHeavyVehicleRestrictionEnum_NO;

  static Serializer<WorkPackageInputHeavyVehicleRestrictionEnum> get serializer => _$workPackageInputHeavyVehicleRestrictionEnumSerializer;

  const WorkPackageInputHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<WorkPackageInputHeavyVehicleRestrictionEnum> get values => _$workPackageInputHeavyVehicleRestrictionEnumValues;
  static WorkPackageInputHeavyVehicleRestrictionEnum valueOf(String name) => _$workPackageInputHeavyVehicleRestrictionEnumValueOf(name);
}

