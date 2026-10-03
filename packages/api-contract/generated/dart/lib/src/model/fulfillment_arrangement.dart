//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fulfillment_arrangement_vehicle.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_arrangement.g.dart';

/// The accepted delivery commitment from the order snapshot. Later vehicle, rate or store-hour settings never change it.
///
/// Properties:
/// * [vehicles]
/// * [finalFeeCentavos]
/// * [endpoint]
/// * [fulfillmentDate]
/// * [arrangement]
/// * [notice]
@BuiltValue()
abstract class FulfillmentArrangement implements Built<FulfillmentArrangement, FulfillmentArrangementBuilder> {
  @BuiltValueField(wireName: r'vehicles')
  BuiltList<FulfillmentArrangementVehicle> get vehicles;

  @BuiltValueField(wireName: r'final_fee_centavos')
  int get finalFeeCentavos;

  @BuiltValueField(wireName: r'endpoint')
  String? get endpoint;

  @BuiltValueField(wireName: r'fulfillment_date')
  String? get fulfillmentDate;

  @BuiltValueField(wireName: r'arrangement')
  String? get arrangement;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  FulfillmentArrangement._();

  factory FulfillmentArrangement([void updates(FulfillmentArrangementBuilder b)]) = _$FulfillmentArrangement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentArrangementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentArrangement> get serializer => _$FulfillmentArrangementSerializer();
}

class _$FulfillmentArrangementSerializer implements PrimitiveSerializer<FulfillmentArrangement> {
  @override
  final Iterable<Type> types = const [FulfillmentArrangement, _$FulfillmentArrangement];

  @override
  final String wireName = r'FulfillmentArrangement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentArrangement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicles';
    yield serializers.serialize(
      object.vehicles,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentArrangementVehicle)]),
    );
    yield r'final_fee_centavos';
    yield serializers.serialize(
      object.finalFeeCentavos,
      specifiedType: const FullType(int),
    );
    if (object.endpoint != null) {
      yield r'endpoint';
      yield serializers.serialize(
        object.endpoint,
        specifiedType: const FullType(String),
      );
    }
    if (object.fulfillmentDate != null) {
      yield r'fulfillment_date';
      yield serializers.serialize(
        object.fulfillmentDate,
        specifiedType: const FullType(String),
      );
    }
    if (object.arrangement != null) {
      yield r'arrangement';
      yield serializers.serialize(
        object.arrangement,
        specifiedType: const FullType(String),
      );
    }
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentArrangement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentArrangementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentArrangementVehicle)]),
          ) as BuiltList<FulfillmentArrangementVehicle>;
          result.vehicles.replace(valueDes);
          break;
        case r'final_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.finalFeeCentavos = valueDes;
          break;
        case r'endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endpoint = valueDes;
          break;
        case r'fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fulfillmentDate = valueDes;
          break;
        case r'arrangement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.arrangement = valueDes;
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
  FulfillmentArrangement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentArrangementBuilder();
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


