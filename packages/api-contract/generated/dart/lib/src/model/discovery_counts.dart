//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_counts.g.dart';

/// DiscoveryCounts
///
/// Properties:
/// * [verifiedVendors]
/// * [directorySuppliers]
/// * [favoriteSuppliers]
@BuiltValue()
abstract class DiscoveryCounts implements Built<DiscoveryCounts, DiscoveryCountsBuilder> {
  @BuiltValueField(wireName: r'verified_vendors')
  int get verifiedVendors;

  @BuiltValueField(wireName: r'directory_suppliers')
  int get directorySuppliers;

  @BuiltValueField(wireName: r'favorite_suppliers')
  int get favoriteSuppliers;

  DiscoveryCounts._();

  factory DiscoveryCounts([void updates(DiscoveryCountsBuilder b)]) = _$DiscoveryCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoveryCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoveryCounts> get serializer => _$DiscoveryCountsSerializer();
}

class _$DiscoveryCountsSerializer implements PrimitiveSerializer<DiscoveryCounts> {
  @override
  final Iterable<Type> types = const [DiscoveryCounts, _$DiscoveryCounts];

  @override
  final String wireName = r'DiscoveryCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoveryCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verified_vendors';
    yield serializers.serialize(
      object.verifiedVendors,
      specifiedType: const FullType(int),
    );
    yield r'directory_suppliers';
    yield serializers.serialize(
      object.directorySuppliers,
      specifiedType: const FullType(int),
    );
    yield r'favorite_suppliers';
    yield serializers.serialize(
      object.favoriteSuppliers,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DiscoveryCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoveryCountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verified_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.verifiedVendors = valueDes;
          break;
        case r'directory_suppliers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.directorySuppliers = valueDes;
          break;
        case r'favorite_suppliers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.favoriteSuppliers = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiscoveryCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoveryCountsBuilder();
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


