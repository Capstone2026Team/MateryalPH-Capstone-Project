//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/support_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_update.g.dart';

/// SupportUpdate
///
/// Properties:
/// * [lockVersion]
/// * [reason]
/// * [status]
/// * [assignedAdminId]
@BuiltValue()
abstract class SupportUpdate implements Built<SupportUpdate, SupportUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'status')
  SupportStatus? get status;
  // enum statusEnum {  OPEN,  IN_PROGRESS,  WAITING_FOR_USER,  RESOLVED,  CLOSED,  };

  @BuiltValueField(wireName: r'assigned_admin_id')
  String? get assignedAdminId;

  SupportUpdate._();

  factory SupportUpdate([void updates(SupportUpdateBuilder b)]) = _$SupportUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportUpdate> get serializer => _$SupportUpdateSerializer();
}

class _$SupportUpdateSerializer implements PrimitiveSerializer<SupportUpdate> {
  @override
  final Iterable<Type> types = const [SupportUpdate, _$SupportUpdate];

  @override
  final String wireName = r'SupportUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(SupportStatus),
      );
    }
    if (object.assignedAdminId != null) {
      yield r'assigned_admin_id';
      yield serializers.serialize(
        object.assignedAdminId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportUpdateBuilder result,
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SupportStatus),
          ) as SupportStatus?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'assigned_admin_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedAdminId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportUpdateBuilder();
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


