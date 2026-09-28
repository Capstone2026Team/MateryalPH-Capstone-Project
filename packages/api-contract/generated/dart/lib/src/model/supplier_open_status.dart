//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supplier_open_status.g.dart';

/// Descriptive only. Derived from saved public hours in Asia/Manila; never filters, ranks or implies stock or staff presence.
///
/// Properties:
/// * [status]
/// * [opensAt]
/// * [closesAt]
/// * [basis]
@BuiltValue()
abstract class SupplierOpenStatus implements Built<SupplierOpenStatus, SupplierOpenStatusBuilder> {
  @BuiltValueField(wireName: r'status')
  SupplierOpenStatusStatusEnum get status;
  // enum statusEnum {  OPEN,  CLOSED,  UNAVAILABLE,  };

  @BuiltValueField(wireName: r'opens_at')
  String? get opensAt;

  @BuiltValueField(wireName: r'closes_at')
  String? get closesAt;

  @BuiltValueField(wireName: r'basis')
  SupplierOpenStatusBasisEnum get basis;
  // enum basisEnum {  SAVED_SCHEDULE,  DATE_OVERRIDE,  };

  SupplierOpenStatus._();

  factory SupplierOpenStatus([void updates(SupplierOpenStatusBuilder b)]) = _$SupplierOpenStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupplierOpenStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupplierOpenStatus> get serializer => _$SupplierOpenStatusSerializer();
}

class _$SupplierOpenStatusSerializer implements PrimitiveSerializer<SupplierOpenStatus> {
  @override
  final Iterable<Type> types = const [SupplierOpenStatus, _$SupplierOpenStatus];

  @override
  final String wireName = r'SupplierOpenStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupplierOpenStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SupplierOpenStatusStatusEnum),
    );
    yield r'opens_at';
    yield object.opensAt == null ? null : serializers.serialize(
      object.opensAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'closes_at';
    yield object.closesAt == null ? null : serializers.serialize(
      object.closesAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(SupplierOpenStatusBasisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupplierOpenStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupplierOpenStatusBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierOpenStatusStatusEnum),
          ) as SupplierOpenStatusStatusEnum;
          result.status = valueDes;
          break;
        case r'opens_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'closes_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierOpenStatusBasisEnum),
          ) as SupplierOpenStatusBasisEnum;
          result.basis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupplierOpenStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupplierOpenStatusBuilder();
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


class SupplierOpenStatusStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const SupplierOpenStatusStatusEnum OPEN = _$supplierOpenStatusStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const SupplierOpenStatusStatusEnum CLOSED = _$supplierOpenStatusStatusEnum_CLOSED;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const SupplierOpenStatusStatusEnum UNAVAILABLE = _$supplierOpenStatusStatusEnum_UNAVAILABLE;

  static Serializer<SupplierOpenStatusStatusEnum> get serializer => _$supplierOpenStatusStatusEnumSerializer;

  const SupplierOpenStatusStatusEnum._(String name): super(name);

  static BuiltSet<SupplierOpenStatusStatusEnum> get values => _$supplierOpenStatusStatusEnumValues;
  static SupplierOpenStatusStatusEnum valueOf(String name) => _$supplierOpenStatusStatusEnumValueOf(name);
}

class SupplierOpenStatusBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAVED_SCHEDULE')
  static const SupplierOpenStatusBasisEnum SAVED_SCHEDULE = _$supplierOpenStatusBasisEnum_SAVED_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'DATE_OVERRIDE')
  static const SupplierOpenStatusBasisEnum DATE_OVERRIDE = _$supplierOpenStatusBasisEnum_DATE_OVERRIDE;

  static Serializer<SupplierOpenStatusBasisEnum> get serializer => _$supplierOpenStatusBasisEnumSerializer;

  const SupplierOpenStatusBasisEnum._(String name): super(name);

  static BuiltSet<SupplierOpenStatusBasisEnum> get values => _$supplierOpenStatusBasisEnumValues;
  static SupplierOpenStatusBasisEnum valueOf(String name) => _$supplierOpenStatusBasisEnumValueOf(name);
}

