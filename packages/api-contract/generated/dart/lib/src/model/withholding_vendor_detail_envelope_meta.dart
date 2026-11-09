//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_vendor_detail_envelope_meta.g.dart';

/// WithholdingVendorDetailEnvelopeMeta
///
/// Properties:
/// * [hasMore]
/// * [total]
/// * [page]
@BuiltValue()
abstract class WithholdingVendorDetailEnvelopeMeta implements Built<WithholdingVendorDetailEnvelopeMeta, WithholdingVendorDetailEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'page')
  int get page;

  WithholdingVendorDetailEnvelopeMeta._();

  factory WithholdingVendorDetailEnvelopeMeta([void updates(WithholdingVendorDetailEnvelopeMetaBuilder b)]) = _$WithholdingVendorDetailEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingVendorDetailEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingVendorDetailEnvelopeMeta> get serializer => _$WithholdingVendorDetailEnvelopeMetaSerializer();
}

class _$WithholdingVendorDetailEnvelopeMetaSerializer implements PrimitiveSerializer<WithholdingVendorDetailEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [WithholdingVendorDetailEnvelopeMeta, _$WithholdingVendorDetailEnvelopeMeta];

  @override
  final String wireName = r'WithholdingVendorDetailEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingVendorDetailEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingVendorDetailEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingVendorDetailEnvelopeMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingVendorDetailEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingVendorDetailEnvelopeMetaBuilder();
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


