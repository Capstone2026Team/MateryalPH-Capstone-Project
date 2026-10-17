//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_team_reply_time.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_fulfillment_performance.g.dart';

/// VendorTeamFulfillmentPerformance
///
/// Properties:
/// * [assigned]
/// * [active] - Orders currently assigned and still being fulfilled.
/// * [handovers] - DELIVERED or PICKED_UP milestones recorded by this member.
/// * [onTime] - Handovers on or before the order's expected fulfillment date (Asia/Manila).
/// * [onTimeMeasured] - Handovers whose order has an expected fulfillment date.
/// * [milestones]
/// * [proofs]
/// * [vehicleIssues]
/// * [conversations]
/// * [messages]
/// * [awaitingReply]
/// * [reply]
@BuiltValue()
abstract class VendorTeamFulfillmentPerformance implements Built<VendorTeamFulfillmentPerformance, VendorTeamFulfillmentPerformanceBuilder> {
  @BuiltValueField(wireName: r'assigned')
  int get assigned;

  /// Orders currently assigned and still being fulfilled.
  @BuiltValueField(wireName: r'active')
  int get active;

  /// DELIVERED or PICKED_UP milestones recorded by this member.
  @BuiltValueField(wireName: r'handovers')
  int get handovers;

  /// Handovers on or before the order's expected fulfillment date (Asia/Manila).
  @BuiltValueField(wireName: r'on_time')
  int get onTime;

  /// Handovers whose order has an expected fulfillment date.
  @BuiltValueField(wireName: r'on_time_measured')
  int get onTimeMeasured;

  @BuiltValueField(wireName: r'milestones')
  int get milestones;

  @BuiltValueField(wireName: r'proofs')
  int get proofs;

  @BuiltValueField(wireName: r'vehicle_issues')
  int get vehicleIssues;

  @BuiltValueField(wireName: r'conversations')
  int get conversations;

  @BuiltValueField(wireName: r'messages')
  int get messages;

  @BuiltValueField(wireName: r'awaiting_reply')
  int get awaitingReply;

  @BuiltValueField(wireName: r'reply')
  VendorTeamReplyTime get reply;

  VendorTeamFulfillmentPerformance._();

  factory VendorTeamFulfillmentPerformance([void updates(VendorTeamFulfillmentPerformanceBuilder b)]) = _$VendorTeamFulfillmentPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamFulfillmentPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamFulfillmentPerformance> get serializer => _$VendorTeamFulfillmentPerformanceSerializer();
}

class _$VendorTeamFulfillmentPerformanceSerializer implements PrimitiveSerializer<VendorTeamFulfillmentPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamFulfillmentPerformance, _$VendorTeamFulfillmentPerformance];

  @override
  final String wireName = r'VendorTeamFulfillmentPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamFulfillmentPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assigned';
    yield serializers.serialize(
      object.assigned,
      specifiedType: const FullType(int),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
    yield r'handovers';
    yield serializers.serialize(
      object.handovers,
      specifiedType: const FullType(int),
    );
    yield r'on_time';
    yield serializers.serialize(
      object.onTime,
      specifiedType: const FullType(int),
    );
    yield r'on_time_measured';
    yield serializers.serialize(
      object.onTimeMeasured,
      specifiedType: const FullType(int),
    );
    yield r'milestones';
    yield serializers.serialize(
      object.milestones,
      specifiedType: const FullType(int),
    );
    yield r'proofs';
    yield serializers.serialize(
      object.proofs,
      specifiedType: const FullType(int),
    );
    yield r'vehicle_issues';
    yield serializers.serialize(
      object.vehicleIssues,
      specifiedType: const FullType(int),
    );
    yield r'conversations';
    yield serializers.serialize(
      object.conversations,
      specifiedType: const FullType(int),
    );
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(int),
    );
    yield r'awaiting_reply';
    yield serializers.serialize(
      object.awaitingReply,
      specifiedType: const FullType(int),
    );
    yield r'reply';
    yield serializers.serialize(
      object.reply,
      specifiedType: const FullType(VendorTeamReplyTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamFulfillmentPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamFulfillmentPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assigned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assigned = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        case r'handovers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.handovers = valueDes;
          break;
        case r'on_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onTime = valueDes;
          break;
        case r'on_time_measured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onTimeMeasured = valueDes;
          break;
        case r'milestones':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.milestones = valueDes;
          break;
        case r'proofs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.proofs = valueDes;
          break;
        case r'vehicle_issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicleIssues = valueDes;
          break;
        case r'conversations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.conversations = valueDes;
          break;
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.messages = valueDes;
          break;
        case r'awaiting_reply':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.awaitingReply = valueDes;
          break;
        case r'reply':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamReplyTime),
          ) as VendorTeamReplyTime;
          result.reply.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamFulfillmentPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamFulfillmentPerformanceBuilder();
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


