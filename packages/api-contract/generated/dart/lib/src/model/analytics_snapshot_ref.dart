//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_snapshot_ref.g.dart';

/// AnalyticsSnapshotRef
///
/// Properties:
/// * [date]
/// * [observedAt]
/// * [revision]
@BuiltValue()
abstract class AnalyticsSnapshotRef implements Built<AnalyticsSnapshotRef, AnalyticsSnapshotRefBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'observed_at')
  DateTime get observedAt;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  AnalyticsSnapshotRef._();

  factory AnalyticsSnapshotRef([void updates(AnalyticsSnapshotRefBuilder b)]) = _$AnalyticsSnapshotRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsSnapshotRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsSnapshotRef> get serializer => _$AnalyticsSnapshotRefSerializer();
}

class _$AnalyticsSnapshotRefSerializer implements PrimitiveSerializer<AnalyticsSnapshotRef> {
  @override
  final Iterable<Type> types = const [AnalyticsSnapshotRef, _$AnalyticsSnapshotRef];

  @override
  final String wireName = r'AnalyticsSnapshotRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsSnapshotRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'observed_at';
    yield serializers.serialize(
      object.observedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsSnapshotRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsSnapshotRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'observed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.observedAt = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsSnapshotRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsSnapshotRefBuilder();
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


