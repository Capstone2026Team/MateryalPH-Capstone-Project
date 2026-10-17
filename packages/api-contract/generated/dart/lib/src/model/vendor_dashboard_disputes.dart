//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_disputes_series_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_count.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_disputes.g.dart';

/// portal.disputes.
///
/// Properties:
/// * [open]
/// * [awaitingResponse]
/// * [nextResponseDueAt]
/// * [filedInPeriod]
/// * [series]
/// * [issueTypes]
/// * [statuses]
/// * [fulfillmentIssues]
/// * [validatedReturns]
@BuiltValue()
abstract class VendorDashboardDisputes implements Built<VendorDashboardDisputes, VendorDashboardDisputesBuilder> {
  @BuiltValueField(wireName: r'open')
  int get open;

  @BuiltValueField(wireName: r'awaiting_response')
  int get awaitingResponse;

  @BuiltValueField(wireName: r'next_response_due_at')
  DateTime? get nextResponseDueAt;

  @BuiltValueField(wireName: r'filed_in_period')
  int get filedInPeriod;

  @BuiltValueField(wireName: r'series')
  BuiltList<VendorDashboardDisputesSeriesInner> get series;

  @BuiltValueField(wireName: r'issue_types')
  BuiltList<DashboardCount> get issueTypes;

  @BuiltValueField(wireName: r'statuses')
  BuiltList<DashboardCount> get statuses;

  @BuiltValueField(wireName: r'fulfillment_issues')
  int get fulfillmentIssues;

  @BuiltValueField(wireName: r'validated_returns')
  int get validatedReturns;

  VendorDashboardDisputes._();

  factory VendorDashboardDisputes([void updates(VendorDashboardDisputesBuilder b)]) = _$VendorDashboardDisputes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardDisputesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardDisputes> get serializer => _$VendorDashboardDisputesSerializer();
}

class _$VendorDashboardDisputesSerializer implements PrimitiveSerializer<VendorDashboardDisputes> {
  @override
  final Iterable<Type> types = const [VendorDashboardDisputes, _$VendorDashboardDisputes];

  @override
  final String wireName = r'VendorDashboardDisputes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardDisputes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(int),
    );
    yield r'awaiting_response';
    yield serializers.serialize(
      object.awaitingResponse,
      specifiedType: const FullType(int),
    );
    if (object.nextResponseDueAt != null) {
      yield r'next_response_due_at';
      yield serializers.serialize(
        object.nextResponseDueAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'filed_in_period';
    yield serializers.serialize(
      object.filedInPeriod,
      specifiedType: const FullType(int),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardDisputesSeriesInner)]),
    );
    yield r'issue_types';
    yield serializers.serialize(
      object.issueTypes,
      specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
    );
    yield r'statuses';
    yield serializers.serialize(
      object.statuses,
      specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
    );
    yield r'fulfillment_issues';
    yield serializers.serialize(
      object.fulfillmentIssues,
      specifiedType: const FullType(int),
    );
    yield r'validated_returns';
    yield serializers.serialize(
      object.validatedReturns,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardDisputes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardDisputesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.open = valueDes;
          break;
        case r'awaiting_response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.awaitingResponse = valueDes;
          break;
        case r'next_response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.nextResponseDueAt = valueDes;
          break;
        case r'filed_in_period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.filedInPeriod = valueDes;
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardDisputesSeriesInner)]),
          ) as BuiltList<VendorDashboardDisputesSeriesInner>;
          result.series.replace(valueDes);
          break;
        case r'issue_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
          ) as BuiltList<DashboardCount>;
          result.issueTypes.replace(valueDes);
          break;
        case r'statuses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
          ) as BuiltList<DashboardCount>;
          result.statuses.replace(valueDes);
          break;
        case r'fulfillment_issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fulfillmentIssues = valueDes;
          break;
        case r'validated_returns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validatedReturns = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardDisputes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardDisputesBuilder();
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


