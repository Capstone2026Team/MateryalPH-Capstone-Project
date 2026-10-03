//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_vehicle_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_confirmation.g.dart';

/// DeliveryConfirmation
///
/// Properties:
/// * [vehicles]
/// * [finalFeeCentavos] - Must equal the disclosed formula for the vehicles
/// * [fulfillmentDate]
/// * [arrangement]
/// * [accessConfirmed]
/// * [heavyVehicleAccessConfirmed]
/// * [manualReviewNote]
@BuiltValue()
abstract class DeliveryConfirmation implements Built<DeliveryConfirmation, DeliveryConfirmationBuilder> {
  @BuiltValueField(wireName: r'vehicles')
  BuiltList<DeliveryVehicleSelection> get vehicles;

  /// Must equal the disclosed formula for the vehicles
  @BuiltValueField(wireName: r'final_fee_centavos')
  int get finalFeeCentavos;

  @BuiltValueField(wireName: r'fulfillment_date')
  Date get fulfillmentDate;

  @BuiltValueField(wireName: r'arrangement')
  String get arrangement;

  @BuiltValueField(wireName: r'access_confirmed')
  bool get accessConfirmed;

  @BuiltValueField(wireName: r'heavy_vehicle_access_confirmed')
  bool? get heavyVehicleAccessConfirmed;

  @BuiltValueField(wireName: r'manual_review_note')
  String? get manualReviewNote;

  DeliveryConfirmation._();

  factory DeliveryConfirmation([void updates(DeliveryConfirmationBuilder b)]) = _$DeliveryConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryConfirmation> get serializer => _$DeliveryConfirmationSerializer();
}

class _$DeliveryConfirmationSerializer implements PrimitiveSerializer<DeliveryConfirmation> {
  @override
  final Iterable<Type> types = const [DeliveryConfirmation, _$DeliveryConfirmation];

  @override
  final String wireName = r'DeliveryConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicles';
    yield serializers.serialize(
      object.vehicles,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryVehicleSelection)]),
    );
    yield r'final_fee_centavos';
    yield serializers.serialize(
      object.finalFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fulfillment_date';
    yield serializers.serialize(
      object.fulfillmentDate,
      specifiedType: const FullType(Date),
    );
    yield r'arrangement';
    yield serializers.serialize(
      object.arrangement,
      specifiedType: const FullType(String),
    );
    yield r'access_confirmed';
    yield serializers.serialize(
      object.accessConfirmed,
      specifiedType: const FullType(bool),
    );
    if (object.heavyVehicleAccessConfirmed != null) {
      yield r'heavy_vehicle_access_confirmed';
      yield serializers.serialize(
        object.heavyVehicleAccessConfirmed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.manualReviewNote != null) {
      yield r'manual_review_note';
      yield serializers.serialize(
        object.manualReviewNote,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryConfirmationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryVehicleSelection)]),
          ) as BuiltList<DeliveryVehicleSelection>;
          result.vehicles.replace(valueDes);
          break;
        case r'final_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.finalFeeCentavos = valueDes;
          break;
        case r'fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.fulfillmentDate = valueDes;
          break;
        case r'arrangement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.arrangement = valueDes;
          break;
        case r'access_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accessConfirmed = valueDes;
          break;
        case r'heavy_vehicle_access_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.heavyVehicleAccessConfirmed = valueDes;
          break;
        case r'manual_review_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manualReviewNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryConfirmationBuilder();
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


