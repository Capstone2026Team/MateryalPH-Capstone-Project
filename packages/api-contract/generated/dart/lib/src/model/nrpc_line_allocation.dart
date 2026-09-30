//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_line_allocation.g.dart';

/// NrpcLineAllocation
///
/// Properties:
/// * [orderLineId]
/// * [principalCentavos]
@BuiltValue()
abstract class NrpcLineAllocation implements Built<NrpcLineAllocation, NrpcLineAllocationBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'principal_centavos')
  int get principalCentavos;

  NrpcLineAllocation._();

  factory NrpcLineAllocation([void updates(NrpcLineAllocationBuilder b)]) = _$NrpcLineAllocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcLineAllocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcLineAllocation> get serializer => _$NrpcLineAllocationSerializer();
}

class _$NrpcLineAllocationSerializer implements PrimitiveSerializer<NrpcLineAllocation> {
  @override
  final Iterable<Type> types = const [NrpcLineAllocation, _$NrpcLineAllocation];

  @override
  final String wireName = r'NrpcLineAllocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcLineAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'principal_centavos';
    yield serializers.serialize(
      object.principalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcLineAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcLineAllocationBuilder result,
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
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.principalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcLineAllocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcLineAllocationBuilder();
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


