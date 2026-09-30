//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pickup_confirmation.g.dart';

/// PickupConfirmation
///
/// Properties:
/// * [readyDate] - Asia/Manila date from today onward.
@BuiltValue()
abstract class PickupConfirmation implements Built<PickupConfirmation, PickupConfirmationBuilder> {
  /// Asia/Manila date from today onward.
  @BuiltValueField(wireName: r'ready_date')
  Date get readyDate;

  PickupConfirmation._();

  factory PickupConfirmation([void updates(PickupConfirmationBuilder b)]) = _$PickupConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PickupConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PickupConfirmation> get serializer => _$PickupConfirmationSerializer();
}

class _$PickupConfirmationSerializer implements PrimitiveSerializer<PickupConfirmation> {
  @override
  final Iterable<Type> types = const [PickupConfirmation, _$PickupConfirmation];

  @override
  final String wireName = r'PickupConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PickupConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ready_date';
    yield serializers.serialize(
      object.readyDate,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PickupConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PickupConfirmationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ready_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.readyDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PickupConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PickupConfirmationBuilder();
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


