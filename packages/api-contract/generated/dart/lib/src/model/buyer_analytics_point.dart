//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_point.g.dart';

/// BuyerAnalyticsPoint
///
/// Properties:
/// * [date]
/// * [status]
/// * [label]
/// * [averagePhp] - Equal-Vendor mean, PHP per canonical unit
/// * [vendorCount]
/// * [participantsChanged]
@BuiltValue()
abstract class BuyerAnalyticsPoint implements Built<BuyerAnalyticsPoint, BuyerAnalyticsPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'status')
  BuyerAnalyticsPointStatusEnum get status;
  // enum statusEnum {  OK,  LIMITED_DATA,  NO_LOCAL_OBSERVATIONS,  SUPPRESSED,  MISSING_DAY,  };

  @BuiltValueField(wireName: r'label')
  String? get label;

  /// Equal-Vendor mean, PHP per canonical unit
  @BuiltValueField(wireName: r'average_php')
  String? get averagePhp;

  @BuiltValueField(wireName: r'vendor_count')
  int? get vendorCount;

  @BuiltValueField(wireName: r'participants_changed')
  bool? get participantsChanged;

  BuyerAnalyticsPoint._();

  factory BuyerAnalyticsPoint([void updates(BuyerAnalyticsPointBuilder b)]) = _$BuyerAnalyticsPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsPoint> get serializer => _$BuyerAnalyticsPointSerializer();
}

class _$BuyerAnalyticsPointSerializer implements PrimitiveSerializer<BuyerAnalyticsPoint> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsPoint, _$BuyerAnalyticsPoint];

  @override
  final String wireName = r'BuyerAnalyticsPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(BuyerAnalyticsPointStatusEnum),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.averagePhp != null) {
      yield r'average_php';
      yield serializers.serialize(
        object.averagePhp,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorCount != null) {
      yield r'vendor_count';
      yield serializers.serialize(
        object.vendorCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.participantsChanged != null) {
      yield r'participants_changed';
      yield serializers.serialize(
        object.participantsChanged,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsPointStatusEnum),
          ) as BuyerAnalyticsPointStatusEnum;
          result.status = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'average_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.averagePhp = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorCount = valueDes;
          break;
        case r'participants_changed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.participantsChanged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsPointBuilder();
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


class BuyerAnalyticsPointStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const BuyerAnalyticsPointStatusEnum OK = _$buyerAnalyticsPointStatusEnum_OK;
  @BuiltValueEnumConst(wireName: r'LIMITED_DATA')
  static const BuyerAnalyticsPointStatusEnum LIMITED_DATA = _$buyerAnalyticsPointStatusEnum_LIMITED_DATA;
  @BuiltValueEnumConst(wireName: r'NO_LOCAL_OBSERVATIONS')
  static const BuyerAnalyticsPointStatusEnum NO_LOCAL_OBSERVATIONS = _$buyerAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS;
  @BuiltValueEnumConst(wireName: r'SUPPRESSED')
  static const BuyerAnalyticsPointStatusEnum SUPPRESSED = _$buyerAnalyticsPointStatusEnum_SUPPRESSED;
  @BuiltValueEnumConst(wireName: r'MISSING_DAY')
  static const BuyerAnalyticsPointStatusEnum MISSING_DAY = _$buyerAnalyticsPointStatusEnum_MISSING_DAY;

  static Serializer<BuyerAnalyticsPointStatusEnum> get serializer => _$buyerAnalyticsPointStatusEnumSerializer;

  const BuyerAnalyticsPointStatusEnum._(String name): super(name);

  static BuiltSet<BuyerAnalyticsPointStatusEnum> get values => _$buyerAnalyticsPointStatusEnumValues;
  static BuyerAnalyticsPointStatusEnum valueOf(String name) => _$buyerAnalyticsPointStatusEnumValueOf(name);
}

