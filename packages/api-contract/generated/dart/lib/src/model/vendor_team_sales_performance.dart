//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_team_reply_time.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_sales_performance.g.dart';

/// VendorTeamSalesPerformance
///
/// Properties:
/// * [orders] - Attributed orders that reached confirmation
/// * [completed]
/// * [cancelled]
/// * [valueCentavos] - Materials payable of the attributed orders. Present only with finance.view.
/// * [conversations]
/// * [messages]
/// * [awaitingReply] - Open conversations this member handles whose latest message is from the Buyer. Current
/// * [reply]
@BuiltValue()
abstract class VendorTeamSalesPerformance implements Built<VendorTeamSalesPerformance, VendorTeamSalesPerformanceBuilder> {
  /// Attributed orders that reached confirmation
  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'completed')
  int get completed;

  @BuiltValueField(wireName: r'cancelled')
  int get cancelled;

  /// Materials payable of the attributed orders. Present only with finance.view.
  @BuiltValueField(wireName: r'value_centavos')
  int? get valueCentavos;

  @BuiltValueField(wireName: r'conversations')
  int get conversations;

  @BuiltValueField(wireName: r'messages')
  int get messages;

  /// Open conversations this member handles whose latest message is from the Buyer. Current
  @BuiltValueField(wireName: r'awaiting_reply')
  int get awaitingReply;

  @BuiltValueField(wireName: r'reply')
  VendorTeamReplyTime get reply;

  VendorTeamSalesPerformance._();

  factory VendorTeamSalesPerformance([void updates(VendorTeamSalesPerformanceBuilder b)]) = _$VendorTeamSalesPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamSalesPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamSalesPerformance> get serializer => _$VendorTeamSalesPerformanceSerializer();
}

class _$VendorTeamSalesPerformanceSerializer implements PrimitiveSerializer<VendorTeamSalesPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamSalesPerformance, _$VendorTeamSalesPerformance];

  @override
  final String wireName = r'VendorTeamSalesPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamSalesPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'completed';
    yield serializers.serialize(
      object.completed,
      specifiedType: const FullType(int),
    );
    yield r'cancelled';
    yield serializers.serialize(
      object.cancelled,
      specifiedType: const FullType(int),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
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
    VendorTeamSalesPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamSalesPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completed = valueDes;
          break;
        case r'cancelled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelled = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.valueCentavos = valueDes;
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
  VendorTeamSalesPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamSalesPerformanceBuilder();
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


