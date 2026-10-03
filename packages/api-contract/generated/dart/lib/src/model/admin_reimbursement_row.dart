//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reimbursement_row.g.dart';

/// AdminReimbursementRow
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [vendorName]
/// * [state]
/// * [amountCentavos]
/// * [method]
/// * [hasEvidence]
/// * [reimbursedAt]
/// * [buyerAcknowledgedAt]
/// * [confirmedByReview]
/// * [canDecide]
@BuiltValue()
abstract class AdminReimbursementRow implements Built<AdminReimbursementRow, AdminReimbursementRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'state')
  AdminReimbursementRowStateEnum get state;
  // enum stateEnum {  VENDOR_REIMBURSEMENT_PENDING,  REIMBURSEMENT_CONFIRMED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'has_evidence')
  bool get hasEvidence;

  @BuiltValueField(wireName: r'reimbursed_at')
  DateTime? get reimbursedAt;

  @BuiltValueField(wireName: r'buyer_acknowledged_at')
  DateTime? get buyerAcknowledgedAt;

  @BuiltValueField(wireName: r'confirmed_by_review')
  bool get confirmedByReview;

  @BuiltValueField(wireName: r'can_decide')
  bool get canDecide;

  AdminReimbursementRow._();

  factory AdminReimbursementRow([void updates(AdminReimbursementRowBuilder b)]) = _$AdminReimbursementRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReimbursementRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReimbursementRow> get serializer => _$AdminReimbursementRowSerializer();
}

class _$AdminReimbursementRowSerializer implements PrimitiveSerializer<AdminReimbursementRow> {
  @override
  final Iterable<Type> types = const [AdminReimbursementRow, _$AdminReimbursementRow];

  @override
  final String wireName = r'AdminReimbursementRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReimbursementRow object, {
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
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminReimbursementRowStateEnum),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    yield r'has_evidence';
    yield serializers.serialize(
      object.hasEvidence,
      specifiedType: const FullType(bool),
    );
    if (object.reimbursedAt != null) {
      yield r'reimbursed_at';
      yield serializers.serialize(
        object.reimbursedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.buyerAcknowledgedAt != null) {
      yield r'buyer_acknowledged_at';
      yield serializers.serialize(
        object.buyerAcknowledgedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'confirmed_by_review';
    yield serializers.serialize(
      object.confirmedByReview,
      specifiedType: const FullType(bool),
    );
    yield r'can_decide';
    yield serializers.serialize(
      object.canDecide,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReimbursementRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReimbursementRowBuilder result,
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
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminReimbursementRowStateEnum),
          ) as AdminReimbursementRowStateEnum;
          result.state = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'has_evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasEvidence = valueDes;
          break;
        case r'reimbursed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reimbursedAt = valueDes;
          break;
        case r'buyer_acknowledged_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.buyerAcknowledgedAt = valueDes;
          break;
        case r'confirmed_by_review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.confirmedByReview = valueDes;
          break;
        case r'can_decide':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDecide = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReimbursementRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReimbursementRowBuilder();
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


class AdminReimbursementRowStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_REIMBURSEMENT_PENDING')
  static const AdminReimbursementRowStateEnum VENDOR_REIMBURSEMENT_PENDING = _$adminReimbursementRowStateEnum_VENDOR_REIMBURSEMENT_PENDING;
  @BuiltValueEnumConst(wireName: r'REIMBURSEMENT_CONFIRMED')
  static const AdminReimbursementRowStateEnum REIMBURSEMENT_CONFIRMED = _$adminReimbursementRowStateEnum_REIMBURSEMENT_CONFIRMED;

  static Serializer<AdminReimbursementRowStateEnum> get serializer => _$adminReimbursementRowStateEnumSerializer;

  const AdminReimbursementRowStateEnum._(String name): super(name);

  static BuiltSet<AdminReimbursementRowStateEnum> get values => _$adminReimbursementRowStateEnumValues;
  static AdminReimbursementRowStateEnum valueOf(String name) => _$adminReimbursementRowStateEnumValueOf(name);
}

