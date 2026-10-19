//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_payment_method.dart';
import 'package:materyalph_api_client/src/model/project_draft_vendor_group.dart';
import 'package:materyalph_api_client/src/model/project_fulfillment.dart';
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
/// * [lines] - One entry per Work Package line. Each line is filled from one specification option and never mixes two. `options` lists every option (ProjectSpecificationDetail `specifications`, lowest unit price, availability label) when there is more than one; `selection_required` is true until the Buyer chooses one, and until then the line is priced on a flagged basis option. Allocations carry `listing_id`, `variant_id`, `variant_label` and labelled `offered_specifications`.
/// * [selectionRequired] - Some line still needs the Buyer's specification choice.
/// * [specificationSelections] - Choices applied by selection-preview, keyed by line id.
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
/// * [fulfillmentMethod] - The concrete method this view is priced for: DELIVERY or PICKUP. For a Both package it is the Vendor's preferred method until the Buyer picks one. A supplier quotation containing ready-mixed concrete uses DELIVERY only, even when the Work Package requests pickup.
/// * [fulfillmentOptions] - Methods this Vendor offers for the package. More than one means the Buyer must send `fulfillment_method` when inquiring or selecting; selection-preview re-prices for the chosen method. Ready-mixed concrete restricts its supplier quotation to DELIVERY.
/// * [paymentMethod]
/// * [delivery]
/// * [destination]
/// * [expiresAt]
/// * [stale]
/// * [label]
/// * [currentQuotationState]
/// * [isFavorite] - The Buyer saved this store as a preferred seller.
/// * [fulfillment]
/// * [paymentMethods]
/// * [draftGroups] - Draft supplementary items by supplying Vendor, including automatic exact-match defaults. Defaults are saved during selection preview; explicit removals and replacements are preserved. Independent of the regular cart.
/// * [primaryOrderId]
/// * [procurementMaterialsCentavos] - Primary and supplementary materials, including existing linked purchases.
/// * [separateDeliveryCentavos] - Delivery for supplementary suppliers and linked orders, counted once per order or draft supplier. Null while any fee needs review.
/// * [procurementDeliveryCentavos] - Delivery for the primary Vendor and all separate suppliers. Null while any fee needs review.
/// * [procurementBudgetLabel] - Work Package budget status for the complete procurement total.
/// * [procurementTotalCentavos] - Materials and each supplying Vendor delivery counted once. Null while any delivery remains unconfirmed or unavailable. Processing fees are excluded until payment.
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

  /// One entry per Work Package line. Each line is filled from one specification option and never mixes two. `options` lists every option (ProjectSpecificationDetail `specifications`, lowest unit price, availability label) when there is more than one; `selection_required` is true until the Buyer chooses one, and until then the line is priced on a flagged basis option. Allocations carry `listing_id`, `variant_id`, `variant_label` and labelled `offered_specifications`.
  @BuiltValueField(wireName: r'lines')
  BuiltList<BuiltMap<String, JsonObject?>> get lines;

  /// Some line still needs the Buyer's specification choice.
  @BuiltValueField(wireName: r'selection_required')
  bool? get selectionRequired;

  /// Choices applied by selection-preview, keyed by line id.
  @BuiltValueField(wireName: r'specification_selections')
  BuiltMap<String, String>? get specificationSelections;

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

  /// The concrete method this view is priced for: DELIVERY or PICKUP. For a Both package it is the Vendor's preferred method until the Buyer picks one. A supplier quotation containing ready-mixed concrete uses DELIVERY only, even when the Work Package requests pickup.
  @BuiltValueField(wireName: r'fulfillment_method')
  String get fulfillmentMethod;

  /// Methods this Vendor offers for the package. More than one means the Buyer must send `fulfillment_method` when inquiring or selecting; selection-preview re-prices for the chosen method. Ready-mixed concrete restricts its supplier quotation to DELIVERY.
  @BuiltValueField(wireName: r'fulfillment_options')
  BuiltList<ProjectCandidateFulfillmentOptionsEnum>? get fulfillmentOptions;
  // enum fulfillmentOptionsEnum {  DELIVERY,  PICKUP,  };

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

  /// The Buyer saved this store as a preferred seller.
  @BuiltValueField(wireName: r'is_favorite')
  bool? get isFavorite;

  @BuiltValueField(wireName: r'fulfillment')
  ProjectFulfillment get fulfillment;

  @BuiltValueField(wireName: r'payment_methods')
  BuiltList<ProjectPaymentMethod>? get paymentMethods;

  /// Draft supplementary items by supplying Vendor, including automatic exact-match defaults. Defaults are saved during selection preview; explicit removals and replacements are preserved. Independent of the regular cart.
  @BuiltValueField(wireName: r'draft_groups')
  BuiltList<ProjectDraftVendorGroup>? get draftGroups;

  @BuiltValueField(wireName: r'primary_order_id')
  String? get primaryOrderId;

  /// Primary and supplementary materials, including existing linked purchases.
  @BuiltValueField(wireName: r'procurement_materials_centavos')
  int? get procurementMaterialsCentavos;

  /// Delivery for supplementary suppliers and linked orders, counted once per order or draft supplier. Null while any fee needs review.
  @BuiltValueField(wireName: r'separate_delivery_centavos')
  int? get separateDeliveryCentavos;

  /// Delivery for the primary Vendor and all separate suppliers. Null while any fee needs review.
  @BuiltValueField(wireName: r'procurement_delivery_centavos')
  int? get procurementDeliveryCentavos;

  /// Work Package budget status for the complete procurement total.
  @BuiltValueField(wireName: r'procurement_budget_label')
  ProjectCandidateProcurementBudgetLabelEnum? get procurementBudgetLabel;
  // enum procurementBudgetLabelEnum {  UNDER_BUDGET,  WITHIN_BUDGET,  OVER_BUDGET,  COST_REVIEW_REQUIRED,  };

  /// Materials and each supplying Vendor delivery counted once. Null while any delivery remains unconfirmed or unavailable. Processing fees are excluded until payment.
  @BuiltValueField(wireName: r'procurement_total_centavos')
  int? get procurementTotalCentavos;

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
    if (object.selectionRequired != null) {
      yield r'selection_required';
      yield serializers.serialize(
        object.selectionRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.specificationSelections != null) {
      yield r'specification_selections';
      yield serializers.serialize(
        object.specificationSelections,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
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
    if (object.fulfillmentOptions != null) {
      yield r'fulfillment_options';
      yield serializers.serialize(
        object.fulfillmentOptions,
        specifiedType: const FullType(BuiltList, [FullType(ProjectCandidateFulfillmentOptionsEnum)]),
      );
    }
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
    if (object.isFavorite != null) {
      yield r'is_favorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(bool),
      );
    }
    yield r'fulfillment';
    yield serializers.serialize(
      object.fulfillment,
      specifiedType: const FullType(ProjectFulfillment),
    );
    if (object.paymentMethods != null) {
      yield r'payment_methods';
      yield serializers.serialize(
        object.paymentMethods,
        specifiedType: const FullType(BuiltList, [FullType(ProjectPaymentMethod)]),
      );
    }
    if (object.draftGroups != null) {
      yield r'draft_groups';
      yield serializers.serialize(
        object.draftGroups,
        specifiedType: const FullType(BuiltList, [FullType(ProjectDraftVendorGroup)]),
      );
    }
    if (object.primaryOrderId != null) {
      yield r'primary_order_id';
      yield serializers.serialize(
        object.primaryOrderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.procurementMaterialsCentavos != null) {
      yield r'procurement_materials_centavos';
      yield serializers.serialize(
        object.procurementMaterialsCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.separateDeliveryCentavos != null) {
      yield r'separate_delivery_centavos';
      yield serializers.serialize(
        object.separateDeliveryCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.procurementDeliveryCentavos != null) {
      yield r'procurement_delivery_centavos';
      yield serializers.serialize(
        object.procurementDeliveryCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.procurementBudgetLabel != null) {
      yield r'procurement_budget_label';
      yield serializers.serialize(
        object.procurementBudgetLabel,
        specifiedType: const FullType(ProjectCandidateProcurementBudgetLabelEnum),
      );
    }
    if (object.procurementTotalCentavos != null) {
      yield r'procurement_total_centavos';
      yield serializers.serialize(
        object.procurementTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
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
        case r'selection_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.selectionRequired = valueDes;
          break;
        case r'specification_selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>?;
          if (valueDes == null) continue;
          result.specificationSelections.replace(valueDes);
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
        case r'fulfillment_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectCandidateFulfillmentOptionsEnum)]),
          ) as BuiltList<ProjectCandidateFulfillmentOptionsEnum>?;
          if (valueDes == null) continue;
          result.fulfillmentOptions.replace(valueDes);
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
        case r'is_favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectFulfillment),
          ) as ProjectFulfillment;
          result.fulfillment.replace(valueDes);
          break;
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectPaymentMethod)]),
          ) as BuiltList<ProjectPaymentMethod>?;
          if (valueDes == null) continue;
          result.paymentMethods.replace(valueDes);
          break;
        case r'draft_groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectDraftVendorGroup)]),
          ) as BuiltList<ProjectDraftVendorGroup>?;
          if (valueDes == null) continue;
          result.draftGroups.replace(valueDes);
          break;
        case r'primary_order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryOrderId = valueDes;
          break;
        case r'procurement_materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.procurementMaterialsCentavos = valueDes;
          break;
        case r'separate_delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.separateDeliveryCentavos = valueDes;
          break;
        case r'procurement_delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.procurementDeliveryCentavos = valueDes;
          break;
        case r'procurement_budget_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectCandidateProcurementBudgetLabelEnum),
          ) as ProjectCandidateProcurementBudgetLabelEnum?;
          if (valueDes == null) continue;
          result.procurementBudgetLabel = valueDes;
          break;
        case r'procurement_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.procurementTotalCentavos = valueDes;
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


class ProjectCandidateFulfillmentOptionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectCandidateFulfillmentOptionsEnum DELIVERY = _$projectCandidateFulfillmentOptionsEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectCandidateFulfillmentOptionsEnum PICKUP = _$projectCandidateFulfillmentOptionsEnum_PICKUP;

  static Serializer<ProjectCandidateFulfillmentOptionsEnum> get serializer => _$projectCandidateFulfillmentOptionsEnumSerializer;

  const ProjectCandidateFulfillmentOptionsEnum._(String name): super(name);

  static BuiltSet<ProjectCandidateFulfillmentOptionsEnum> get values => _$projectCandidateFulfillmentOptionsEnumValues;
  static ProjectCandidateFulfillmentOptionsEnum valueOf(String name) => _$projectCandidateFulfillmentOptionsEnumValueOf(name);
}

/// Work Package budget status for the complete procurement total.
class ProjectCandidateProcurementBudgetLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNDER_BUDGET')
  static const ProjectCandidateProcurementBudgetLabelEnum UNDER_BUDGET = _$projectCandidateProcurementBudgetLabelEnum_UNDER_BUDGET;
  @BuiltValueEnumConst(wireName: r'WITHIN_BUDGET')
  static const ProjectCandidateProcurementBudgetLabelEnum WITHIN_BUDGET = _$projectCandidateProcurementBudgetLabelEnum_WITHIN_BUDGET;
  @BuiltValueEnumConst(wireName: r'OVER_BUDGET')
  static const ProjectCandidateProcurementBudgetLabelEnum OVER_BUDGET = _$projectCandidateProcurementBudgetLabelEnum_OVER_BUDGET;
  @BuiltValueEnumConst(wireName: r'COST_REVIEW_REQUIRED')
  static const ProjectCandidateProcurementBudgetLabelEnum COST_REVIEW_REQUIRED = _$projectCandidateProcurementBudgetLabelEnum_COST_REVIEW_REQUIRED;

  static Serializer<ProjectCandidateProcurementBudgetLabelEnum> get serializer => _$projectCandidateProcurementBudgetLabelEnumSerializer;

  const ProjectCandidateProcurementBudgetLabelEnum._(String name): super(name);

  static BuiltSet<ProjectCandidateProcurementBudgetLabelEnum> get values => _$projectCandidateProcurementBudgetLabelEnumValues;
  static ProjectCandidateProcurementBudgetLabelEnum valueOf(String name) => _$projectCandidateProcurementBudgetLabelEnumValueOf(name);
}

