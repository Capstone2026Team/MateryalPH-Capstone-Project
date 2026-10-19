//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_ratings_product.g.dart';

/// DirectoryVendorProfileRatingsProduct
///
/// Properties:
/// * [count]
/// * [average]
@BuiltValue()
abstract class DirectoryVendorProfileRatingsProduct implements Built<DirectoryVendorProfileRatingsProduct, DirectoryVendorProfileRatingsProductBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'average')
  String? get average;

  DirectoryVendorProfileRatingsProduct._();

  factory DirectoryVendorProfileRatingsProduct([void updates(DirectoryVendorProfileRatingsProductBuilder b)]) = _$DirectoryVendorProfileRatingsProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileRatingsProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileRatingsProduct> get serializer => _$DirectoryVendorProfileRatingsProductSerializer();
}

class _$DirectoryVendorProfileRatingsProductSerializer implements PrimitiveSerializer<DirectoryVendorProfileRatingsProduct> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileRatingsProduct, _$DirectoryVendorProfileRatingsProduct];

  @override
  final String wireName = r'DirectoryVendorProfileRatingsProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileRatingsProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'average';
    yield object.average == null ? null : serializers.serialize(
      object.average,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileRatingsProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileRatingsProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.average = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileRatingsProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileRatingsProductBuilder();
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


