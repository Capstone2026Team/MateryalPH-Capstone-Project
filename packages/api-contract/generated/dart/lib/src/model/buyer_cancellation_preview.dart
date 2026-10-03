//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_cancellation.dart';
import 'package:materyalph_api_client/src/model/cancellation_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_cancellation_preview.g.dart';

/// BuyerCancellationPreview
///
/// Properties:
/// * [availability]
/// * [fullRefund]
/// * [withNrpcRetained]
/// * [nrpcRetainableCentavos]
/// * [notice]
@BuiltValue()
abstract class BuyerCancellationPreview implements Built<BuyerCancellationPreview, BuyerCancellationPreviewBuilder> {
  @BuiltValueField(wireName: r'availability')
  OrderCancellation get availability;

  @BuiltValueField(wireName: r'full_refund')
  CancellationPlan get fullRefund;

  @BuiltValueField(wireName: r'with_nrpc_retained')
  CancellationPlan? get withNrpcRetained;

  @BuiltValueField(wireName: r'nrpc_retainable_centavos')
  int get nrpcRetainableCentavos;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  BuyerCancellationPreview._();

  factory BuyerCancellationPreview([void updates(BuyerCancellationPreviewBuilder b)]) = _$BuyerCancellationPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerCancellationPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerCancellationPreview> get serializer => _$BuyerCancellationPreviewSerializer();
}

class _$BuyerCancellationPreviewSerializer implements PrimitiveSerializer<BuyerCancellationPreview> {
  @override
  final Iterable<Type> types = const [BuyerCancellationPreview, _$BuyerCancellationPreview];

  @override
  final String wireName = r'BuyerCancellationPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerCancellationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(OrderCancellation),
    );
    yield r'full_refund';
    yield serializers.serialize(
      object.fullRefund,
      specifiedType: const FullType(CancellationPlan),
    );
    if (object.withNrpcRetained != null) {
      yield r'with_nrpc_retained';
      yield serializers.serialize(
        object.withNrpcRetained,
        specifiedType: const FullType.nullable(CancellationPlan),
      );
    }
    yield r'nrpc_retainable_centavos';
    yield serializers.serialize(
      object.nrpcRetainableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerCancellationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerCancellationPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderCancellation),
          ) as OrderCancellation;
          result.availability.replace(valueDes);
          break;
        case r'full_refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationPlan),
          ) as CancellationPlan;
          result.fullRefund.replace(valueDes);
          break;
        case r'with_nrpc_retained':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CancellationPlan),
          ) as CancellationPlan?;
          if (valueDes == null) continue;
          result.withNrpcRetained.replace(valueDes);
          break;
        case r'nrpc_retainable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcRetainableCentavos = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerCancellationPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerCancellationPreviewBuilder();
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


