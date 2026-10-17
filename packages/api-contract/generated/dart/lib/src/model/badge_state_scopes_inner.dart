//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge_state_scopes_inner.g.dart';

/// BadgeStateScopesInner
///
/// Properties:
/// * [scopeLabel]
/// * [earnedAt]
@BuiltValue()
abstract class BadgeStateScopesInner implements Built<BadgeStateScopesInner, BadgeStateScopesInnerBuilder> {
  @BuiltValueField(wireName: r'scope_label')
  String? get scopeLabel;

  @BuiltValueField(wireName: r'earned_at')
  DateTime? get earnedAt;

  BadgeStateScopesInner._();

  factory BadgeStateScopesInner([void updates(BadgeStateScopesInnerBuilder b)]) = _$BadgeStateScopesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeStateScopesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BadgeStateScopesInner> get serializer => _$BadgeStateScopesInnerSerializer();
}

class _$BadgeStateScopesInnerSerializer implements PrimitiveSerializer<BadgeStateScopesInner> {
  @override
  final Iterable<Type> types = const [BadgeStateScopesInner, _$BadgeStateScopesInner];

  @override
  final String wireName = r'BadgeStateScopesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BadgeStateScopesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.scopeLabel != null) {
      yield r'scope_label';
      yield serializers.serialize(
        object.scopeLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.earnedAt != null) {
      yield r'earned_at';
      yield serializers.serialize(
        object.earnedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BadgeStateScopesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeStateScopesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scopeLabel = valueDes;
          break;
        case r'earned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.earnedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BadgeStateScopesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeStateScopesInnerBuilder();
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


