//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/directory_supplier_summary.dart';
import 'package:materyalph_api_client/src/model/score_label.dart';
import 'package:materyalph_api_client/src/model/map_point.dart';
import 'package:materyalph_api_client/src/model/supplier_tier.dart';
import 'package:materyalph_api_client/src/model/verified_vendor_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supplier_result.g.dart';

/// SupplierResult
///
/// Properties:
/// * [resultId]
/// * [tier]
/// * [tierLabel]
/// * [rank]
/// * [name] - Canonical Public Store Name for Tier 2; Google display name for Tier 1.
/// * [marker]
/// * [distanceMeters] - Geodesic straight-line distance; never a route distance.
/// * [scoreLabel]
/// * [isFavorite]
/// * [vendor]
/// * [directory]
@BuiltValue()
abstract class SupplierResult implements Built<SupplierResult, SupplierResultBuilder> {
  @BuiltValueField(wireName: r'result_id')
  String get resultId;

  @BuiltValueField(wireName: r'tier')
  SupplierTier get tier;
  // enum tierEnum {  VERIFIED_VENDOR,  DIRECTORY_SUPPLIER,  };

  @BuiltValueField(wireName: r'tier_label')
  String get tierLabel;

  @BuiltValueField(wireName: r'rank')
  int get rank;

  /// Canonical Public Store Name for Tier 2; Google display name for Tier 1.
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'marker')
  MapPoint get marker;

  /// Geodesic straight-line distance; never a route distance.
  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'score_label')
  ScoreLabel get scoreLabel;

  @BuiltValueField(wireName: r'is_favorite')
  bool get isFavorite;

  @BuiltValueField(wireName: r'vendor')
  VerifiedVendorSummary? get vendor;

  @BuiltValueField(wireName: r'directory')
  DirectorySupplierSummary? get directory;

  SupplierResult._();

  factory SupplierResult([void updates(SupplierResultBuilder b)]) = _$SupplierResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupplierResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupplierResult> get serializer => _$SupplierResultSerializer();
}

class _$SupplierResultSerializer implements PrimitiveSerializer<SupplierResult> {
  @override
  final Iterable<Type> types = const [SupplierResult, _$SupplierResult];

  @override
  final String wireName = r'SupplierResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupplierResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'result_id';
    yield serializers.serialize(
      object.resultId,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(SupplierTier),
    );
    yield r'tier_label';
    yield serializers.serialize(
      object.tierLabel,
      specifiedType: const FullType(String),
    );
    yield r'rank';
    yield serializers.serialize(
      object.rank,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'marker';
    yield serializers.serialize(
      object.marker,
      specifiedType: const FullType(MapPoint),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'score_label';
    yield serializers.serialize(
      object.scoreLabel,
      specifiedType: const FullType(ScoreLabel),
    );
    yield r'is_favorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
    yield r'vendor';
    yield object.vendor == null ? null : serializers.serialize(
      object.vendor,
      specifiedType: const FullType.nullable(VerifiedVendorSummary),
    );
    yield r'directory';
    yield object.directory == null ? null : serializers.serialize(
      object.directory,
      specifiedType: const FullType.nullable(DirectorySupplierSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupplierResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupplierResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resultId = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierTier),
          ) as SupplierTier;
          result.tier = valueDes;
          break;
        case r'tier_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tierLabel = valueDes;
          break;
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rank = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'marker':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MapPoint),
          ) as MapPoint;
          result.marker.replace(valueDes);
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'score_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreLabel),
          ) as ScoreLabel;
          result.scoreLabel.replace(valueDes);
          break;
        case r'is_favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VerifiedVendorSummary),
          ) as VerifiedVendorSummary?;
          if (valueDes == null) continue;
          result.vendor.replace(valueDes);
          break;
        case r'directory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DirectorySupplierSummary),
          ) as DirectorySupplierSummary?;
          if (valueDes == null) continue;
          result.directory.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupplierResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupplierResultBuilder();
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


