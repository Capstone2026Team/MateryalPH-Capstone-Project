//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/radius_expansion.dart';
import 'package:materyalph_api_client/src/model/directory_availability.dart';
import 'package:materyalph_api_client/src/model/discovery_scope.dart';
import 'package:materyalph_api_client/src/model/discovery_counts.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_search_meta.g.dart';

/// DiscoverySearchMeta
///
/// Properties:
/// * [correlationId]
/// * [scope]
/// * [currentAsOf]
/// * [eligibilityVersion]
/// * [projectionVersion]
/// * [counts]
/// * [directory]
/// * [expansion]
/// * [page]
/// * [perPage]
/// * [total]
/// * [hasMore]
@BuiltValue()
abstract class DiscoverySearchMeta implements Built<DiscoverySearchMeta, DiscoverySearchMetaBuilder> {
  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  @BuiltValueField(wireName: r'scope')
  DiscoveryScope get scope;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'eligibility_version')
  String get eligibilityVersion;

  @BuiltValueField(wireName: r'projection_version')
  String get projectionVersion;

  @BuiltValueField(wireName: r'counts')
  DiscoveryCounts get counts;

  @BuiltValueField(wireName: r'directory')
  DirectoryAvailability get directory;

  @BuiltValueField(wireName: r'expansion')
  RadiusExpansion get expansion;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  DiscoverySearchMeta._();

  factory DiscoverySearchMeta([void updates(DiscoverySearchMetaBuilder b)]) = _$DiscoverySearchMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoverySearchMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoverySearchMeta> get serializer => _$DiscoverySearchMetaSerializer();
}

class _$DiscoverySearchMetaSerializer implements PrimitiveSerializer<DiscoverySearchMeta> {
  @override
  final Iterable<Type> types = const [DiscoverySearchMeta, _$DiscoverySearchMeta];

  @override
  final String wireName = r'DiscoverySearchMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoverySearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(DiscoveryScope),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'eligibility_version';
    yield serializers.serialize(
      object.eligibilityVersion,
      specifiedType: const FullType(String),
    );
    yield r'projection_version';
    yield serializers.serialize(
      object.projectionVersion,
      specifiedType: const FullType(String),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(DiscoveryCounts),
    );
    yield r'directory';
    yield serializers.serialize(
      object.directory,
      specifiedType: const FullType(DirectoryAvailability),
    );
    yield r'expansion';
    yield serializers.serialize(
      object.expansion,
      specifiedType: const FullType(RadiusExpansion),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DiscoverySearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoverySearchMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScope),
          ) as DiscoveryScope;
          result.scope.replace(valueDes);
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'eligibility_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eligibilityVersion = valueDes;
          break;
        case r'projection_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.projectionVersion = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryCounts),
          ) as DiscoveryCounts;
          result.counts.replace(valueDes);
          break;
        case r'directory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryAvailability),
          ) as DirectoryAvailability;
          result.directory.replace(valueDes);
          break;
        case r'expansion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RadiusExpansion),
          ) as RadiusExpansion;
          result.expansion.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiscoverySearchMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoverySearchMetaBuilder();
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


