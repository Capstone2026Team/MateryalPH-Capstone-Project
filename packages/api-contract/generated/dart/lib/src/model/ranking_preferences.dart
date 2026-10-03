//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/ranking_weight_set.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ranking_preferences.g.dart';

/// RankingPreferences
///
/// Properties:
/// * [procurementType]
/// * [weights]
/// * [defaultWeights]
/// * [defaultsVersion]
/// * [personalized] - True while a Buyer override is stored.
/// * [version] - 0 when following the platform defaults.
/// * [totalPercent]
/// * [algorithmVersion]
@BuiltValue()
abstract class RankingPreferences implements Built<RankingPreferences, RankingPreferencesBuilder> {
  @BuiltValueField(wireName: r'procurement_type')
  RankingPreferencesProcurementTypeEnum get procurementType;
  // enum procurementTypeEnum {  ITEM_BASED,  };

  @BuiltValueField(wireName: r'weights')
  RankingWeightSet get weights;

  @BuiltValueField(wireName: r'default_weights')
  RankingWeightSet get defaultWeights;

  @BuiltValueField(wireName: r'defaults_version')
  int get defaultsVersion;

  /// True while a Buyer override is stored.
  @BuiltValueField(wireName: r'personalized')
  bool get personalized;

  /// 0 when following the platform defaults.
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'total_percent')
  RankingPreferencesTotalPercentEnum get totalPercent;
  // enum totalPercentEnum {  100,  };

  @BuiltValueField(wireName: r'algorithm_version')
  String get algorithmVersion;

  RankingPreferences._();

  factory RankingPreferences([void updates(RankingPreferencesBuilder b)]) = _$RankingPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankingPreferencesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankingPreferences> get serializer => _$RankingPreferencesSerializer();
}

class _$RankingPreferencesSerializer implements PrimitiveSerializer<RankingPreferences> {
  @override
  final Iterable<Type> types = const [RankingPreferences, _$RankingPreferences];

  @override
  final String wireName = r'RankingPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankingPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'procurement_type';
    yield serializers.serialize(
      object.procurementType,
      specifiedType: const FullType(RankingPreferencesProcurementTypeEnum),
    );
    yield r'weights';
    yield serializers.serialize(
      object.weights,
      specifiedType: const FullType(RankingWeightSet),
    );
    yield r'default_weights';
    yield serializers.serialize(
      object.defaultWeights,
      specifiedType: const FullType(RankingWeightSet),
    );
    yield r'defaults_version';
    yield serializers.serialize(
      object.defaultsVersion,
      specifiedType: const FullType(int),
    );
    yield r'personalized';
    yield serializers.serialize(
      object.personalized,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'total_percent';
    yield serializers.serialize(
      object.totalPercent,
      specifiedType: const FullType(RankingPreferencesTotalPercentEnum),
    );
    yield r'algorithm_version';
    yield serializers.serialize(
      object.algorithmVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankingPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RankingPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'procurement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingPreferencesProcurementTypeEnum),
          ) as RankingPreferencesProcurementTypeEnum;
          result.procurementType = valueDes;
          break;
        case r'weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingWeightSet),
          ) as RankingWeightSet;
          result.weights.replace(valueDes);
          break;
        case r'default_weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingWeightSet),
          ) as RankingWeightSet;
          result.defaultWeights.replace(valueDes);
          break;
        case r'defaults_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.defaultsVersion = valueDes;
          break;
        case r'personalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.personalized = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'total_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingPreferencesTotalPercentEnum),
          ) as RankingPreferencesTotalPercentEnum;
          result.totalPercent = valueDes;
          break;
        case r'algorithm_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.algorithmVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RankingPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankingPreferencesBuilder();
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


class RankingPreferencesProcurementTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const RankingPreferencesProcurementTypeEnum ITEM_BASED = _$rankingPreferencesProcurementTypeEnum_ITEM_BASED;

  static Serializer<RankingPreferencesProcurementTypeEnum> get serializer => _$rankingPreferencesProcurementTypeEnumSerializer;

  const RankingPreferencesProcurementTypeEnum._(String name): super(name);

  static BuiltSet<RankingPreferencesProcurementTypeEnum> get values => _$rankingPreferencesProcurementTypeEnumValues;
  static RankingPreferencesProcurementTypeEnum valueOf(String name) => _$rankingPreferencesProcurementTypeEnumValueOf(name);
}

class RankingPreferencesTotalPercentEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 100)
  static const RankingPreferencesTotalPercentEnum number100 = _$rankingPreferencesTotalPercentEnum_number100;

  static Serializer<RankingPreferencesTotalPercentEnum> get serializer => _$rankingPreferencesTotalPercentEnumSerializer;

  const RankingPreferencesTotalPercentEnum._(String name): super(name);

  static BuiltSet<RankingPreferencesTotalPercentEnum> get values => _$rankingPreferencesTotalPercentEnumValues;
  static RankingPreferencesTotalPercentEnum valueOf(String name) => _$rankingPreferencesTotalPercentEnumValueOf(name);
}

