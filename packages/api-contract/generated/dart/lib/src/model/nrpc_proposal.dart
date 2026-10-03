//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/nrpc_line_allocation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_proposal.g.dart';

/// Manual only. 0 < amount ≤ the payable value of the affected lines; line principals sum exactly to the amount. No platform cap.
///
/// Properties:
/// * [amountCentavos]
/// * [reason]
/// * [lines]
@BuiltValue()
abstract class NrpcProposal implements Built<NrpcProposal, NrpcProposalBuilder> {
  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'lines')
  BuiltList<NrpcLineAllocation> get lines;

  NrpcProposal._();

  factory NrpcProposal([void updates(NrpcProposalBuilder b)]) = _$NrpcProposal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcProposalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcProposal> get serializer => _$NrpcProposalSerializer();
}

class _$NrpcProposalSerializer implements PrimitiveSerializer<NrpcProposal> {
  @override
  final Iterable<Type> types = const [NrpcProposal, _$NrpcProposal];

  @override
  final String wireName = r'NrpcProposal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcProposal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(NrpcLineAllocation)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcProposal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcProposalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NrpcLineAllocation)]),
          ) as BuiltList<NrpcLineAllocation>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcProposal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcProposalBuilder();
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


