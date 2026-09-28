//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_detail_scope.g.dart';

/// AutoAcceptPolicyDetailScope
///
/// Properties:
/// * [itemBasedOnly]
/// * [nrpcExcluded]
/// * [projectBasedExcluded]
/// * [ruleVersion]
@BuiltValue()
abstract class AutoAcceptPolicyDetailScope implements Built<AutoAcceptPolicyDetailScope, AutoAcceptPolicyDetailScopeBuilder> {
  @BuiltValueField(wireName: r'item_based_only')
  AutoAcceptPolicyDetailScopeItemBasedOnlyEnum get itemBasedOnly;
  // enum itemBasedOnlyEnum {  true,  };

  @BuiltValueField(wireName: r'nrpc_excluded')
  AutoAcceptPolicyDetailScopeNrpcExcludedEnum get nrpcExcluded;
  // enum nrpcExcludedEnum {  true,  };

  @BuiltValueField(wireName: r'project_based_excluded')
  AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum get projectBasedExcluded;
  // enum projectBasedExcludedEnum {  true,  };

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  AutoAcceptPolicyDetailScope._();

  factory AutoAcceptPolicyDetailScope([void updates(AutoAcceptPolicyDetailScopeBuilder b)]) = _$AutoAcceptPolicyDetailScope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyDetailScopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyDetailScope> get serializer => _$AutoAcceptPolicyDetailScopeSerializer();
}

class _$AutoAcceptPolicyDetailScopeSerializer implements PrimitiveSerializer<AutoAcceptPolicyDetailScope> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyDetailScope, _$AutoAcceptPolicyDetailScope];

  @override
  final String wireName = r'AutoAcceptPolicyDetailScope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyDetailScope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'item_based_only';
    yield serializers.serialize(
      object.itemBasedOnly,
      specifiedType: const FullType(AutoAcceptPolicyDetailScopeItemBasedOnlyEnum),
    );
    yield r'nrpc_excluded';
    yield serializers.serialize(
      object.nrpcExcluded,
      specifiedType: const FullType(AutoAcceptPolicyDetailScopeNrpcExcludedEnum),
    );
    yield r'project_based_excluded';
    yield serializers.serialize(
      object.projectBasedExcluded,
      specifiedType: const FullType(AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyDetailScope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyDetailScopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item_based_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetailScopeItemBasedOnlyEnum),
          ) as AutoAcceptPolicyDetailScopeItemBasedOnlyEnum;
          result.itemBasedOnly = valueDes;
          break;
        case r'nrpc_excluded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetailScopeNrpcExcludedEnum),
          ) as AutoAcceptPolicyDetailScopeNrpcExcludedEnum;
          result.nrpcExcluded = valueDes;
          break;
        case r'project_based_excluded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum),
          ) as AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum;
          result.projectBasedExcluded = valueDes;
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyDetailScope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyDetailScopeBuilder();
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


class AutoAcceptPolicyDetailScopeItemBasedOnlyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AutoAcceptPolicyDetailScopeItemBasedOnlyEnum true_ = _$autoAcceptPolicyDetailScopeItemBasedOnlyEnum_true_;

  static Serializer<AutoAcceptPolicyDetailScopeItemBasedOnlyEnum> get serializer => _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumSerializer;

  const AutoAcceptPolicyDetailScopeItemBasedOnlyEnum._(String name): super(name);

  static BuiltSet<AutoAcceptPolicyDetailScopeItemBasedOnlyEnum> get values => _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumValues;
  static AutoAcceptPolicyDetailScopeItemBasedOnlyEnum valueOf(String name) => _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumValueOf(name);
}

class AutoAcceptPolicyDetailScopeNrpcExcludedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AutoAcceptPolicyDetailScopeNrpcExcludedEnum true_ = _$autoAcceptPolicyDetailScopeNrpcExcludedEnum_true_;

  static Serializer<AutoAcceptPolicyDetailScopeNrpcExcludedEnum> get serializer => _$autoAcceptPolicyDetailScopeNrpcExcludedEnumSerializer;

  const AutoAcceptPolicyDetailScopeNrpcExcludedEnum._(String name): super(name);

  static BuiltSet<AutoAcceptPolicyDetailScopeNrpcExcludedEnum> get values => _$autoAcceptPolicyDetailScopeNrpcExcludedEnumValues;
  static AutoAcceptPolicyDetailScopeNrpcExcludedEnum valueOf(String name) => _$autoAcceptPolicyDetailScopeNrpcExcludedEnumValueOf(name);
}

class AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum true_ = _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnum_true_;

  static Serializer<AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum> get serializer => _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumSerializer;

  const AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum._(String name): super(name);

  static BuiltSet<AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum> get values => _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumValues;
  static AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum valueOf(String name) => _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumValueOf(name);
}

