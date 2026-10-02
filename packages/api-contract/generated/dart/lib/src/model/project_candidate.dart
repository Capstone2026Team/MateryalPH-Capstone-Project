//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_candidate.g.dart';

/// ProjectCandidate
///
/// Properties:
/// * [id]
/// * [estimateId]
/// * [vendorId]
/// * [storeName]
/// * [rank]
/// * [latitude]
/// * [longitude]
/// * [scoreLabel]
/// * [vps]
/// * [fms]
/// * [complete]
/// * [fulfillmentPercent]
/// * [missingLines]
/// * [lines]
/// * [materialsCentavos]
/// * [includedVatCentavos]
/// * [deliveryCentavos]
/// * [processingFeeCentavos]
/// * [processingFeeStatus]
/// * [projectedTotalCentavos]
/// * [budgetLabel]
/// * [distanceMeters]
/// * [distanceBasis]
/// * [etaSeconds]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [delivery]
/// * [destination]
/// * [expiresAt]
/// * [stale]
/// * [label]
/// * [currentQuotationState]
@BuiltValue()
abstract class ProjectCandidate implements Built<ProjectCandidate, ProjectCandidateBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'estimate_id')
  String get estimateId;

  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'rank')
  int get rank;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'score_label')
  String get scoreLabel;

  @BuiltValueField(wireName: r'vps')
  String? get vps;

  @BuiltValueField(wireName: r'fms')
  BuiltMap<String, JsonObject?> get fms;

  @BuiltValueField(wireName: r'complete')
  bool get complete;

  @BuiltValueField(wireName: r'fulfillment_percent')
  String get fulfillmentPercent;

  @BuiltValueField(wireName: r'missing_lines')
  BuiltList<BuiltMap<String, JsonObject?>> get missingLines;

  @BuiltValueField(wireName: r'lines')
  BuiltList<BuiltMap<String, JsonObject?>> get lines;

  @BuiltValueField(wireName: r'materials_centavos')
  int get materialsCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'processing_fee_centavos')
  int? get processingFeeCentavos;

  @BuiltValueField(wireName: r'processing_fee_status')
  String get processingFeeStatus;

  @BuiltValueField(wireName: r'projected_total_centavos')
  int? get projectedTotalCentavos;

  @BuiltValueField(wireName: r'budget_label')
  String get budgetLabel;

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'distance_basis')
  String get distanceBasis;

  @BuiltValueField(wireName: r'eta_seconds')
  int? get etaSeconds;

  @BuiltValueField(wireName: r'fulfillment_method')
  String get fulfillmentMethod;

  @BuiltValueField(wireName: r'payment_method')
  String get paymentMethod;

  @BuiltValueField(wireName: r'delivery')
  BuiltMap<String, JsonObject?> get delivery;

  @BuiltValueField(wireName: r'destination')
  BuiltMap<String, JsonObject?> get destination;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  @BuiltValueField(wireName: r'stale')
  bool get stale;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'current_quotation_state')
  String get currentQuotationState;

  ProjectCandidate._();

  factory ProjectCandidate([void updates(ProjectCandidateBuilder b)]) = _$ProjectCandidate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectCandidateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectCandidate> get serializer => _$ProjectCandidateSerializer();
}

class _$ProjectCandidateSerializer implements PrimitiveSerializer<ProjectCandidate> {
  @override
  final Iterable<Type> types = const [ProjectCandidate, _$ProjectCandidate];

  @override
  final String wireName = r'ProjectCandidate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectCandidate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'estimate_id';
    yield serializers.serialize(
      object.estimateId,
      specifiedType: const FullType(String),
    );
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
    yield r'rank';
    yield serializers.serialize(
      object.rank,
      specifiedType: const FullType(int),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'score_label';
    yield serializers.serialize(
      object.scoreLabel,
      specifiedType: const FullType(String),
    );
    if (object.vps != null) {
      yield r'vps';
      yield serializers.serialize(
        object.vps,
        specifiedType: const FullType(String),
      );
    }
    yield r'fms';
    yield serializers.serialize(
      object.fms,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'complete';
    yield serializers.serialize(
      object.complete,
      specifiedType: const FullType(bool),
    );
    yield r'fulfillment_percent';
    yield serializers.serialize(
      object.fulfillmentPercent,
      specifiedType: const FullType(String),
    );
    yield r'missing_lines';
    yield serializers.serialize(
      object.missingLines,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'materials_centavos';
    yield serializers.serialize(
      object.materialsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    if (object.deliveryCentavos != null) {
      yield r'delivery_centavos';
      yield serializers.serialize(
        object.deliveryCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.processingFeeCentavos != null) {
      yield r'processing_fee_centavos';
      yield serializers.serialize(
        object.processingFeeCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'processing_fee_status';
    yield serializers.serialize(
      object.processingFeeStatus,
      specifiedType: const FullType(String),
    );
    if (object.projectedTotalCentavos != null) {
      yield r'projected_total_centavos';
      yield serializers.serialize(
        object.projectedTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'budget_label';
    yield serializers.serialize(
      object.budgetLabel,
      specifiedType: const FullType(String),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'distance_basis';
    yield serializers.serialize(
      object.distanceBasis,
      specifiedType: const FullType(String),
    );
    if (object.etaSeconds != null) {
      yield r'eta_seconds';
      yield serializers.serialize(
        object.etaSeconds,
        specifiedType: const FullType(int),
      );
    }
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(String),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(String),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
    yield r'stale';
    yield serializers.serialize(
      object.stale,
      specifiedType: const FullType(bool),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'current_quotation_state';
    yield serializers.serialize(
      object.currentQuotationState,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectCandidate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectCandidateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'estimate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estimateId = valueDes;
          break;
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
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rank = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'score_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scoreLabel = valueDes;
          break;
        case r'vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vps = valueDes;
          break;
        case r'fms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.fms.replace(valueDes);
          break;
        case r'complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.complete = valueDes;
          break;
        case r'fulfillment_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fulfillmentPercent = valueDes;
          break;
        case r'missing_lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.missingLines.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.lines.replace(valueDes);
          break;
        case r'materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'processing_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.processingFeeCentavos = valueDes;
          break;
        case r'processing_fee_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.processingFeeStatus = valueDes;
          break;
        case r'projected_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.projectedTotalCentavos = valueDes;
          break;
        case r'budget_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.budgetLabel = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'distance_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.distanceBasis = valueDes;
          break;
        case r'eta_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.etaSeconds = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentMethod = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.delivery.replace(valueDes);
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.destination.replace(valueDes);
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        case r'stale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stale = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'current_quotation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentQuotationState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectCandidate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectCandidateBuilder();
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


