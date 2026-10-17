//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_rule.g.dart';

/// Apriori association rule: items ordered together more often than chance (lift above 1). Co-occurrence, not causation.
///
/// Properties:
/// * [antecedent]
/// * [consequent]
/// * [support]
/// * [supportCount]
/// * [confidence]
/// * [lift]
@BuiltValue()
abstract class DashboardRule implements Built<DashboardRule, DashboardRuleBuilder> {
  @BuiltValueField(wireName: r'antecedent')
  BuiltList<String> get antecedent;

  @BuiltValueField(wireName: r'consequent')
  BuiltList<String> get consequent;

  @BuiltValueField(wireName: r'support')
  num get support;

  @BuiltValueField(wireName: r'support_count')
  int get supportCount;

  @BuiltValueField(wireName: r'confidence')
  num get confidence;

  @BuiltValueField(wireName: r'lift')
  num get lift;

  DashboardRule._();

  factory DashboardRule([void updates(DashboardRuleBuilder b)]) = _$DashboardRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardRule> get serializer => _$DashboardRuleSerializer();
}

class _$DashboardRuleSerializer implements PrimitiveSerializer<DashboardRule> {
  @override
  final Iterable<Type> types = const [DashboardRule, _$DashboardRule];

  @override
  final String wireName = r'DashboardRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'antecedent';
    yield serializers.serialize(
      object.antecedent,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'consequent';
    yield serializers.serialize(
      object.consequent,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'support';
    yield serializers.serialize(
      object.support,
      specifiedType: const FullType(num),
    );
    yield r'support_count';
    yield serializers.serialize(
      object.supportCount,
      specifiedType: const FullType(int),
    );
    yield r'confidence';
    yield serializers.serialize(
      object.confidence,
      specifiedType: const FullType(num),
    );
    yield r'lift';
    yield serializers.serialize(
      object.lift,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardRuleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'antecedent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.antecedent.replace(valueDes);
          break;
        case r'consequent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.consequent.replace(valueDes);
          break;
        case r'support':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.support = valueDes;
          break;
        case r'support_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.supportCount = valueDes;
          break;
        case r'confidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.confidence = valueDes;
          break;
        case r'lift':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lift = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardRuleBuilder();
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


