//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'explore_labels.g.dart';

/// ExploreLabels
///
/// Properties:
/// * [verifiedVendors]
/// * [vendorListings]
/// * [vendorListingsUnit] - Always Vendor listings.
@BuiltValue()
abstract class ExploreLabels implements Built<ExploreLabels, ExploreLabelsBuilder> {
  @BuiltValueField(wireName: r'verified_vendors')
  String get verifiedVendors;

  @BuiltValueField(wireName: r'vendor_listings')
  String get vendorListings;

  /// Always Vendor listings.
  @BuiltValueField(wireName: r'vendor_listings_unit')
  String get vendorListingsUnit;

  ExploreLabels._();

  factory ExploreLabels([void updates(ExploreLabelsBuilder b)]) = _$ExploreLabels;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExploreLabelsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExploreLabels> get serializer => _$ExploreLabelsSerializer();
}

class _$ExploreLabelsSerializer implements PrimitiveSerializer<ExploreLabels> {
  @override
  final Iterable<Type> types = const [ExploreLabels, _$ExploreLabels];

  @override
  final String wireName = r'ExploreLabels';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExploreLabels object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verified_vendors';
    yield serializers.serialize(
      object.verifiedVendors,
      specifiedType: const FullType(String),
    );
    yield r'vendor_listings';
    yield serializers.serialize(
      object.vendorListings,
      specifiedType: const FullType(String),
    );
    yield r'vendor_listings_unit';
    yield serializers.serialize(
      object.vendorListingsUnit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExploreLabels object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExploreLabelsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verified_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.verifiedVendors = valueDes;
          break;
        case r'vendor_listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorListings = valueDes;
          break;
        case r'vendor_listings_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorListingsUnit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExploreLabels deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExploreLabelsBuilder();
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


