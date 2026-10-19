//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement.g.dart';

/// A Work Package procurement arrangement with equal suppliers, independent vendor quotations and orders. Version zero is a computed proposal; explicit preview saves a draft without orders, reservations or payment. Vendor objects include assigned items, specification choices, current fulfillment/payment options, delivery preview, public map facts and individual quotation/order status.
///
/// Properties:
/// * [fms] - Versioned arrangement FMS with score, normalized components, raw buyer weights, supplier material shares and calculation basis. Material coverage uses exact allocated quantities per requirement, budget fit uses all materials and delivery, and distance and normalized VPS use material-cost shares. Existing neutral treatment for New Vendors remains unchanged.
/// * [rank] - Position in the filtered Best Match result before pagination; null for Price sort, incomplete coverage or unresolved costs/data.
/// * [proposalToken] - Opaque Buyer and Work Package scoped server-issued proposal. Pass unchanged when creating this computed arrangement; never parse it in clients.
/// * [id]
/// * [sourceCandidateId]
/// * [version]
/// * [workPackageVersionId]
/// * [vendors]
/// * [vendorCount]
/// * [coverage]
/// * [materialsCentavos]
/// * [deliveryCentavos]
/// * [totalCentavos]
/// * [budgetLabel]
/// * [fingerprint]
/// * [issues]
/// * [submitted]
/// * [stale]
/// * [previousVendors]
@BuiltValue()
abstract class ProjectArrangement implements Built<ProjectArrangement, ProjectArrangementBuilder> {
  /// Versioned arrangement FMS with score, normalized components, raw buyer weights, supplier material shares and calculation basis. Material coverage uses exact allocated quantities per requirement, budget fit uses all materials and delivery, and distance and normalized VPS use material-cost shares. Existing neutral treatment for New Vendors remains unchanged.
  @BuiltValueField(wireName: r'fms')
  BuiltMap<String, JsonObject?> get fms;

  /// Position in the filtered Best Match result before pagination; null for Price sort, incomplete coverage or unresolved costs/data.
  @BuiltValueField(wireName: r'rank')
  int? get rank;

  /// Opaque Buyer and Work Package scoped server-issued proposal. Pass unchanged when creating this computed arrangement; never parse it in clients.
  @BuiltValueField(wireName: r'proposal_token')
  String? get proposalToken;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'source_candidate_id')
  String get sourceCandidateId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'work_package_version_id')
  String get workPackageVersionId;

  @BuiltValueField(wireName: r'vendors')
  BuiltList<BuiltMap<String, JsonObject?>> get vendors;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'coverage')
  BuiltMap<String, JsonObject?> get coverage;

  @BuiltValueField(wireName: r'materials_centavos')
  int get materialsCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'total_centavos')
  int? get totalCentavos;

  @BuiltValueField(wireName: r'budget_label')
  String get budgetLabel;

  @BuiltValueField(wireName: r'fingerprint')
  String get fingerprint;

  @BuiltValueField(wireName: r'issues')
  BuiltList<String> get issues;

  @BuiltValueField(wireName: r'submitted')
  bool get submitted;

  @BuiltValueField(wireName: r'stale')
  bool get stale;

  @BuiltValueField(wireName: r'previous_vendors')
  BuiltList<BuiltMap<String, JsonObject?>> get previousVendors;

  ProjectArrangement._();

  factory ProjectArrangement([void updates(ProjectArrangementBuilder b)]) = _$ProjectArrangement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangement> get serializer => _$ProjectArrangementSerializer();
}

class _$ProjectArrangementSerializer implements PrimitiveSerializer<ProjectArrangement> {
  @override
  final Iterable<Type> types = const [ProjectArrangement, _$ProjectArrangement];

  @override
  final String wireName = r'ProjectArrangement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fms';
    yield serializers.serialize(
      object.fms,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.rank != null) {
      yield r'rank';
      yield serializers.serialize(
        object.rank,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.proposalToken != null) {
      yield r'proposal_token';
      yield serializers.serialize(
        object.proposalToken,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'source_candidate_id';
    yield serializers.serialize(
      object.sourceCandidateId,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'work_package_version_id';
    yield serializers.serialize(
      object.workPackageVersionId,
      specifiedType: const FullType(String),
    );
    yield r'vendors';
    yield serializers.serialize(
      object.vendors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'coverage';
    yield serializers.serialize(
      object.coverage,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'materials_centavos';
    yield serializers.serialize(
      object.materialsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield object.deliveryCentavos == null ? null : serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'total_centavos';
    yield object.totalCentavos == null ? null : serializers.serialize(
      object.totalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'budget_label';
    yield serializers.serialize(
      object.budgetLabel,
      specifiedType: const FullType(String),
    );
    yield r'fingerprint';
    yield serializers.serialize(
      object.fingerprint,
      specifiedType: const FullType(String),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'submitted';
    yield serializers.serialize(
      object.submitted,
      specifiedType: const FullType(bool),
    );
    yield r'stale';
    yield serializers.serialize(
      object.stale,
      specifiedType: const FullType(bool),
    );
    yield r'previous_vendors';
    yield serializers.serialize(
      object.previousVendors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.fms.replace(valueDes);
          break;
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rank = valueDes;
          break;
        case r'proposal_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.proposalToken = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'source_candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceCandidateId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'work_package_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workPackageVersionId = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.vendors.replace(valueDes);
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'coverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.coverage.replace(valueDes);
          break;
        case r'materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalCentavos = valueDes;
          break;
        case r'budget_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.budgetLabel = valueDes;
          break;
        case r'fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fingerprint = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.issues.replace(valueDes);
          break;
        case r'submitted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.submitted = valueDes;
          break;
        case r'stale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stale = valueDes;
          break;
        case r'previous_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.previousVendors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementBuilder();
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


