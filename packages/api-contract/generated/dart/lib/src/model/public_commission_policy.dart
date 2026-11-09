//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/commission_policy.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_commission_policy.g.dart';

/// PublicCommissionPolicy
///
/// Properties:
/// * [current]
/// * [next]
/// * [selected]
@BuiltValue()
abstract class PublicCommissionPolicy implements Built<PublicCommissionPolicy, PublicCommissionPolicyBuilder> {
  @BuiltValueField(wireName: r'current')
  CommissionPolicy? get current;

  @BuiltValueField(wireName: r'next')
  CommissionPolicy? get next;

  @BuiltValueField(wireName: r'selected')
  CommissionPolicy? get selected;

  PublicCommissionPolicy._();

  factory PublicCommissionPolicy([void updates(PublicCommissionPolicyBuilder b)]) = _$PublicCommissionPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicCommissionPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicCommissionPolicy> get serializer => _$PublicCommissionPolicySerializer();
}

class _$PublicCommissionPolicySerializer implements PrimitiveSerializer<PublicCommissionPolicy> {
  @override
  final Iterable<Type> types = const [PublicCommissionPolicy, _$PublicCommissionPolicy];

  @override
  final String wireName = r'PublicCommissionPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicCommissionPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.current != null) {
      yield r'current';
      yield serializers.serialize(
        object.current,
        specifiedType: const FullType.nullable(CommissionPolicy),
      );
    }
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType.nullable(CommissionPolicy),
      );
    }
    if (object.selected != null) {
      yield r'selected';
      yield serializers.serialize(
        object.selected,
        specifiedType: const FullType.nullable(CommissionPolicy),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicCommissionPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicCommissionPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionPolicy),
          ) as CommissionPolicy?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionPolicy),
          ) as CommissionPolicy?;
          if (valueDes == null) continue;
          result.next.replace(valueDes);
          break;
        case r'selected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionPolicy),
          ) as CommissionPolicy?;
          if (valueDes == null) continue;
          result.selected.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicCommissionPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicCommissionPolicyBuilder();
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


