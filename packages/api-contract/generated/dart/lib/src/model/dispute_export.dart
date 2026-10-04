//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_export.g.dart';

/// DisputeExport
///
/// Properties:
/// * [id]
/// * [state]
/// * [rowCount]
/// * [requestedAt]
/// * [completedAt]
/// * [expiresAt]
/// * [revocationReason]
@BuiltValue()
abstract class DisputeExport implements Built<DisputeExport, DisputeExportBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'state')
  DisputeExportStateEnum get state;
  // enum stateEnum {  QUEUED,  READY,  REVOKED,  FAILED,  EXPIRED,  };

  @BuiltValueField(wireName: r'row_count')
  int? get rowCount;

  @BuiltValueField(wireName: r'requested_at')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'revocation_reason')
  String? get revocationReason;

  DisputeExport._();

  factory DisputeExport([void updates(DisputeExportBuilder b)]) = _$DisputeExport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeExportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeExport> get serializer => _$DisputeExportSerializer();
}

class _$DisputeExportSerializer implements PrimitiveSerializer<DisputeExport> {
  @override
  final Iterable<Type> types = const [DisputeExport, _$DisputeExport];

  @override
  final String wireName = r'DisputeExport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeExport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DisputeExportStateEnum),
    );
    if (object.rowCount != null) {
      yield r'row_count';
      yield serializers.serialize(
        object.rowCount,
        specifiedType: const FullType(int),
      );
    }
    yield r'requested_at';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.expiresAt != null) {
      yield r'expires_at';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.revocationReason != null) {
      yield r'revocation_reason';
      yield serializers.serialize(
        object.revocationReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeExport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeExportBuilder result,
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
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeExportStateEnum),
          ) as DisputeExportStateEnum;
          result.state = valueDes;
          break;
        case r'row_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowCount = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'revocation_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.revocationReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeExport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeExportBuilder();
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


class DisputeExportStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUEUED')
  static const DisputeExportStateEnum QUEUED = _$disputeExportStateEnum_QUEUED;
  @BuiltValueEnumConst(wireName: r'READY')
  static const DisputeExportStateEnum READY = _$disputeExportStateEnum_READY;
  @BuiltValueEnumConst(wireName: r'REVOKED')
  static const DisputeExportStateEnum REVOKED = _$disputeExportStateEnum_REVOKED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const DisputeExportStateEnum FAILED = _$disputeExportStateEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const DisputeExportStateEnum EXPIRED = _$disputeExportStateEnum_EXPIRED;

  static Serializer<DisputeExportStateEnum> get serializer => _$disputeExportStateEnumSerializer;

  const DisputeExportStateEnum._(String name): super(name);

  static BuiltSet<DisputeExportStateEnum> get values => _$disputeExportStateEnumValues;
  static DisputeExportStateEnum valueOf(String name) => _$disputeExportStateEnumValueOf(name);
}

