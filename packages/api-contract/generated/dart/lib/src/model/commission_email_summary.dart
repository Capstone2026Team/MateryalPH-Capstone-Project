//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_email_summary.g.dart';

/// CommissionEmailSummary
///
/// Properties:
/// * [total]
/// * [sent]
/// * [failed]
/// * [queued]
/// * [blocked]
@BuiltValue()
abstract class CommissionEmailSummary implements Built<CommissionEmailSummary, CommissionEmailSummaryBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'sent')
  int get sent;

  @BuiltValueField(wireName: r'failed')
  int get failed;

  @BuiltValueField(wireName: r'queued')
  int get queued;

  @BuiltValueField(wireName: r'blocked')
  int get blocked;

  CommissionEmailSummary._();

  factory CommissionEmailSummary([void updates(CommissionEmailSummaryBuilder b)]) = _$CommissionEmailSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionEmailSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionEmailSummary> get serializer => _$CommissionEmailSummarySerializer();
}

class _$CommissionEmailSummarySerializer implements PrimitiveSerializer<CommissionEmailSummary> {
  @override
  final Iterable<Type> types = const [CommissionEmailSummary, _$CommissionEmailSummary];

  @override
  final String wireName = r'CommissionEmailSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionEmailSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
    yield r'queued';
    yield serializers.serialize(
      object.queued,
      specifiedType: const FullType(int),
    );
    yield r'blocked';
    yield serializers.serialize(
      object.blocked,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionEmailSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionEmailSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sent = valueDes;
          break;
        case r'failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failed = valueDes;
          break;
        case r'queued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.queued = valueDes;
          break;
        case r'blocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.blocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionEmailSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionEmailSummaryBuilder();
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


