//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_first_line.g.dart';

/// OrderFirstLine
///
/// Properties:
/// * [displayName]
/// * [image]
@BuiltValue()
abstract class OrderFirstLine implements Built<OrderFirstLine, OrderFirstLineBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  OrderFirstLine._();

  factory OrderFirstLine([void updates(OrderFirstLineBuilder b)]) = _$OrderFirstLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderFirstLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderFirstLine> get serializer => _$OrderFirstLineSerializer();
}

class _$OrderFirstLineSerializer implements PrimitiveSerializer<OrderFirstLine> {
  @override
  final Iterable<Type> types = const [OrderFirstLine, _$OrderFirstLine];

  @override
  final String wireName = r'OrderFirstLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderFirstLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'image';
    yield object.image == null ? null : serializers.serialize(
      object.image,
      specifiedType: const FullType.nullable(ListingImage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderFirstLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderFirstLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderFirstLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderFirstLineBuilder();
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


