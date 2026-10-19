//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/commission_policy.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_policies.g.dart';

/// CommissionPolicies
///
/// Properties:
/// * [current]
/// * [next]
/// * [latestVersion]
/// * [canManage]
/// * [versions]
@BuiltValue()
abstract class CommissionPolicies implements Built<CommissionPolicies, CommissionPoliciesBuilder> {
  @BuiltValueField(wireName: r'current')
  CommissionPolicy? get current;

  @BuiltValueField(wireName: r'next')
  CommissionPolicy? get next;

  @BuiltValueField(wireName: r'latest_version')
  int get latestVersion;

  @BuiltValueField(wireName: r'can_manage')
  bool get canManage;

  @BuiltValueField(wireName: r'versions')
  BuiltList<CommissionPolicy> get versions;

  CommissionPolicies._();

  factory CommissionPolicies([void updates(CommissionPoliciesBuilder b)]) = _$CommissionPolicies;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPoliciesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPolicies> get serializer => _$CommissionPoliciesSerializer();
}

class _$CommissionPoliciesSerializer implements PrimitiveSerializer<CommissionPolicies> {
  @override
  final Iterable<Type> types = const [CommissionPolicies, _$CommissionPolicies];

  @override
  final String wireName = r'CommissionPolicies';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPolicies object, {
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
    yield r'latest_version';
    yield serializers.serialize(
      object.latestVersion,
      specifiedType: const FullType(int),
    );
    yield r'can_manage';
    yield serializers.serialize(
      object.canManage,
      specifiedType: const FullType(bool),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [FullType(CommissionPolicy)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPolicies object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPoliciesBuilder result,
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
        case r'latest_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.latestVersion = valueDes;
          break;
        case r'can_manage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManage = valueDes;
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionPolicy)]),
          ) as BuiltList<CommissionPolicy>;
          result.versions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPolicies deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPoliciesBuilder();
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


