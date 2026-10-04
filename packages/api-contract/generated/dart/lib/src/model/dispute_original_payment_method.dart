//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_original_payment_method.g.dart';

/// Information only. No request anywhere accepts a different refund destination.
///
/// Properties:
/// * [label]
/// * [physical]
/// * [notice]
@BuiltValue()
abstract class DisputeOriginalPaymentMethod implements Built<DisputeOriginalPaymentMethod, DisputeOriginalPaymentMethodBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'physical')
  bool get physical;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  DisputeOriginalPaymentMethod._();

  factory DisputeOriginalPaymentMethod([void updates(DisputeOriginalPaymentMethodBuilder b)]) = _$DisputeOriginalPaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeOriginalPaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeOriginalPaymentMethod> get serializer => _$DisputeOriginalPaymentMethodSerializer();
}

class _$DisputeOriginalPaymentMethodSerializer implements PrimitiveSerializer<DisputeOriginalPaymentMethod> {
  @override
  final Iterable<Type> types = const [DisputeOriginalPaymentMethod, _$DisputeOriginalPaymentMethod];

  @override
  final String wireName = r'DisputeOriginalPaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeOriginalPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'physical';
    yield serializers.serialize(
      object.physical,
      specifiedType: const FullType(bool),
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
    DisputeOriginalPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeOriginalPaymentMethodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'physical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.physical = valueDes;
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
  DisputeOriginalPaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeOriginalPaymentMethodBuilder();
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


