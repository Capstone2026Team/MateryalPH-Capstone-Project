//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_operating_day.dart';
import 'package:materyalph_api_client/src/model/vendor_store.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_vehicle.dart';
import 'package:materyalph_api_client/src/model/vendor_connection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_setup.g.dart';

/// VendorSetup
///
/// Properties:
/// * [lockVersion]
/// * [bulkOrderCapable]
/// * [store]
/// * [hours]
/// * [deliveryVehicles]
/// * [payment]
/// * [withholdingDemoScenario]
/// * [productionWithholdingAssignment]
/// * [environment]
@BuiltValue()
abstract class VendorSetup implements Built<VendorSetup, VendorSetupBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'bulk_order_capable')
  bool get bulkOrderCapable;

  @BuiltValueField(wireName: r'store')
  VendorStore? get store;

  @BuiltValueField(wireName: r'hours')
  BuiltList<VendorOperatingDay> get hours;

  @BuiltValueField(wireName: r'delivery_vehicles')
  BuiltList<VendorVehicle> get deliveryVehicles;

  @BuiltValueField(wireName: r'payment')
  VendorConnection? get payment;

  @BuiltValueField(wireName: r'withholding_demo_scenario')
  String? get withholdingDemoScenario;

  @BuiltValueField(wireName: r'production_withholding_assignment')
  String get productionWithholdingAssignment;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  VendorSetup._();

  factory VendorSetup([void updates(VendorSetupBuilder b)]) = _$VendorSetup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorSetupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorSetup> get serializer => _$VendorSetupSerializer();
}

class _$VendorSetupSerializer implements PrimitiveSerializer<VendorSetup> {
  @override
  final Iterable<Type> types = const [VendorSetup, _$VendorSetup];

  @override
  final String wireName = r'VendorSetup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorSetup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'bulk_order_capable';
    yield serializers.serialize(
      object.bulkOrderCapable,
      specifiedType: const FullType(bool),
    );
    yield r'store';
    yield object.store == null ? null : serializers.serialize(
      object.store,
      specifiedType: const FullType.nullable(VendorStore),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [FullType(VendorOperatingDay)]),
    );
    yield r'delivery_vehicles';
    yield serializers.serialize(
      object.deliveryVehicles,
      specifiedType: const FullType(BuiltList, [FullType(VendorVehicle)]),
    );
    yield r'payment';
    yield object.payment == null ? null : serializers.serialize(
      object.payment,
      specifiedType: const FullType.nullable(VendorConnection),
    );
    yield r'withholding_demo_scenario';
    yield object.withholdingDemoScenario == null ? null : serializers.serialize(
      object.withholdingDemoScenario,
      specifiedType: const FullType.nullable(String),
    );
    yield r'production_withholding_assignment';
    yield serializers.serialize(
      object.productionWithholdingAssignment,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorSetup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorSetupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'bulk_order_capable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bulkOrderCapable = valueDes;
          break;
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorStore),
          ) as VendorStore?;
          if (valueDes == null) continue;
          result.store.replace(valueDes);
          break;
        case r'hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOperatingDay)]),
          ) as BuiltList<VendorOperatingDay>;
          result.hours.replace(valueDes);
          break;
        case r'delivery_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorVehicle)]),
          ) as BuiltList<VendorVehicle>;
          result.deliveryVehicles.replace(valueDes);
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorConnection),
          ) as VendorConnection?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        case r'withholding_demo_scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.withholdingDemoScenario = valueDes;
          break;
        case r'production_withholding_assignment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productionWithholdingAssignment = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorSetup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorSetupBuilder();
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


