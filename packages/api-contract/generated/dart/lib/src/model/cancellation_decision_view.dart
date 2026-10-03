//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_decision_view.g.dart';

/// CancellationDecisionView
///
/// Properties:
/// * [cause]
/// * [decidedBy]
/// * [decisionCode]
/// * [reasonCode]
/// * [reason]
/// * [nrpcRetainedCentavos]
/// * [refundTotalCentavos]
/// * [cashReimbursementCentavos]
/// * [releasedUnpaidCentavos]
/// * [orderStateBefore]
/// * [decidedAt]
/// * [nrpcEvidenceOnFile]
/// * [nrpcEvidencePath]
@BuiltValue()
abstract class CancellationDecisionView implements Built<CancellationDecisionView, CancellationDecisionViewBuilder> {
  @BuiltValueField(wireName: r'cause')
  CancellationDecisionViewCauseEnum get cause;
  // enum causeEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'decided_by')
  CancellationDecisionViewDecidedByEnum get decidedBy;
  // enum decidedByEnum {  BUYER,  VENDOR,  SYSTEM,  };

  @BuiltValueField(wireName: r'decision_code')
  String get decisionCode;

  @BuiltValueField(wireName: r'reason_code')
  String? get reasonCode;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'nrpc_retained_centavos')
  int get nrpcRetainedCentavos;

  @BuiltValueField(wireName: r'refund_total_centavos')
  int get refundTotalCentavos;

  @BuiltValueField(wireName: r'cash_reimbursement_centavos')
  int get cashReimbursementCentavos;

  @BuiltValueField(wireName: r'released_unpaid_centavos')
  int get releasedUnpaidCentavos;

  @BuiltValueField(wireName: r'order_state_before')
  String get orderStateBefore;

  @BuiltValueField(wireName: r'decided_at')
  DateTime? get decidedAt;

  @BuiltValueField(wireName: r'nrpc_evidence_on_file')
  bool get nrpcEvidenceOnFile;

  @BuiltValueField(wireName: r'nrpc_evidence_path')
  String? get nrpcEvidencePath;

  CancellationDecisionView._();

  factory CancellationDecisionView([void updates(CancellationDecisionViewBuilder b)]) = _$CancellationDecisionView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationDecisionViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationDecisionView> get serializer => _$CancellationDecisionViewSerializer();
}

class _$CancellationDecisionViewSerializer implements PrimitiveSerializer<CancellationDecisionView> {
  @override
  final Iterable<Type> types = const [CancellationDecisionView, _$CancellationDecisionView];

  @override
  final String wireName = r'CancellationDecisionView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationDecisionView object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cause';
    yield serializers.serialize(
      object.cause,
      specifiedType: const FullType(CancellationDecisionViewCauseEnum),
    );
    yield r'decided_by';
    yield serializers.serialize(
      object.decidedBy,
      specifiedType: const FullType(CancellationDecisionViewDecidedByEnum),
    );
    yield r'decision_code';
    yield serializers.serialize(
      object.decisionCode,
      specifiedType: const FullType(String),
    );
    if (object.reasonCode != null) {
      yield r'reason_code';
      yield serializers.serialize(
        object.reasonCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'nrpc_retained_centavos';
    yield serializers.serialize(
      object.nrpcRetainedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refund_total_centavos';
    yield serializers.serialize(
      object.refundTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'cash_reimbursement_centavos';
    yield serializers.serialize(
      object.cashReimbursementCentavos,
      specifiedType: const FullType(int),
    );
    yield r'released_unpaid_centavos';
    yield serializers.serialize(
      object.releasedUnpaidCentavos,
      specifiedType: const FullType(int),
    );
    yield r'order_state_before';
    yield serializers.serialize(
      object.orderStateBefore,
      specifiedType: const FullType(String),
    );
    if (object.decidedAt != null) {
      yield r'decided_at';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'nrpc_evidence_on_file';
    yield serializers.serialize(
      object.nrpcEvidenceOnFile,
      specifiedType: const FullType(bool),
    );
    if (object.nrpcEvidencePath != null) {
      yield r'nrpc_evidence_path';
      yield serializers.serialize(
        object.nrpcEvidencePath,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationDecisionView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationDecisionViewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cause':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationDecisionViewCauseEnum),
          ) as CancellationDecisionViewCauseEnum;
          result.cause = valueDes;
          break;
        case r'decided_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationDecisionViewDecidedByEnum),
          ) as CancellationDecisionViewDecidedByEnum;
          result.decidedBy = valueDes;
          break;
        case r'decision_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.decisionCode = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'nrpc_retained_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcRetainedCentavos = valueDes;
          break;
        case r'refund_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundTotalCentavos = valueDes;
          break;
        case r'cash_reimbursement_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cashReimbursementCentavos = valueDes;
          break;
        case r'released_unpaid_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.releasedUnpaidCentavos = valueDes;
          break;
        case r'order_state_before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderStateBefore = valueDes;
          break;
        case r'decided_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'nrpc_evidence_on_file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.nrpcEvidenceOnFile = valueDes;
          break;
        case r'nrpc_evidence_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nrpcEvidencePath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationDecisionView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationDecisionViewBuilder();
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


class CancellationDecisionViewCauseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const CancellationDecisionViewCauseEnum BUYER = _$cancellationDecisionViewCauseEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const CancellationDecisionViewCauseEnum VENDOR = _$cancellationDecisionViewCauseEnum_VENDOR;

  static Serializer<CancellationDecisionViewCauseEnum> get serializer => _$cancellationDecisionViewCauseEnumSerializer;

  const CancellationDecisionViewCauseEnum._(String name): super(name);

  static BuiltSet<CancellationDecisionViewCauseEnum> get values => _$cancellationDecisionViewCauseEnumValues;
  static CancellationDecisionViewCauseEnum valueOf(String name) => _$cancellationDecisionViewCauseEnumValueOf(name);
}

class CancellationDecisionViewDecidedByEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const CancellationDecisionViewDecidedByEnum BUYER = _$cancellationDecisionViewDecidedByEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const CancellationDecisionViewDecidedByEnum VENDOR = _$cancellationDecisionViewDecidedByEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const CancellationDecisionViewDecidedByEnum SYSTEM = _$cancellationDecisionViewDecidedByEnum_SYSTEM;

  static Serializer<CancellationDecisionViewDecidedByEnum> get serializer => _$cancellationDecisionViewDecidedByEnumSerializer;

  const CancellationDecisionViewDecidedByEnum._(String name): super(name);

  static BuiltSet<CancellationDecisionViewDecidedByEnum> get values => _$cancellationDecisionViewDecidedByEnumValues;
  static CancellationDecisionViewDecidedByEnum valueOf(String name) => _$cancellationDecisionViewDecidedByEnumValueOf(name);
}

