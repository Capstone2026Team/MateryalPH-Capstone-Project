//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_billing_snapshot.g.dart';

/// InvoiceBillingSnapshot
///
/// Properties:
/// * [billingName]
/// * [billingAddress]
/// * [tinMasked]
@BuiltValue()
abstract class InvoiceBillingSnapshot implements Built<InvoiceBillingSnapshot, InvoiceBillingSnapshotBuilder> {
  @BuiltValueField(wireName: r'billing_name')
  String get billingName;

  @BuiltValueField(wireName: r'billing_address')
  String get billingAddress;

  @BuiltValueField(wireName: r'tin_masked')
  String? get tinMasked;

  InvoiceBillingSnapshot._();

  factory InvoiceBillingSnapshot([void updates(InvoiceBillingSnapshotBuilder b)]) = _$InvoiceBillingSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceBillingSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceBillingSnapshot> get serializer => _$InvoiceBillingSnapshotSerializer();
}

class _$InvoiceBillingSnapshotSerializer implements PrimitiveSerializer<InvoiceBillingSnapshot> {
  @override
  final Iterable<Type> types = const [InvoiceBillingSnapshot, _$InvoiceBillingSnapshot];

  @override
  final String wireName = r'InvoiceBillingSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceBillingSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'billing_name';
    yield serializers.serialize(
      object.billingName,
      specifiedType: const FullType(String),
    );
    yield r'billing_address';
    yield serializers.serialize(
      object.billingAddress,
      specifiedType: const FullType(String),
    );
    if (object.tinMasked != null) {
      yield r'tin_masked';
      yield serializers.serialize(
        object.tinMasked,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceBillingSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceBillingSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'billing_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billingName = valueDes;
          break;
        case r'billing_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billingAddress = valueDes;
          break;
        case r'tin_masked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tinMasked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceBillingSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceBillingSnapshotBuilder();
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


