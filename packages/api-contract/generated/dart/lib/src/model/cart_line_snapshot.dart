//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_line_snapshot.g.dart';

/// What the Buyer saw when the line was added or last accepted.
///
/// Properties:
/// * [priceVersionId]
/// * [unitPriceCentavos]
/// * [stockLabel]
/// * [publicationVersion]
/// * [addedAt]
@BuiltValue()
abstract class CartLineSnapshot implements Built<CartLineSnapshot, CartLineSnapshotBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String? get priceVersionId;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int? get unitPriceCentavos;

  @BuiltValueField(wireName: r'stock_label')
  String? get stockLabel;

  @BuiltValueField(wireName: r'publication_version')
  int? get publicationVersion;

  @BuiltValueField(wireName: r'added_at')
  DateTime get addedAt;

  CartLineSnapshot._();

  factory CartLineSnapshot([void updates(CartLineSnapshotBuilder b)]) = _$CartLineSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartLineSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartLineSnapshot> get serializer => _$CartLineSnapshotSerializer();
}

class _$CartLineSnapshotSerializer implements PrimitiveSerializer<CartLineSnapshot> {
  @override
  final Iterable<Type> types = const [CartLineSnapshot, _$CartLineSnapshot];

  @override
  final String wireName = r'CartLineSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartLineSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price_version_id';
    yield object.priceVersionId == null ? null : serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'unit_price_centavos';
    yield object.unitPriceCentavos == null ? null : serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'stock_label';
    yield object.stockLabel == null ? null : serializers.serialize(
      object.stockLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'publication_version';
    yield object.publicationVersion == null ? null : serializers.serialize(
      object.publicationVersion,
      specifiedType: const FullType.nullable(int),
    );
    yield r'added_at';
    yield serializers.serialize(
      object.addedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartLineSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartLineSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.priceVersionId = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.unitPriceCentavos = valueDes;
          break;
        case r'stock_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stockLabel = valueDes;
          break;
        case r'publication_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.publicationVersion = valueDes;
          break;
        case r'added_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.addedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartLineSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartLineSnapshotBuilder();
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


