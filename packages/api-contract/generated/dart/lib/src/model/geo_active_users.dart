//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_cell.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_active_users.g.dart';

/// GeoActiveUsers
///
/// Properties:
/// * [dau]
/// * [wau]
/// * [mau]
@BuiltValue()
abstract class GeoActiveUsers implements Built<GeoActiveUsers, GeoActiveUsersBuilder> {
  @BuiltValueField(wireName: r'dau')
  GeoCell get dau;

  @BuiltValueField(wireName: r'wau')
  GeoCell get wau;

  @BuiltValueField(wireName: r'mau')
  GeoCell get mau;

  GeoActiveUsers._();

  factory GeoActiveUsers([void updates(GeoActiveUsersBuilder b)]) = _$GeoActiveUsers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoActiveUsersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoActiveUsers> get serializer => _$GeoActiveUsersSerializer();
}

class _$GeoActiveUsersSerializer implements PrimitiveSerializer<GeoActiveUsers> {
  @override
  final Iterable<Type> types = const [GeoActiveUsers, _$GeoActiveUsers];

  @override
  final String wireName = r'GeoActiveUsers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoActiveUsers object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dau';
    yield serializers.serialize(
      object.dau,
      specifiedType: const FullType(GeoCell),
    );
    yield r'wau';
    yield serializers.serialize(
      object.wau,
      specifiedType: const FullType(GeoCell),
    );
    yield r'mau';
    yield serializers.serialize(
      object.mau,
      specifiedType: const FullType(GeoCell),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoActiveUsers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoActiveUsersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.dau.replace(valueDes);
          break;
        case r'wau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.wau.replace(valueDes);
          break;
        case r'mau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.mau.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoActiveUsers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoActiveUsersBuilder();
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


