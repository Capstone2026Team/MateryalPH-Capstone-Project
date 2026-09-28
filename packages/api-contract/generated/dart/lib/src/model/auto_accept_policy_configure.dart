//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_configure.g.dart';

/// AutoAcceptPolicyConfigure
///
/// Properties:
/// * [lockVersion] - 0 when no policy exists yet.
/// * [enabled]
/// * [allotmentQuantity] - Whole-number remaining allotment; above zero to enable.
/// * [maxUnitCount]
/// * [maxOrderAmountCentavos]
@BuiltValue()
abstract class AutoAcceptPolicyConfigure implements Built<AutoAcceptPolicyConfigure, AutoAcceptPolicyConfigureBuilder> {
  /// 0 when no policy exists yet.
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Whole-number remaining allotment; above zero to enable.
  @BuiltValueField(wireName: r'allotment_quantity')
  String get allotmentQuantity;

  @BuiltValueField(wireName: r'max_unit_count')
  String? get maxUnitCount;

  @BuiltValueField(wireName: r'max_order_amount_centavos')
  int? get maxOrderAmountCentavos;

  AutoAcceptPolicyConfigure._();

  factory AutoAcceptPolicyConfigure([void updates(AutoAcceptPolicyConfigureBuilder b)]) = _$AutoAcceptPolicyConfigure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyConfigureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyConfigure> get serializer => _$AutoAcceptPolicyConfigureSerializer();
}

class _$AutoAcceptPolicyConfigureSerializer implements PrimitiveSerializer<AutoAcceptPolicyConfigure> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyConfigure, _$AutoAcceptPolicyConfigure];

  @override
  final String wireName = r'AutoAcceptPolicyConfigure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyConfigure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'allotment_quantity';
    yield serializers.serialize(
      object.allotmentQuantity,
      specifiedType: const FullType(String),
    );
    if (object.maxUnitCount != null) {
      yield r'max_unit_count';
      yield serializers.serialize(
        object.maxUnitCount,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.maxOrderAmountCentavos != null) {
      yield r'max_order_amount_centavos';
      yield serializers.serialize(
        object.maxOrderAmountCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyConfigure object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyConfigureBuilder result,
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
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'allotment_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.allotmentQuantity = valueDes;
          break;
        case r'max_unit_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maxUnitCount = valueDes;
          break;
        case r'max_order_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxOrderAmountCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyConfigure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyConfigureBuilder();
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


