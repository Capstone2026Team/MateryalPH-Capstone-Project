//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_finance_reviews_open_reviews_inner.g.dart';

/// VendorFinanceReviewsOpenReviewsInner
///
/// Properties:
/// * [id]
/// * [kind]
/// * [label]
/// * [createdAt]
@BuiltValue()
abstract class VendorFinanceReviewsOpenReviewsInner implements Built<VendorFinanceReviewsOpenReviewsInner, VendorFinanceReviewsOpenReviewsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  VendorFinanceReviewsOpenReviewsInner._();

  factory VendorFinanceReviewsOpenReviewsInner([void updates(VendorFinanceReviewsOpenReviewsInnerBuilder b)]) = _$VendorFinanceReviewsOpenReviewsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorFinanceReviewsOpenReviewsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorFinanceReviewsOpenReviewsInner> get serializer => _$VendorFinanceReviewsOpenReviewsInnerSerializer();
}

class _$VendorFinanceReviewsOpenReviewsInnerSerializer implements PrimitiveSerializer<VendorFinanceReviewsOpenReviewsInner> {
  @override
  final Iterable<Type> types = const [VendorFinanceReviewsOpenReviewsInner, _$VendorFinanceReviewsOpenReviewsInner];

  @override
  final String wireName = r'VendorFinanceReviewsOpenReviewsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorFinanceReviewsOpenReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorFinanceReviewsOpenReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorFinanceReviewsOpenReviewsInnerBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorFinanceReviewsOpenReviewsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorFinanceReviewsOpenReviewsInnerBuilder();
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


