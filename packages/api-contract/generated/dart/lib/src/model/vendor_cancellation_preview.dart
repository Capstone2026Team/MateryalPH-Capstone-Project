//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/cancellation_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_cancellation_preview.g.dart';

/// VendorCancellationPreview
///
/// Properties:
/// * [vendorCancellation]
/// * [fullRefund]
/// * [withNrpcRetained]
/// * [nrpcRetainableCentavos]
/// * [notice]
@BuiltValue()
abstract class VendorCancellationPreview implements Built<VendorCancellationPreview, VendorCancellationPreviewBuilder> {
  @BuiltValueField(wireName: r'vendor_cancellation')
  CancellationPlan get vendorCancellation;

  @BuiltValueField(wireName: r'full_refund')
  CancellationPlan? get fullRefund;

  @BuiltValueField(wireName: r'with_nrpc_retained')
  CancellationPlan? get withNrpcRetained;

  @BuiltValueField(wireName: r'nrpc_retainable_centavos')
  int? get nrpcRetainableCentavos;

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  VendorCancellationPreview._();

  factory VendorCancellationPreview([void updates(VendorCancellationPreviewBuilder b)]) = _$VendorCancellationPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCancellationPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCancellationPreview> get serializer => _$VendorCancellationPreviewSerializer();
}

class _$VendorCancellationPreviewSerializer implements PrimitiveSerializer<VendorCancellationPreview> {
  @override
  final Iterable<Type> types = const [VendorCancellationPreview, _$VendorCancellationPreview];

  @override
  final String wireName = r'VendorCancellationPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCancellationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_cancellation';
    yield serializers.serialize(
      object.vendorCancellation,
      specifiedType: const FullType(CancellationPlan),
    );
    if (object.fullRefund != null) {
      yield r'full_refund';
      yield serializers.serialize(
        object.fullRefund,
        specifiedType: const FullType(CancellationPlan),
      );
    }
    if (object.withNrpcRetained != null) {
      yield r'with_nrpc_retained';
      yield serializers.serialize(
        object.withNrpcRetained,
        specifiedType: const FullType.nullable(CancellationPlan),
      );
    }
    if (object.nrpcRetainableCentavos != null) {
      yield r'nrpc_retainable_centavos';
      yield serializers.serialize(
        object.nrpcRetainableCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.notice != null) {
      yield r'notice';
      yield serializers.serialize(
        object.notice,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCancellationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCancellationPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_cancellation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationPlan),
          ) as CancellationPlan;
          result.vendorCancellation.replace(valueDes);
          break;
        case r'full_refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CancellationPlan),
          ) as CancellationPlan?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.nrpcRetainableCentavos = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  VendorCancellationPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCancellationPreviewBuilder();
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


