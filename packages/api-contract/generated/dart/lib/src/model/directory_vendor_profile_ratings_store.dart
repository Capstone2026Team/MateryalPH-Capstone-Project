//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_ratings_store.g.dart';

/// DirectoryVendorProfileRatingsStore
///
/// Properties:
/// * [count]
/// * [serviceQuality]
/// * [speed]
@BuiltValue()
abstract class DirectoryVendorProfileRatingsStore implements Built<DirectoryVendorProfileRatingsStore, DirectoryVendorProfileRatingsStoreBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'service_quality')
  String? get serviceQuality;

  @BuiltValueField(wireName: r'speed')
  String? get speed;

  DirectoryVendorProfileRatingsStore._();

  factory DirectoryVendorProfileRatingsStore([void updates(DirectoryVendorProfileRatingsStoreBuilder b)]) = _$DirectoryVendorProfileRatingsStore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileRatingsStoreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileRatingsStore> get serializer => _$DirectoryVendorProfileRatingsStoreSerializer();
}

class _$DirectoryVendorProfileRatingsStoreSerializer implements PrimitiveSerializer<DirectoryVendorProfileRatingsStore> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileRatingsStore, _$DirectoryVendorProfileRatingsStore];

  @override
  final String wireName = r'DirectoryVendorProfileRatingsStore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileRatingsStore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'service_quality';
    yield object.serviceQuality == null ? null : serializers.serialize(
      object.serviceQuality,
      specifiedType: const FullType.nullable(String),
    );
    yield r'speed';
    yield object.speed == null ? null : serializers.serialize(
      object.speed,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileRatingsStore object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileRatingsStoreBuilder result,
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
        case r'service_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serviceQuality = valueDes;
          break;
        case r'speed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.speed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileRatingsStore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileRatingsStoreBuilder();
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


