//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/nrpc_flag.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/nrpc_terms_version.dart';
import 'package:materyalph_api_client/src/model/nrpc_affected_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_nrpc.g.dart';

/// OrderNrpc
///
/// Properties:
/// * [id]
/// * [amountCentavos]
/// * [reason]
/// * [eligibleSubtotalCentavos]
/// * [snapshotVersion]
/// * [proposedAt]
/// * [affectedLines]
/// * [terms]
/// * [cancellationEffect]
/// * [status]
/// * [acceptedAt]
/// * [flag]
@BuiltValue()
abstract class OrderNrpc implements Built<OrderNrpc, OrderNrpcBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'eligible_subtotal_centavos')
  int? get eligibleSubtotalCentavos;

  @BuiltValueField(wireName: r'snapshot_version')
  int get snapshotVersion;

  @BuiltValueField(wireName: r'proposed_at')
  DateTime? get proposedAt;

  @BuiltValueField(wireName: r'affected_lines')
  BuiltList<NrpcAffectedLine> get affectedLines;

  @BuiltValueField(wireName: r'terms')
  NrpcTermsVersion? get terms;

  @BuiltValueField(wireName: r'cancellation_effect')
  String get cancellationEffect;

  @BuiltValueField(wireName: r'status')
  OrderNrpcStatusEnum get status;
  // enum statusEnum {  PROPOSED,  ACCEPTED,  REJECTED,  };

  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  @BuiltValueField(wireName: r'flag')
  NrpcFlag? get flag;

  OrderNrpc._();

  factory OrderNrpc([void updates(OrderNrpcBuilder b)]) = _$OrderNrpc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderNrpcBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderNrpc> get serializer => _$OrderNrpcSerializer();
}

class _$OrderNrpcSerializer implements PrimitiveSerializer<OrderNrpc> {
  @override
  final Iterable<Type> types = const [OrderNrpc, _$OrderNrpc];

  @override
  final String wireName = r'OrderNrpc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderNrpc object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'eligible_subtotal_centavos';
    yield object.eligibleSubtotalCentavos == null ? null : serializers.serialize(
      object.eligibleSubtotalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'snapshot_version';
    yield serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType(int),
    );
    yield r'proposed_at';
    yield object.proposedAt == null ? null : serializers.serialize(
      object.proposedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'affected_lines';
    yield serializers.serialize(
      object.affectedLines,
      specifiedType: const FullType(BuiltList, [FullType(NrpcAffectedLine)]),
    );
    yield r'terms';
    yield object.terms == null ? null : serializers.serialize(
      object.terms,
      specifiedType: const FullType.nullable(NrpcTermsVersion),
    );
    yield r'cancellation_effect';
    yield serializers.serialize(
      object.cancellationEffect,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OrderNrpcStatusEnum),
    );
    yield r'accepted_at';
    yield object.acceptedAt == null ? null : serializers.serialize(
      object.acceptedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'flag';
    yield object.flag == null ? null : serializers.serialize(
      object.flag,
      specifiedType: const FullType.nullable(NrpcFlag),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderNrpc object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderNrpcBuilder result,
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
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'eligible_subtotal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.eligibleSubtotalCentavos = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.snapshotVersion = valueDes;
          break;
        case r'proposed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.proposedAt = valueDes;
          break;
        case r'affected_lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NrpcAffectedLine)]),
          ) as BuiltList<NrpcAffectedLine>;
          result.affectedLines.replace(valueDes);
          break;
        case r'terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NrpcTermsVersion),
          ) as NrpcTermsVersion?;
          if (valueDes == null) continue;
          result.terms.replace(valueDes);
          break;
        case r'cancellation_effect':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cancellationEffect = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderNrpcStatusEnum),
          ) as OrderNrpcStatusEnum;
          result.status = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'flag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NrpcFlag),
          ) as NrpcFlag?;
          if (valueDes == null) continue;
          result.flag.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderNrpc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderNrpcBuilder();
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


class OrderNrpcStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROPOSED')
  static const OrderNrpcStatusEnum PROPOSED = _$orderNrpcStatusEnum_PROPOSED;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const OrderNrpcStatusEnum ACCEPTED = _$orderNrpcStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const OrderNrpcStatusEnum REJECTED = _$orderNrpcStatusEnum_REJECTED;

  static Serializer<OrderNrpcStatusEnum> get serializer => _$orderNrpcStatusEnumSerializer;

  const OrderNrpcStatusEnum._(String name): super(name);

  static BuiltSet<OrderNrpcStatusEnum> get values => _$orderNrpcStatusEnumValues;
  static OrderNrpcStatusEnum valueOf(String name) => _$orderNrpcStatusEnumValueOf(name);
}

