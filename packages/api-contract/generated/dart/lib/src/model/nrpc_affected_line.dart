//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_affected_line.g.dart';

/// NrpcAffectedLine
///
/// Properties:
/// * [orderLineId]
/// * [label]
/// * [principalCentavos]
/// * [linePayableCentavos]
/// * [includedVatCentavos]
@BuiltValue()
abstract class NrpcAffectedLine implements Built<NrpcAffectedLine, NrpcAffectedLineBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'principal_centavos')
  int get principalCentavos;

  @BuiltValueField(wireName: r'line_payable_centavos')
  int get linePayableCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  NrpcAffectedLine._();

  factory NrpcAffectedLine([void updates(NrpcAffectedLineBuilder b)]) = _$NrpcAffectedLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcAffectedLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcAffectedLine> get serializer => _$NrpcAffectedLineSerializer();
}

class _$NrpcAffectedLineSerializer implements PrimitiveSerializer<NrpcAffectedLine> {
  @override
  final Iterable<Type> types = const [NrpcAffectedLine, _$NrpcAffectedLine];

  @override
  final String wireName = r'NrpcAffectedLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcAffectedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'principal_centavos';
    yield serializers.serialize(
      object.principalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'line_payable_centavos';
    yield serializers.serialize(
      object.linePayableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcAffectedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcAffectedLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderLineId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.principalCentavos = valueDes;
          break;
        case r'line_payable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linePayableCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcAffectedLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcAffectedLineBuilder();
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


