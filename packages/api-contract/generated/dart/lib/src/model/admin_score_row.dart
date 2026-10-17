//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/public_scores.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_score_row.g.dart';

/// AdminScoreRow
///
/// Properties:
/// * [vendorId]
/// * [storeName]
/// * [scores]
/// * [crr]
/// * [frr]
/// * [sampleCounts]
/// * [activeSuppressions]
/// * [activeExclusions]
@BuiltValue()
abstract class AdminScoreRow implements Built<AdminScoreRow, AdminScoreRowBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'scores')
  PublicScores get scores;

  @BuiltValueField(wireName: r'crr')
  String? get crr;

  @BuiltValueField(wireName: r'frr')
  String? get frr;

  @BuiltValueField(wireName: r'sample_counts')
  BuiltMap<String, JsonObject?> get sampleCounts;

  @BuiltValueField(wireName: r'active_suppressions')
  int get activeSuppressions;

  @BuiltValueField(wireName: r'active_exclusions')
  int get activeExclusions;

  AdminScoreRow._();

  factory AdminScoreRow([void updates(AdminScoreRowBuilder b)]) = _$AdminScoreRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminScoreRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminScoreRow> get serializer => _$AdminScoreRowSerializer();
}

class _$AdminScoreRowSerializer implements PrimitiveSerializer<AdminScoreRow> {
  @override
  final Iterable<Type> types = const [AdminScoreRow, _$AdminScoreRow];

  @override
  final String wireName = r'AdminScoreRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminScoreRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'scores';
    yield serializers.serialize(
      object.scores,
      specifiedType: const FullType(PublicScores),
    );
    if (object.crr != null) {
      yield r'crr';
      yield serializers.serialize(
        object.crr,
        specifiedType: const FullType(String),
      );
    }
    if (object.frr != null) {
      yield r'frr';
      yield serializers.serialize(
        object.frr,
        specifiedType: const FullType(String),
      );
    }
    yield r'sample_counts';
    yield serializers.serialize(
      object.sampleCounts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'active_suppressions';
    yield serializers.serialize(
      object.activeSuppressions,
      specifiedType: const FullType(int),
    );
    yield r'active_exclusions';
    yield serializers.serialize(
      object.activeExclusions,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminScoreRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminScoreRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'scores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicScores),
          ) as PublicScores;
          result.scores.replace(valueDes);
          break;
        case r'crr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.crr = valueDes;
          break;
        case r'frr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.frr = valueDes;
          break;
        case r'sample_counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.sampleCounts.replace(valueDes);
          break;
        case r'active_suppressions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeSuppressions = valueDes;
          break;
        case r'active_exclusions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeExclusions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminScoreRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminScoreRowBuilder();
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


