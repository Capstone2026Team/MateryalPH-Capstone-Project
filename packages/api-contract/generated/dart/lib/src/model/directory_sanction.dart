//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_sanction.g.dart';

/// DirectorySanction
///
/// Properties:
/// * [id]
/// * [action]
/// * [actionLabel]
/// * [state]
/// * [reason]
/// * [createdAt]
/// * [expiresAt]
@BuiltValue()
abstract class DirectorySanction implements Built<DirectorySanction, DirectorySanctionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'action')
  DirectorySanctionActionEnum get action;
  // enum actionEnum {  WARNING,  TEMPORARY_RESTRICTION,  SUSPENSION,  PERMANENT_BAN,  };

  @BuiltValueField(wireName: r'action_label')
  String get actionLabel;

  @BuiltValueField(wireName: r'state')
  DirectorySanctionStateEnum get state;
  // enum stateEnum {  EFFECTIVE,  REFERRED,  APPLIED,  LIFTED,  DECLINED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  DirectorySanction._();

  factory DirectorySanction([void updates(DirectorySanctionBuilder b)]) = _$DirectorySanction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectorySanctionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectorySanction> get serializer => _$DirectorySanctionSerializer();
}

class _$DirectorySanctionSerializer implements PrimitiveSerializer<DirectorySanction> {
  @override
  final Iterable<Type> types = const [DirectorySanction, _$DirectorySanction];

  @override
  final String wireName = r'DirectorySanction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectorySanction object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(DirectorySanctionActionEnum),
    );
    yield r'action_label';
    yield serializers.serialize(
      object.actionLabel,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DirectorySanctionStateEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expires_at';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectorySanction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectorySanctionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySanctionActionEnum),
          ) as DirectorySanctionActionEnum;
          result.action = valueDes;
          break;
        case r'action_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actionLabel = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySanctionStateEnum),
          ) as DirectorySanctionStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectorySanction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectorySanctionBuilder();
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


class DirectorySanctionActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const DirectorySanctionActionEnum WARNING = _$directorySanctionActionEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const DirectorySanctionActionEnum TEMPORARY_RESTRICTION = _$directorySanctionActionEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const DirectorySanctionActionEnum SUSPENSION = _$directorySanctionActionEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const DirectorySanctionActionEnum PERMANENT_BAN = _$directorySanctionActionEnum_PERMANENT_BAN;

  static Serializer<DirectorySanctionActionEnum> get serializer => _$directorySanctionActionEnumSerializer;

  const DirectorySanctionActionEnum._(String name): super(name);

  static BuiltSet<DirectorySanctionActionEnum> get values => _$directorySanctionActionEnumValues;
  static DirectorySanctionActionEnum valueOf(String name) => _$directorySanctionActionEnumValueOf(name);
}

class DirectorySanctionStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EFFECTIVE')
  static const DirectorySanctionStateEnum EFFECTIVE = _$directorySanctionStateEnum_EFFECTIVE;
  @BuiltValueEnumConst(wireName: r'REFERRED')
  static const DirectorySanctionStateEnum REFERRED = _$directorySanctionStateEnum_REFERRED;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const DirectorySanctionStateEnum APPLIED = _$directorySanctionStateEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'LIFTED')
  static const DirectorySanctionStateEnum LIFTED = _$directorySanctionStateEnum_LIFTED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const DirectorySanctionStateEnum DECLINED = _$directorySanctionStateEnum_DECLINED;

  static Serializer<DirectorySanctionStateEnum> get serializer => _$directorySanctionStateEnumSerializer;

  const DirectorySanctionStateEnum._(String name): super(name);

  static BuiltSet<DirectorySanctionStateEnum> get values => _$directorySanctionStateEnumValues;
  static DirectorySanctionStateEnum valueOf(String name) => _$directorySanctionStateEnumValueOf(name);
}

