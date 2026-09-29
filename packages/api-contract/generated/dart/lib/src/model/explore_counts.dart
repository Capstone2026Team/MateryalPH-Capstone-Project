//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'explore_counts.g.dart';

/// ExploreCounts
///
/// Properties:
/// * [verifiedVendors] - Distinct active Tier 2 organizations with at least one eligible listing in scope.
/// * [vendorListings] - Distinct Vendor listings with at least one eligible variant; variants never inflate it.
@BuiltValue()
abstract class ExploreCounts implements Built<ExploreCounts, ExploreCountsBuilder> {
  /// Distinct active Tier 2 organizations with at least one eligible listing in scope.
  @BuiltValueField(wireName: r'verified_vendors')
  int get verifiedVendors;

  /// Distinct Vendor listings with at least one eligible variant; variants never inflate it.
  @BuiltValueField(wireName: r'vendor_listings')
  int get vendorListings;

  ExploreCounts._();

  factory ExploreCounts([void updates(ExploreCountsBuilder b)]) = _$ExploreCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExploreCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExploreCounts> get serializer => _$ExploreCountsSerializer();
}

class _$ExploreCountsSerializer implements PrimitiveSerializer<ExploreCounts> {
  @override
  final Iterable<Type> types = const [ExploreCounts, _$ExploreCounts];

  @override
  final String wireName = r'ExploreCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExploreCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verified_vendors';
    yield serializers.serialize(
      object.verifiedVendors,
      specifiedType: const FullType(int),
    );
    yield r'vendor_listings';
    yield serializers.serialize(
      object.vendorListings,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExploreCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExploreCountsBuilder result,
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
        case r'vendor_listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorListings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExploreCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExploreCountsBuilder();
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


