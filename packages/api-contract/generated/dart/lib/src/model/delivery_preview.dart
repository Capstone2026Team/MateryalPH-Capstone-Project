//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart_issue.dart';
import 'package:materyalph_api_client/src/model/delivery_route.dart';
import 'package:materyalph_api_client/src/model/delivery_estimate.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_preview.g.dart';

/// DeliveryPreview
///
/// Properties:
/// * [status]
/// * [issues]
/// * [endpoint]
/// * [route]
/// * [straightLineMeters]
/// * [coverageKm]
/// * [estimate]
/// * [manualReviewReasons]
/// * [confirmedOffer] - Always null in a preview; an authorized confirmed offer exists only after Vendor confirmation.
/// * [calculationVersion]
/// * [notice]
@BuiltValue()
abstract class DeliveryPreview implements Built<DeliveryPreview, DeliveryPreviewBuilder> {
  @BuiltValueField(wireName: r'status')
  DeliveryPreviewStatusEnum get status;
  // enum statusEnum {  NOT_APPLICABLE,  ACTION_REQUIRED,  BLOCKED,  MANUAL_REVIEW,  ADVISORY_ESTIMATE,  };

  @BuiltValueField(wireName: r'issues')
  BuiltList<CartIssue> get issues;

  @BuiltValueField(wireName: r'endpoint')
  DeliveryPreviewEndpointEnum? get endpoint;
  // enum endpointEnum {  INTENDED_LOCATION,  ALTERNATE_DROP_OFF,  ,  };

  @BuiltValueField(wireName: r'route')
  DeliveryRoute? get route;

  @BuiltValueField(wireName: r'straight_line_meters')
  int? get straightLineMeters;

  @BuiltValueField(wireName: r'coverage_km')
  int? get coverageKm;

  @BuiltValueField(wireName: r'estimate')
  DeliveryEstimate? get estimate;

  @BuiltValueField(wireName: r'manual_review_reasons')
  BuiltList<String> get manualReviewReasons;

  /// Always null in a preview; an authorized confirmed offer exists only after Vendor confirmation.
  @BuiltValueField(wireName: r'confirmed_offer')
  BuiltMap<String, JsonObject?>? get confirmedOffer;

  @BuiltValueField(wireName: r'calculation_version')
  String get calculationVersion;

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  DeliveryPreview._();

  factory DeliveryPreview([void updates(DeliveryPreviewBuilder b)]) = _$DeliveryPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPreview> get serializer => _$DeliveryPreviewSerializer();
}

class _$DeliveryPreviewSerializer implements PrimitiveSerializer<DeliveryPreview> {
  @override
  final Iterable<Type> types = const [DeliveryPreview, _$DeliveryPreview];

  @override
  final String wireName = r'DeliveryPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DeliveryPreviewStatusEnum),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
    );
    yield r'endpoint';
    yield object.endpoint == null ? null : serializers.serialize(
      object.endpoint,
      specifiedType: const FullType.nullable(DeliveryPreviewEndpointEnum),
    );
    yield r'route';
    yield object.route == null ? null : serializers.serialize(
      object.route,
      specifiedType: const FullType.nullable(DeliveryRoute),
    );
    yield r'straight_line_meters';
    yield object.straightLineMeters == null ? null : serializers.serialize(
      object.straightLineMeters,
      specifiedType: const FullType.nullable(int),
    );
    yield r'coverage_km';
    yield object.coverageKm == null ? null : serializers.serialize(
      object.coverageKm,
      specifiedType: const FullType.nullable(int),
    );
    yield r'estimate';
    yield object.estimate == null ? null : serializers.serialize(
      object.estimate,
      specifiedType: const FullType.nullable(DeliveryEstimate),
    );
    yield r'manual_review_reasons';
    yield serializers.serialize(
      object.manualReviewReasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'confirmed_offer';
    yield object.confirmedOffer == null ? null : serializers.serialize(
      object.confirmedOffer,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'calculation_version';
    yield serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType(String),
    );
    yield r'notice';
    yield object.notice == null ? null : serializers.serialize(
      object.notice,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPreviewStatusEnum),
          ) as DeliveryPreviewStatusEnum;
          result.status = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
          ) as BuiltList<CartIssue>;
          result.issues.replace(valueDes);
          break;
        case r'endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryPreviewEndpointEnum),
          ) as DeliveryPreviewEndpointEnum?;
          if (valueDes == null) continue;
          result.endpoint = valueDes;
          break;
        case r'route':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryRoute),
          ) as DeliveryRoute?;
          if (valueDes == null) continue;
          result.route.replace(valueDes);
          break;
        case r'straight_line_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.straightLineMeters = valueDes;
          break;
        case r'coverage_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.coverageKm = valueDes;
          break;
        case r'estimate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryEstimate),
          ) as DeliveryEstimate?;
          if (valueDes == null) continue;
          result.estimate.replace(valueDes);
          break;
        case r'manual_review_reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.manualReviewReasons.replace(valueDes);
          break;
        case r'confirmed_offer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.confirmedOffer.replace(valueDes);
          break;
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationVersion = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPreviewBuilder();
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


class DeliveryPreviewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const DeliveryPreviewStatusEnum NOT_APPLICABLE = _$deliveryPreviewStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'ACTION_REQUIRED')
  static const DeliveryPreviewStatusEnum ACTION_REQUIRED = _$deliveryPreviewStatusEnum_ACTION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const DeliveryPreviewStatusEnum BLOCKED = _$deliveryPreviewStatusEnum_BLOCKED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REVIEW')
  static const DeliveryPreviewStatusEnum MANUAL_REVIEW = _$deliveryPreviewStatusEnum_MANUAL_REVIEW;
  @BuiltValueEnumConst(wireName: r'ADVISORY_ESTIMATE')
  static const DeliveryPreviewStatusEnum ADVISORY_ESTIMATE = _$deliveryPreviewStatusEnum_ADVISORY_ESTIMATE;

  static Serializer<DeliveryPreviewStatusEnum> get serializer => _$deliveryPreviewStatusEnumSerializer;

  const DeliveryPreviewStatusEnum._(String name): super(name);

  static BuiltSet<DeliveryPreviewStatusEnum> get values => _$deliveryPreviewStatusEnumValues;
  static DeliveryPreviewStatusEnum valueOf(String name) => _$deliveryPreviewStatusEnumValueOf(name);
}

class DeliveryPreviewEndpointEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTENDED_LOCATION')
  static const DeliveryPreviewEndpointEnum INTENDED_LOCATION = _$deliveryPreviewEndpointEnum_INTENDED_LOCATION;
  @BuiltValueEnumConst(wireName: r'ALTERNATE_DROP_OFF')
  static const DeliveryPreviewEndpointEnum ALTERNATE_DROP_OFF = _$deliveryPreviewEndpointEnum_ALTERNATE_DROP_OFF;

  static Serializer<DeliveryPreviewEndpointEnum> get serializer => _$deliveryPreviewEndpointEnumSerializer;

  const DeliveryPreviewEndpointEnum._(String name): super(name);

  static BuiltSet<DeliveryPreviewEndpointEnum> get values => _$deliveryPreviewEndpointEnumValues;
  static DeliveryPreviewEndpointEnum valueOf(String name) => _$deliveryPreviewEndpointEnumValueOf(name);
}

