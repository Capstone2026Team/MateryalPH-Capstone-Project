//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_affected_line.g.dart';

/// DisputeAffectedLine
///
/// Properties:
/// * [orderLineId]
/// * [displayName]
/// * [variantLabel]
/// * [quantity]
/// * [lineTotalCentavos]
/// * [refundableCentavos]
@BuiltValue()
abstract class DisputeAffectedLine implements Built<DisputeAffectedLine, DisputeAffectedLineBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'line_total_centavos')
  int get lineTotalCentavos;

  @BuiltValueField(wireName: r'refundable_centavos')
  int get refundableCentavos;

  DisputeAffectedLine._();

  factory DisputeAffectedLine([void updates(DisputeAffectedLineBuilder b)]) = _$DisputeAffectedLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeAffectedLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeAffectedLine> get serializer => _$DisputeAffectedLineSerializer();
}

class _$DisputeAffectedLineSerializer implements PrimitiveSerializer<DisputeAffectedLine> {
  @override
  final Iterable<Type> types = const [DisputeAffectedLine, _$DisputeAffectedLine];

  @override
  final String wireName = r'DisputeAffectedLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeAffectedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'line_total_centavos';
    yield serializers.serialize(
      object.lineTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refundable_centavos';
    yield serializers.serialize(
      object.refundableCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeAffectedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeAffectedLineBuilder result,
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'line_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineTotalCentavos = valueDes;
          break;
        case r'refundable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundableCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeAffectedLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeAffectedLineBuilder();
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


