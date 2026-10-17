//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_active_users.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_kpis_active_users.g.dart';

/// GeoKpisActiveUsers
///
/// Properties:
/// * [buyer]
/// * [vendor]
@BuiltValue()
abstract class GeoKpisActiveUsers implements Built<GeoKpisActiveUsers, GeoKpisActiveUsersBuilder> {
  @BuiltValueField(wireName: r'buyer')
  GeoActiveUsers get buyer;

  @BuiltValueField(wireName: r'vendor')
  GeoActiveUsers get vendor;

  GeoKpisActiveUsers._();

  factory GeoKpisActiveUsers([void updates(GeoKpisActiveUsersBuilder b)]) = _$GeoKpisActiveUsers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoKpisActiveUsersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoKpisActiveUsers> get serializer => _$GeoKpisActiveUsersSerializer();
}

class _$GeoKpisActiveUsersSerializer implements PrimitiveSerializer<GeoKpisActiveUsers> {
  @override
  final Iterable<Type> types = const [GeoKpisActiveUsers, _$GeoKpisActiveUsers];

  @override
  final String wireName = r'GeoKpisActiveUsers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoKpisActiveUsers object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'buyer';
    yield serializers.serialize(
      object.buyer,
      specifiedType: const FullType(GeoActiveUsers),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(GeoActiveUsers),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoKpisActiveUsers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoKpisActiveUsersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'buyer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoActiveUsers),
          ) as GeoActiveUsers;
          result.buyer.replace(valueDes);
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoActiveUsers),
          ) as GeoActiveUsers;
          result.vendor.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoKpisActiveUsers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoKpisActiveUsersBuilder();
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


