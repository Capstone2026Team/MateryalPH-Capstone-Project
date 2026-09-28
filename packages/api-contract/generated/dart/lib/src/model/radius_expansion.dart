//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'radius_expansion.g.dart';

/// A suggestion only. The next radius is never applied without Buyer confirmation; 50 km has no further expansion.
///
/// Properties:
/// * [eligibleVerifiedCount]
/// * [suggestedRadiusKm] - The next allowed radius (10, 20, 30, 40 or 50), or null at 50 km or with three or more Verified Vendors.
/// * [atMaximum]
/// * [reason] - FEWER_THAN_THREE_VERIFIED_VENDORS or null.
/// * [requiresConfirmation] - Always true; clients ask before changing the radius.
@BuiltValue()
abstract class RadiusExpansion implements Built<RadiusExpansion, RadiusExpansionBuilder> {
  @BuiltValueField(wireName: r'eligible_verified_count')
  int get eligibleVerifiedCount;

  /// The next allowed radius (10, 20, 30, 40 or 50), or null at 50 km or with three or more Verified Vendors.
  @BuiltValueField(wireName: r'suggested_radius_km')
  int? get suggestedRadiusKm;

  @BuiltValueField(wireName: r'at_maximum')
  bool get atMaximum;

  /// FEWER_THAN_THREE_VERIFIED_VENDORS or null.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// Always true; clients ask before changing the radius.
  @BuiltValueField(wireName: r'requires_confirmation')
  bool get requiresConfirmation;

  RadiusExpansion._();

  factory RadiusExpansion([void updates(RadiusExpansionBuilder b)]) = _$RadiusExpansion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RadiusExpansionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RadiusExpansion> get serializer => _$RadiusExpansionSerializer();
}

class _$RadiusExpansionSerializer implements PrimitiveSerializer<RadiusExpansion> {
  @override
  final Iterable<Type> types = const [RadiusExpansion, _$RadiusExpansion];

  @override
  final String wireName = r'RadiusExpansion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RadiusExpansion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'eligible_verified_count';
    yield serializers.serialize(
      object.eligibleVerifiedCount,
      specifiedType: const FullType(int),
    );
    yield r'suggested_radius_km';
    yield object.suggestedRadiusKm == null ? null : serializers.serialize(
      object.suggestedRadiusKm,
      specifiedType: const FullType.nullable(int),
    );
    yield r'at_maximum';
    yield serializers.serialize(
      object.atMaximum,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requires_confirmation';
    yield serializers.serialize(
      object.requiresConfirmation,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RadiusExpansion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RadiusExpansionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eligible_verified_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.eligibleVerifiedCount = valueDes;
          break;
        case r'suggested_radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.suggestedRadiusKm = valueDes;
          break;
        case r'at_maximum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.atMaximum = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'requires_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RadiusExpansion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RadiusExpansionBuilder();
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


