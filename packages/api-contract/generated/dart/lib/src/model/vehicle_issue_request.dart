//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle_issue_request.g.dart';

/// VehicleIssueRequest
///
/// Properties:
/// * [category]
/// * [description]
@BuiltValue()
abstract class VehicleIssueRequest implements Built<VehicleIssueRequest, VehicleIssueRequestBuilder> {
  @BuiltValueField(wireName: r'category')
  VehicleIssueRequestCategoryEnum get category;
  // enum categoryEnum {  BREAKDOWN,  CAPACITY_SHORTFALL,  ACCESS_BLOCKED,  DELAY,  OTHER,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  VehicleIssueRequest._();

  factory VehicleIssueRequest([void updates(VehicleIssueRequestBuilder b)]) = _$VehicleIssueRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VehicleIssueRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VehicleIssueRequest> get serializer => _$VehicleIssueRequestSerializer();
}

class _$VehicleIssueRequestSerializer implements PrimitiveSerializer<VehicleIssueRequest> {
  @override
  final Iterable<Type> types = const [VehicleIssueRequest, _$VehicleIssueRequest];

  @override
  final String wireName = r'VehicleIssueRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VehicleIssueRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(VehicleIssueRequestCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VehicleIssueRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VehicleIssueRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VehicleIssueRequestCategoryEnum),
          ) as VehicleIssueRequestCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VehicleIssueRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VehicleIssueRequestBuilder();
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


class VehicleIssueRequestCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BREAKDOWN')
  static const VehicleIssueRequestCategoryEnum BREAKDOWN = _$vehicleIssueRequestCategoryEnum_BREAKDOWN;
  @BuiltValueEnumConst(wireName: r'CAPACITY_SHORTFALL')
  static const VehicleIssueRequestCategoryEnum CAPACITY_SHORTFALL = _$vehicleIssueRequestCategoryEnum_CAPACITY_SHORTFALL;
  @BuiltValueEnumConst(wireName: r'ACCESS_BLOCKED')
  static const VehicleIssueRequestCategoryEnum ACCESS_BLOCKED = _$vehicleIssueRequestCategoryEnum_ACCESS_BLOCKED;
  @BuiltValueEnumConst(wireName: r'DELAY')
  static const VehicleIssueRequestCategoryEnum DELAY = _$vehicleIssueRequestCategoryEnum_DELAY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VehicleIssueRequestCategoryEnum OTHER = _$vehicleIssueRequestCategoryEnum_OTHER;

  static Serializer<VehicleIssueRequestCategoryEnum> get serializer => _$vehicleIssueRequestCategoryEnumSerializer;

  const VehicleIssueRequestCategoryEnum._(String name): super(name);

  static BuiltSet<VehicleIssueRequestCategoryEnum> get values => _$vehicleIssueRequestCategoryEnumValues;
  static VehicleIssueRequestCategoryEnum valueOf(String name) => _$vehicleIssueRequestCategoryEnumValueOf(name);
}

