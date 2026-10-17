//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_classification.g.dart';

/// Fixed decision tree over the System Workflow thresholds. An indicator only: it changes no score, badge, ranking or sanction.
///
/// Properties:
/// * [class_]
/// * [label]
/// * [path]
/// * [bands]
@BuiltValue()
abstract class DashboardClassification implements Built<DashboardClassification, DashboardClassificationBuilder> {
  @BuiltValueField(wireName: r'class')
  DashboardClassificationClass_Enum get class_;
  // enum class_Enum {  BUILDING_TRACK_RECORD,  BELOW_WATCH_LEVEL,  WATCH,  HEALTHY,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'path')
  BuiltList<String> get path;

  @BuiltValueField(wireName: r'bands')
  BuiltMap<String, DashboardClassificationBandsEnum> get bands;
  // enum bandsEnum {  NONE,  LOW,  MEDIUM,  HIGH,  };

  DashboardClassification._();

  factory DashboardClassification([void updates(DashboardClassificationBuilder b)]) = _$DashboardClassification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardClassificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardClassification> get serializer => _$DashboardClassificationSerializer();
}

class _$DashboardClassificationSerializer implements PrimitiveSerializer<DashboardClassification> {
  @override
  final Iterable<Type> types = const [DashboardClassification, _$DashboardClassification];

  @override
  final String wireName = r'DashboardClassification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardClassification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(DashboardClassificationClass_Enum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'bands';
    yield serializers.serialize(
      object.bands,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(DashboardClassificationBandsEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardClassification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardClassificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardClassificationClass_Enum),
          ) as DashboardClassificationClass_Enum;
          result.class_ = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.path.replace(valueDes);
          break;
        case r'bands':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(DashboardClassificationBandsEnum)]),
          ) as BuiltMap<String, DashboardClassificationBandsEnum>;
          result.bands.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardClassification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardClassificationBuilder();
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


class DashboardClassificationClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUILDING_TRACK_RECORD')
  static const DashboardClassificationClass_Enum BUILDING_TRACK_RECORD = _$dashboardClassificationClassEnum_BUILDING_TRACK_RECORD;
  @BuiltValueEnumConst(wireName: r'BELOW_WATCH_LEVEL')
  static const DashboardClassificationClass_Enum BELOW_WATCH_LEVEL = _$dashboardClassificationClassEnum_BELOW_WATCH_LEVEL;
  @BuiltValueEnumConst(wireName: r'WATCH')
  static const DashboardClassificationClass_Enum WATCH = _$dashboardClassificationClassEnum_WATCH;
  @BuiltValueEnumConst(wireName: r'HEALTHY')
  static const DashboardClassificationClass_Enum HEALTHY = _$dashboardClassificationClassEnum_HEALTHY;

  static Serializer<DashboardClassificationClass_Enum> get serializer => _$dashboardClassificationClassEnumSerializer;

  const DashboardClassificationClass_Enum._(String name): super(name);

  static BuiltSet<DashboardClassificationClass_Enum> get values => _$dashboardClassificationClassEnumValues;
  static DashboardClassificationClass_Enum valueOf(String name) => _$dashboardClassificationClassEnumValueOf(name);
}

class DashboardClassificationBandsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const DashboardClassificationBandsEnum NONE = _$dashboardClassificationBandsEnum_NONE;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const DashboardClassificationBandsEnum LOW = _$dashboardClassificationBandsEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const DashboardClassificationBandsEnum MEDIUM = _$dashboardClassificationBandsEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const DashboardClassificationBandsEnum HIGH = _$dashboardClassificationBandsEnum_HIGH;

  static Serializer<DashboardClassificationBandsEnum> get serializer => _$dashboardClassificationBandsEnumSerializer;

  const DashboardClassificationBandsEnum._(String name): super(name);

  static BuiltSet<DashboardClassificationBandsEnum> get values => _$dashboardClassificationBandsEnumValues;
  static DashboardClassificationBandsEnum valueOf(String name) => _$dashboardClassificationBandsEnumValueOf(name);
}

