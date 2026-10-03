//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/payment_channel_option.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/payment_attempt.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fee_statement_detail.g.dart';

/// FeeStatementDetail
///
/// Properties:
/// * [id]
/// * [reference]
/// * [state]
/// * [overdue]
/// * [periodStart]
/// * [periodEnd]
/// * [issuedOn]
/// * [dueOn]
/// * [chargesCentavos]
/// * [creditsCentavos]
/// * [paidCentavos]
/// * [outstandingCentavos]
/// * [disputedHeldCentavos]
/// * [lockVersion]
/// * [sampleNotice]
/// * [lines]
/// * [payments]
/// * [channels]
@BuiltValue()
abstract class FeeStatementDetail implements Built<FeeStatementDetail, FeeStatementDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'overdue')
  bool get overdue;

  @BuiltValueField(wireName: r'period_start')
  String get periodStart;

  @BuiltValueField(wireName: r'period_end')
  String get periodEnd;

  @BuiltValueField(wireName: r'issued_on')
  String get issuedOn;

  @BuiltValueField(wireName: r'due_on')
  String get dueOn;

  @BuiltValueField(wireName: r'charges_centavos')
  int get chargesCentavos;

  @BuiltValueField(wireName: r'credits_centavos')
  int get creditsCentavos;

  @BuiltValueField(wireName: r'paid_centavos')
  int get paidCentavos;

  @BuiltValueField(wireName: r'outstanding_centavos')
  int get outstandingCentavos;

  @BuiltValueField(wireName: r'disputed_held_centavos')
  int get disputedHeldCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'sample_notice')
  String get sampleNotice;

  @BuiltValueField(wireName: r'lines')
  BuiltList<BuiltMap<String, JsonObject?>> get lines;

  @BuiltValueField(wireName: r'payments')
  BuiltList<PaymentAttempt> get payments;

  @BuiltValueField(wireName: r'channels')
  BuiltList<PaymentChannelOption> get channels;

  FeeStatementDetail._();

  factory FeeStatementDetail([void updates(FeeStatementDetailBuilder b)]) = _$FeeStatementDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeeStatementDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeeStatementDetail> get serializer => _$FeeStatementDetailSerializer();
}

class _$FeeStatementDetailSerializer implements PrimitiveSerializer<FeeStatementDetail> {
  @override
  final Iterable<Type> types = const [FeeStatementDetail, _$FeeStatementDetail];

  @override
  final String wireName = r'FeeStatementDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeeStatementDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'overdue';
    yield serializers.serialize(
      object.overdue,
      specifiedType: const FullType(bool),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(String),
    );
    yield r'period_end';
    yield serializers.serialize(
      object.periodEnd,
      specifiedType: const FullType(String),
    );
    yield r'issued_on';
    yield serializers.serialize(
      object.issuedOn,
      specifiedType: const FullType(String),
    );
    yield r'due_on';
    yield serializers.serialize(
      object.dueOn,
      specifiedType: const FullType(String),
    );
    yield r'charges_centavos';
    yield serializers.serialize(
      object.chargesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'credits_centavos';
    yield serializers.serialize(
      object.creditsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'paid_centavos';
    yield serializers.serialize(
      object.paidCentavos,
      specifiedType: const FullType(int),
    );
    yield r'outstanding_centavos';
    yield serializers.serialize(
      object.outstandingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'disputed_held_centavos';
    yield serializers.serialize(
      object.disputedHeldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'sample_notice';
    yield serializers.serialize(
      object.sampleNotice,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(PaymentAttempt)]),
    );
    yield r'channels';
    yield serializers.serialize(
      object.channels,
      specifiedType: const FullType(BuiltList, [FullType(PaymentChannelOption)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeeStatementDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeeStatementDetailBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.overdue = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodStart = valueDes;
          break;
        case r'period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodEnd = valueDes;
          break;
        case r'issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuedOn = valueDes;
          break;
        case r'due_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dueOn = valueDes;
          break;
        case r'charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.chargesCentavos = valueDes;
          break;
        case r'credits_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditsCentavos = valueDes;
          break;
        case r'paid_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paidCentavos = valueDes;
          break;
        case r'outstanding_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outstandingCentavos = valueDes;
          break;
        case r'disputed_held_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.disputedHeldCentavos = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'sample_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sampleNotice = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.lines.replace(valueDes);
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentAttempt)]),
          ) as BuiltList<PaymentAttempt>;
          result.payments.replace(valueDes);
          break;
        case r'channels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentChannelOption)]),
          ) as BuiltList<PaymentChannelOption>;
          result.channels.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeeStatementDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeeStatementDetailBuilder();
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


