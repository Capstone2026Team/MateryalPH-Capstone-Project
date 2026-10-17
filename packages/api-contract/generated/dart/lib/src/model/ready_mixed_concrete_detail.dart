//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/ready_mixed_concrete_site_inspection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready_mixed_concrete_detail.g.dart';

/// Ready-Mixed Concrete (owner decision 2026-10-16). Quantity is the order volume in m³, each variant is one Required PSI class, and delivery is Site Delivery by Concrete Mixer Truck / Transit Mixer only.
///
/// Properties:
/// * [quantityLabel]
/// * [strengthAttribute] - Variant attribute code holding the PSI class.
/// * [strengthLabel]
/// * [deliveryVehicle]
/// * [siteDeliveryOnly]
/// * [siteInspection]
/// * [notice]
@BuiltValue()
abstract class ReadyMixedConcreteDetail implements Built<ReadyMixedConcreteDetail, ReadyMixedConcreteDetailBuilder> {
  @BuiltValueField(wireName: r'quantity_label')
  String get quantityLabel;

  /// Variant attribute code holding the PSI class.
  @BuiltValueField(wireName: r'strength_attribute')
  String get strengthAttribute;

  @BuiltValueField(wireName: r'strength_label')
  String get strengthLabel;

  @BuiltValueField(wireName: r'delivery_vehicle')
  ReadyMixedConcreteDetailDeliveryVehicleEnum get deliveryVehicle;
  // enum deliveryVehicleEnum {  CONCRETE_MIXER,  };

  @BuiltValueField(wireName: r'site_delivery_only')
  bool get siteDeliveryOnly;

  @BuiltValueField(wireName: r'site_inspection')
  ReadyMixedConcreteSiteInspection get siteInspection;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  ReadyMixedConcreteDetail._();

  factory ReadyMixedConcreteDetail([void updates(ReadyMixedConcreteDetailBuilder b)]) = _$ReadyMixedConcreteDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyMixedConcreteDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadyMixedConcreteDetail> get serializer => _$ReadyMixedConcreteDetailSerializer();
}

class _$ReadyMixedConcreteDetailSerializer implements PrimitiveSerializer<ReadyMixedConcreteDetail> {
  @override
  final Iterable<Type> types = const [ReadyMixedConcreteDetail, _$ReadyMixedConcreteDetail];

  @override
  final String wireName = r'ReadyMixedConcreteDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadyMixedConcreteDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quantity_label';
    yield serializers.serialize(
      object.quantityLabel,
      specifiedType: const FullType(String),
    );
    yield r'strength_attribute';
    yield serializers.serialize(
      object.strengthAttribute,
      specifiedType: const FullType(String),
    );
    yield r'strength_label';
    yield serializers.serialize(
      object.strengthLabel,
      specifiedType: const FullType(String),
    );
    yield r'delivery_vehicle';
    yield serializers.serialize(
      object.deliveryVehicle,
      specifiedType: const FullType(ReadyMixedConcreteDetailDeliveryVehicleEnum),
    );
    yield r'site_delivery_only';
    yield serializers.serialize(
      object.siteDeliveryOnly,
      specifiedType: const FullType(bool),
    );
    yield r'site_inspection';
    yield serializers.serialize(
      object.siteInspection,
      specifiedType: const FullType(ReadyMixedConcreteSiteInspection),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadyMixedConcreteDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyMixedConcreteDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quantity_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityLabel = valueDes;
          break;
        case r'strength_attribute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.strengthAttribute = valueDes;
          break;
        case r'strength_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.strengthLabel = valueDes;
          break;
        case r'delivery_vehicle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadyMixedConcreteDetailDeliveryVehicleEnum),
          ) as ReadyMixedConcreteDetailDeliveryVehicleEnum;
          result.deliveryVehicle = valueDes;
          break;
        case r'site_delivery_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.siteDeliveryOnly = valueDes;
          break;
        case r'site_inspection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadyMixedConcreteSiteInspection),
          ) as ReadyMixedConcreteSiteInspection;
          result.siteInspection.replace(valueDes);
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadyMixedConcreteDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyMixedConcreteDetailBuilder();
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


class ReadyMixedConcreteDetailDeliveryVehicleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONCRETE_MIXER')
  static const ReadyMixedConcreteDetailDeliveryVehicleEnum CONCRETE_MIXER = _$readyMixedConcreteDetailDeliveryVehicleEnum_CONCRETE_MIXER;

  static Serializer<ReadyMixedConcreteDetailDeliveryVehicleEnum> get serializer => _$readyMixedConcreteDetailDeliveryVehicleEnumSerializer;

  const ReadyMixedConcreteDetailDeliveryVehicleEnum._(String name): super(name);

  static BuiltSet<ReadyMixedConcreteDetailDeliveryVehicleEnum> get values => _$readyMixedConcreteDetailDeliveryVehicleEnumValues;
  static ReadyMixedConcreteDetailDeliveryVehicleEnum valueOf(String name) => _$readyMixedConcreteDetailDeliveryVehicleEnumValueOf(name);
}

