//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ranking_component.g.dart';

/// RankingComponent
///
/// Properties:
/// * [key]
/// * [label]
/// * [weightPercent]
/// * [score] - Normalized 0–100 component score
/// * [weighted] - score × weight / 100
/// * [basis] - Plain-language source of the score
@BuiltValue()
abstract class RankingComponent implements Built<RankingComponent, RankingComponentBuilder> {
  @BuiltValueField(wireName: r'key')
  RankingComponentKeyEnum get key;
  // enum keyEnum {  distance,  price,  vps,  stock,  product_rating,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'weight_percent')
  int get weightPercent;

  /// Normalized 0–100 component score
  @BuiltValueField(wireName: r'score')
  String get score;

  /// score × weight / 100
  @BuiltValueField(wireName: r'weighted')
  String get weighted;

  /// Plain-language source of the score
  @BuiltValueField(wireName: r'basis')
  String get basis;

  RankingComponent._();

  factory RankingComponent([void updates(RankingComponentBuilder b)]) = _$RankingComponent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankingComponentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankingComponent> get serializer => _$RankingComponentSerializer();
}

class _$RankingComponentSerializer implements PrimitiveSerializer<RankingComponent> {
  @override
  final Iterable<Type> types = const [RankingComponent, _$RankingComponent];

  @override
  final String wireName = r'RankingComponent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankingComponent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(RankingComponentKeyEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'weight_percent';
    yield serializers.serialize(
      object.weightPercent,
      specifiedType: const FullType(int),
    );
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(String),
    );
    yield r'weighted';
    yield serializers.serialize(
      object.weighted,
      specifiedType: const FullType(String),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankingComponent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RankingComponentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingComponentKeyEnum),
          ) as RankingComponentKeyEnum;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'weight_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.weightPercent = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.score = valueDes;
          break;
        case r'weighted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.weighted = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.basis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RankingComponent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankingComponentBuilder();
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


class RankingComponentKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'distance')
  static const RankingComponentKeyEnum distance = _$rankingComponentKeyEnum_distance;
  @BuiltValueEnumConst(wireName: r'price')
  static const RankingComponentKeyEnum price = _$rankingComponentKeyEnum_price;
  @BuiltValueEnumConst(wireName: r'vps')
  static const RankingComponentKeyEnum vps = _$rankingComponentKeyEnum_vps;
  @BuiltValueEnumConst(wireName: r'stock')
  static const RankingComponentKeyEnum stock = _$rankingComponentKeyEnum_stock;
  @BuiltValueEnumConst(wireName: r'product_rating')
  static const RankingComponentKeyEnum productRating = _$rankingComponentKeyEnum_productRating;

  static Serializer<RankingComponentKeyEnum> get serializer => _$rankingComponentKeyEnumSerializer;

  const RankingComponentKeyEnum._(String name): super(name);

  static BuiltSet<RankingComponentKeyEnum> get values => _$rankingComponentKeyEnumValues;
  static RankingComponentKeyEnum valueOf(String name) => _$rankingComponentKeyEnumValueOf(name);
}

