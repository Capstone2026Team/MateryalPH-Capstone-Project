//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_reply_time.g.dart';

/// VendorTeamReplyTime
///
/// Properties:
/// * [measured] - Buyer waits answered by this member in the period.
/// * [averageSeconds]
/// * [medianSeconds]
@BuiltValue()
abstract class VendorTeamReplyTime implements Built<VendorTeamReplyTime, VendorTeamReplyTimeBuilder> {
  /// Buyer waits answered by this member in the period.
  @BuiltValueField(wireName: r'measured')
  int get measured;

  @BuiltValueField(wireName: r'average_seconds')
  int? get averageSeconds;

  @BuiltValueField(wireName: r'median_seconds')
  int? get medianSeconds;

  VendorTeamReplyTime._();

  factory VendorTeamReplyTime([void updates(VendorTeamReplyTimeBuilder b)]) = _$VendorTeamReplyTime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamReplyTimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamReplyTime> get serializer => _$VendorTeamReplyTimeSerializer();
}

class _$VendorTeamReplyTimeSerializer implements PrimitiveSerializer<VendorTeamReplyTime> {
  @override
  final Iterable<Type> types = const [VendorTeamReplyTime, _$VendorTeamReplyTime];

  @override
  final String wireName = r'VendorTeamReplyTime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamReplyTime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'measured';
    yield serializers.serialize(
      object.measured,
      specifiedType: const FullType(int),
    );
    if (object.averageSeconds != null) {
      yield r'average_seconds';
      yield serializers.serialize(
        object.averageSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.medianSeconds != null) {
      yield r'median_seconds';
      yield serializers.serialize(
        object.medianSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamReplyTime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamReplyTimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'measured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.measured = valueDes;
          break;
        case r'average_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.averageSeconds = valueDes;
          break;
        case r'median_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.medianSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamReplyTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamReplyTimeBuilder();
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


