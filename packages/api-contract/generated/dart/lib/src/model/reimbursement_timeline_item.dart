//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reimbursement_timeline_item.g.dart';

/// ReimbursementTimelineItem
///
/// Properties:
/// * [id]
/// * [state]
/// * [amountCentavos]
/// * [method]
/// * [reimbursedAt]
/// * [buyerAcknowledgedAt]
/// * [hasEvidence]
/// * [evidencePath]
/// * [confirmedByReview]
/// * [message]
@BuiltValue()
abstract class ReimbursementTimelineItem implements Built<ReimbursementTimelineItem, ReimbursementTimelineItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'state')
  ReimbursementTimelineItemStateEnum get state;
  // enum stateEnum {  VENDOR_REIMBURSEMENT_PENDING,  REIMBURSEMENT_CONFIRMED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'reimbursed_at')
  DateTime? get reimbursedAt;

  @BuiltValueField(wireName: r'buyer_acknowledged_at')
  DateTime? get buyerAcknowledgedAt;

  @BuiltValueField(wireName: r'has_evidence')
  bool get hasEvidence;

  @BuiltValueField(wireName: r'evidence_path')
  String? get evidencePath;

  @BuiltValueField(wireName: r'confirmed_by_review')
  bool get confirmedByReview;

  @BuiltValueField(wireName: r'message')
  String get message;

  ReimbursementTimelineItem._();

  factory ReimbursementTimelineItem([void updates(ReimbursementTimelineItemBuilder b)]) = _$ReimbursementTimelineItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReimbursementTimelineItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReimbursementTimelineItem> get serializer => _$ReimbursementTimelineItemSerializer();
}

class _$ReimbursementTimelineItemSerializer implements PrimitiveSerializer<ReimbursementTimelineItem> {
  @override
  final Iterable<Type> types = const [ReimbursementTimelineItem, _$ReimbursementTimelineItem];

  @override
  final String wireName = r'ReimbursementTimelineItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReimbursementTimelineItem object, {
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
      specifiedType: const FullType(ReimbursementTimelineItemStateEnum),
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
    yield r'has_evidence';
    yield serializers.serialize(
      object.hasEvidence,
      specifiedType: const FullType(bool),
    );
    if (object.evidencePath != null) {
      yield r'evidence_path';
      yield serializers.serialize(
        object.evidencePath,
        specifiedType: const FullType(String),
      );
    }
    yield r'confirmed_by_review';
    yield serializers.serialize(
      object.confirmedByReview,
      specifiedType: const FullType(bool),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReimbursementTimelineItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReimbursementTimelineItemBuilder result,
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
            specifiedType: const FullType(ReimbursementTimelineItemStateEnum),
          ) as ReimbursementTimelineItemStateEnum;
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
        case r'has_evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasEvidence = valueDes;
          break;
        case r'evidence_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidencePath = valueDes;
          break;
        case r'confirmed_by_review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.confirmedByReview = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReimbursementTimelineItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReimbursementTimelineItemBuilder();
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


class ReimbursementTimelineItemStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_REIMBURSEMENT_PENDING')
  static const ReimbursementTimelineItemStateEnum VENDOR_REIMBURSEMENT_PENDING = _$reimbursementTimelineItemStateEnum_VENDOR_REIMBURSEMENT_PENDING;
  @BuiltValueEnumConst(wireName: r'REIMBURSEMENT_CONFIRMED')
  static const ReimbursementTimelineItemStateEnum REIMBURSEMENT_CONFIRMED = _$reimbursementTimelineItemStateEnum_REIMBURSEMENT_CONFIRMED;

  static Serializer<ReimbursementTimelineItemStateEnum> get serializer => _$reimbursementTimelineItemStateEnumSerializer;

  const ReimbursementTimelineItemStateEnum._(String name): super(name);

  static BuiltSet<ReimbursementTimelineItemStateEnum> get values => _$reimbursementTimelineItemStateEnumValues;
  static ReimbursementTimelineItemStateEnum valueOf(String name) => _$reimbursementTimelineItemStateEnumValueOf(name);
}

