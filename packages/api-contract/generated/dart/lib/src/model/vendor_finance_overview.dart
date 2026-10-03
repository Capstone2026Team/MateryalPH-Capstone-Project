//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_finance_notice.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/withholding_threshold_panel.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_finance_overview.g.dart';

/// VendorFinanceOverview
///
/// Properties:
/// * [demoLabel]
/// * [xenditConnection]
/// * [taxProfile]
/// * [withholdingArrangement]
/// * [threshold]
/// * [commissionTerms]
/// * [onlineChannels]
/// * [physicalPayments]
/// * [refundCapability]
/// * [statements]
/// * [notices]
@BuiltValue()
abstract class VendorFinanceOverview implements Built<VendorFinanceOverview, VendorFinanceOverviewBuilder> {
  @BuiltValueField(wireName: r'demo_label')
  String get demoLabel;

  @BuiltValueField(wireName: r'xendit_connection')
  BuiltMap<String, JsonObject?> get xenditConnection;

  @BuiltValueField(wireName: r'tax_profile')
  BuiltMap<String, JsonObject?> get taxProfile;

  @BuiltValueField(wireName: r'withholding_arrangement')
  BuiltMap<String, JsonObject?> get withholdingArrangement;

  @BuiltValueField(wireName: r'threshold')
  WithholdingThresholdPanel? get threshold;

  @BuiltValueField(wireName: r'commission_terms')
  BuiltMap<String, JsonObject?> get commissionTerms;

  @BuiltValueField(wireName: r'online_channels')
  BuiltMap<String, JsonObject?> get onlineChannels;

  @BuiltValueField(wireName: r'physical_payments')
  BuiltMap<String, JsonObject?> get physicalPayments;

  @BuiltValueField(wireName: r'refund_capability')
  BuiltMap<String, JsonObject?> get refundCapability;

  @BuiltValueField(wireName: r'statements')
  BuiltMap<String, JsonObject?> get statements;

  @BuiltValueField(wireName: r'notices')
  BuiltList<VendorFinanceNotice> get notices;

  VendorFinanceOverview._();

  factory VendorFinanceOverview([void updates(VendorFinanceOverviewBuilder b)]) = _$VendorFinanceOverview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorFinanceOverviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorFinanceOverview> get serializer => _$VendorFinanceOverviewSerializer();
}

class _$VendorFinanceOverviewSerializer implements PrimitiveSerializer<VendorFinanceOverview> {
  @override
  final Iterable<Type> types = const [VendorFinanceOverview, _$VendorFinanceOverview];

  @override
  final String wireName = r'VendorFinanceOverview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorFinanceOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'demo_label';
    yield serializers.serialize(
      object.demoLabel,
      specifiedType: const FullType(String),
    );
    yield r'xendit_connection';
    yield serializers.serialize(
      object.xenditConnection,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'tax_profile';
    yield serializers.serialize(
      object.taxProfile,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'withholding_arrangement';
    yield serializers.serialize(
      object.withholdingArrangement,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.threshold != null) {
      yield r'threshold';
      yield serializers.serialize(
        object.threshold,
        specifiedType: const FullType(WithholdingThresholdPanel),
      );
    }
    yield r'commission_terms';
    yield serializers.serialize(
      object.commissionTerms,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'online_channels';
    yield serializers.serialize(
      object.onlineChannels,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'physical_payments';
    yield serializers.serialize(
      object.physicalPayments,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'refund_capability';
    yield serializers.serialize(
      object.refundCapability,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'statements';
    yield serializers.serialize(
      object.statements,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'notices';
    yield serializers.serialize(
      object.notices,
      specifiedType: const FullType(BuiltList, [FullType(VendorFinanceNotice)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorFinanceOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorFinanceOverviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'demo_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.demoLabel = valueDes;
          break;
        case r'xendit_connection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.xenditConnection.replace(valueDes);
          break;
        case r'tax_profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.taxProfile.replace(valueDes);
          break;
        case r'withholding_arrangement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.withholdingArrangement.replace(valueDes);
          break;
        case r'threshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WithholdingThresholdPanel),
          ) as WithholdingThresholdPanel?;
          if (valueDes == null) continue;
          result.threshold.replace(valueDes);
          break;
        case r'commission_terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.commissionTerms.replace(valueDes);
          break;
        case r'online_channels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.onlineChannels.replace(valueDes);
          break;
        case r'physical_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.physicalPayments.replace(valueDes);
          break;
        case r'refund_capability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.refundCapability.replace(valueDes);
          break;
        case r'statements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.statements.replace(valueDes);
          break;
        case r'notices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorFinanceNotice)]),
          ) as BuiltList<VendorFinanceNotice>;
          result.notices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorFinanceOverview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorFinanceOverviewBuilder();
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


