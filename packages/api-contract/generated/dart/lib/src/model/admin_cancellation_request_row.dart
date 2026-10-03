//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancellation_request_row.g.dart';

/// AdminCancellationRequestRow
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [vendorName]
/// * [reasonCode]
/// * [requestedAt]
/// * [responseDueAt]
/// * [overdue]
@BuiltValue()
abstract class AdminCancellationRequestRow implements Built<AdminCancellationRequestRow, AdminCancellationRequestRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'reason_code')
  String get reasonCode;

  @BuiltValueField(wireName: r'requested_at')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'response_due_at')
  DateTime? get responseDueAt;

  @BuiltValueField(wireName: r'overdue')
  bool get overdue;

  AdminCancellationRequestRow._();

  factory AdminCancellationRequestRow([void updates(AdminCancellationRequestRowBuilder b)]) = _$AdminCancellationRequestRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancellationRequestRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancellationRequestRow> get serializer => _$AdminCancellationRequestRowSerializer();
}

class _$AdminCancellationRequestRowSerializer implements PrimitiveSerializer<AdminCancellationRequestRow> {
  @override
  final Iterable<Type> types = const [AdminCancellationRequestRow, _$AdminCancellationRequestRow];

  @override
  final String wireName = r'AdminCancellationRequestRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancellationRequestRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    if (object.vendorName != null) {
      yield r'vendor_name';
      yield serializers.serialize(
        object.vendorName,
        specifiedType: const FullType(String),
      );
    }
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    if (object.requestedAt != null) {
      yield r'requested_at';
      yield serializers.serialize(
        object.requestedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.responseDueAt != null) {
      yield r'response_due_at';
      yield serializers.serialize(
        object.responseDueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'overdue';
    yield serializers.serialize(
      object.overdue,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancellationRequestRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCancellationRequestRowBuilder result,
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
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorName = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reasonCode = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.requestedAt = valueDes;
          break;
        case r'response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.overdue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCancellationRequestRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancellationRequestRowBuilder();
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


