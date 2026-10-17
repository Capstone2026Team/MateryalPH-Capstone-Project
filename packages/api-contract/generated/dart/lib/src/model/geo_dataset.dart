//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_dataset.g.dart';

/// GeoDataset
///
/// Properties:
/// * [environment]
/// * [label]
/// * [demo]
/// * [lastAggregatedAt]
/// * [throughDate]
/// * [revision]
/// * [available]
@BuiltValue()
abstract class GeoDataset implements Built<GeoDataset, GeoDatasetBuilder> {
  @BuiltValueField(wireName: r'environment')
  GeoDatasetEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  DEMO,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'demo')
  bool get demo;

  @BuiltValueField(wireName: r'last_aggregated_at')
  DateTime? get lastAggregatedAt;

  @BuiltValueField(wireName: r'through_date')
  String? get throughDate;

  @BuiltValueField(wireName: r'revision')
  int? get revision;

  @BuiltValueField(wireName: r'available')
  bool get available;

  GeoDataset._();

  factory GeoDataset([void updates(GeoDatasetBuilder b)]) = _$GeoDataset;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDatasetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDataset> get serializer => _$GeoDatasetSerializer();
}

class _$GeoDatasetSerializer implements PrimitiveSerializer<GeoDataset> {
  @override
  final Iterable<Type> types = const [GeoDataset, _$GeoDataset];

  @override
  final String wireName = r'GeoDataset';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDataset object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(GeoDatasetEnvironmentEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'demo';
    yield serializers.serialize(
      object.demo,
      specifiedType: const FullType(bool),
    );
    if (object.lastAggregatedAt != null) {
      yield r'last_aggregated_at';
      yield serializers.serialize(
        object.lastAggregatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.throughDate != null) {
      yield r'through_date';
      yield serializers.serialize(
        object.throughDate,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.revision != null) {
      yield r'revision';
      yield serializers.serialize(
        object.revision,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDataset object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDatasetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDatasetEnvironmentEnum),
          ) as GeoDatasetEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demo = valueDes;
          break;
        case r'last_aggregated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastAggregatedAt = valueDes;
          break;
        case r'through_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.throughDate = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.revision = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDataset deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDatasetBuilder();
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


class GeoDatasetEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const GeoDatasetEnvironmentEnum TEST = _$geoDatasetEnvironmentEnum_TEST;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const GeoDatasetEnvironmentEnum DEMO = _$geoDatasetEnvironmentEnum_DEMO;

  static Serializer<GeoDatasetEnvironmentEnum> get serializer => _$geoDatasetEnvironmentEnumSerializer;

  const GeoDatasetEnvironmentEnum._(String name): super(name);

  static BuiltSet<GeoDatasetEnvironmentEnum> get values => _$geoDatasetEnvironmentEnumValues;
  static GeoDatasetEnvironmentEnum valueOf(String name) => _$geoDatasetEnvironmentEnumValueOf(name);
}

