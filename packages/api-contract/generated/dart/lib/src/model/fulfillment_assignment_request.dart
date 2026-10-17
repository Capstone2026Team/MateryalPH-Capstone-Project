//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_assignment_request.g.dart';

/// FulfillmentAssignmentRequest
///
/// Properties:
/// * [userId]
/// * [reason]
/// * [vehicleIndex]
/// * [lockVersion]
/// * [dispatch] - Atomically assign and record Out for Delivery; requires vehicle_index and lock_version.
@BuiltValue()
abstract class FulfillmentAssignmentRequest implements Built<FulfillmentAssignmentRequest, FulfillmentAssignmentRequestBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'vehicle_index')
  int? get vehicleIndex;

  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  /// Atomically assign and record Out for Delivery; requires vehicle_index and lock_version.
  @BuiltValueField(wireName: r'dispatch')
  bool? get dispatch;

  FulfillmentAssignmentRequest._();

  factory FulfillmentAssignmentRequest([void updates(FulfillmentAssignmentRequestBuilder b)]) = _$FulfillmentAssignmentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentAssignmentRequestBuilder b) => b
      ..dispatch = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentAssignmentRequest> get serializer => _$FulfillmentAssignmentRequestSerializer();
}

class _$FulfillmentAssignmentRequestSerializer implements PrimitiveSerializer<FulfillmentAssignmentRequest> {
  @override
  final Iterable<Type> types = const [FulfillmentAssignmentRequest, _$FulfillmentAssignmentRequest];

  @override
  final String wireName = r'FulfillmentAssignmentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentAssignmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.vehicleIndex != null) {
      yield r'vehicle_index';
      yield serializers.serialize(
        object.vehicleIndex,
        specifiedType: const FullType(int),
      );
    }
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.dispatch != null) {
      yield r'dispatch';
      yield serializers.serialize(
        object.dispatch,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentAssignmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentAssignmentRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'vehicle_index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vehicleIndex = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lockVersion = valueDes;
          break;
        case r'dispatch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.dispatch = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentAssignmentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentAssignmentRequestBuilder();
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


