//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_vehicle_issue.g.dart';

/// FulfillmentVehicleIssue
///
/// Properties:
/// * [category]
/// * [description]
/// * [reportedAt]
/// * [actorRole]
@BuiltValue()
abstract class FulfillmentVehicleIssue implements Built<FulfillmentVehicleIssue, FulfillmentVehicleIssueBuilder> {
  @BuiltValueField(wireName: r'category')
  FulfillmentVehicleIssueCategoryEnum get category;
  // enum categoryEnum {  BREAKDOWN,  CAPACITY_SHORTFALL,  ACCESS_BLOCKED,  DELAY,  OTHER,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'reported_at')
  DateTime? get reportedAt;

  @BuiltValueField(wireName: r'actor_role')
  String? get actorRole;

  FulfillmentVehicleIssue._();

  factory FulfillmentVehicleIssue([void updates(FulfillmentVehicleIssueBuilder b)]) = _$FulfillmentVehicleIssue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentVehicleIssueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentVehicleIssue> get serializer => _$FulfillmentVehicleIssueSerializer();
}

class _$FulfillmentVehicleIssueSerializer implements PrimitiveSerializer<FulfillmentVehicleIssue> {
  @override
  final Iterable<Type> types = const [FulfillmentVehicleIssue, _$FulfillmentVehicleIssue];

  @override
  final String wireName = r'FulfillmentVehicleIssue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentVehicleIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(FulfillmentVehicleIssueCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.reportedAt != null) {
      yield r'reported_at';
      yield serializers.serialize(
        object.reportedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.actorRole != null) {
      yield r'actor_role';
      yield serializers.serialize(
        object.actorRole,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentVehicleIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentVehicleIssueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentVehicleIssueCategoryEnum),
          ) as FulfillmentVehicleIssueCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'reported_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reportedAt = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentVehicleIssue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentVehicleIssueBuilder();
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


class FulfillmentVehicleIssueCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BREAKDOWN')
  static const FulfillmentVehicleIssueCategoryEnum BREAKDOWN = _$fulfillmentVehicleIssueCategoryEnum_BREAKDOWN;
  @BuiltValueEnumConst(wireName: r'CAPACITY_SHORTFALL')
  static const FulfillmentVehicleIssueCategoryEnum CAPACITY_SHORTFALL = _$fulfillmentVehicleIssueCategoryEnum_CAPACITY_SHORTFALL;
  @BuiltValueEnumConst(wireName: r'ACCESS_BLOCKED')
  static const FulfillmentVehicleIssueCategoryEnum ACCESS_BLOCKED = _$fulfillmentVehicleIssueCategoryEnum_ACCESS_BLOCKED;
  @BuiltValueEnumConst(wireName: r'DELAY')
  static const FulfillmentVehicleIssueCategoryEnum DELAY = _$fulfillmentVehicleIssueCategoryEnum_DELAY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const FulfillmentVehicleIssueCategoryEnum OTHER = _$fulfillmentVehicleIssueCategoryEnum_OTHER;

  static Serializer<FulfillmentVehicleIssueCategoryEnum> get serializer => _$fulfillmentVehicleIssueCategoryEnumSerializer;

  const FulfillmentVehicleIssueCategoryEnum._(String name): super(name);

  static BuiltSet<FulfillmentVehicleIssueCategoryEnum> get values => _$fulfillmentVehicleIssueCategoryEnumValues;
  static FulfillmentVehicleIssueCategoryEnum valueOf(String name) => _$fulfillmentVehicleIssueCategoryEnumValueOf(name);
}

