//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score_history_point.g.dart';

/// ScoreHistoryPoint
///
/// Properties:
/// * [date]
/// * [vps]
/// * [vcs]
/// * [mqs]
/// * [ohs]
@BuiltValue()
abstract class ScoreHistoryPoint implements Built<ScoreHistoryPoint, ScoreHistoryPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'vps')
  String? get vps;

  @BuiltValueField(wireName: r'vcs')
  String? get vcs;

  @BuiltValueField(wireName: r'mqs')
  String? get mqs;

  @BuiltValueField(wireName: r'ohs')
  String? get ohs;

  ScoreHistoryPoint._();

  factory ScoreHistoryPoint([void updates(ScoreHistoryPointBuilder b)]) = _$ScoreHistoryPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScoreHistoryPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScoreHistoryPoint> get serializer => _$ScoreHistoryPointSerializer();
}

class _$ScoreHistoryPointSerializer implements PrimitiveSerializer<ScoreHistoryPoint> {
  @override
  final Iterable<Type> types = const [ScoreHistoryPoint, _$ScoreHistoryPoint];

  @override
  final String wireName = r'ScoreHistoryPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScoreHistoryPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    if (object.vps != null) {
      yield r'vps';
      yield serializers.serialize(
        object.vps,
        specifiedType: const FullType(String),
      );
    }
    if (object.vcs != null) {
      yield r'vcs';
      yield serializers.serialize(
        object.vcs,
        specifiedType: const FullType(String),
      );
    }
    if (object.mqs != null) {
      yield r'mqs';
      yield serializers.serialize(
        object.mqs,
        specifiedType: const FullType(String),
      );
    }
    if (object.ohs != null) {
      yield r'ohs';
      yield serializers.serialize(
        object.ohs,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ScoreHistoryPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScoreHistoryPointBuilder result,
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
        case r'vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vps = valueDes;
          break;
        case r'vcs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vcs = valueDes;
          break;
        case r'mqs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mqs = valueDes;
          break;
        case r'ohs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ohs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScoreHistoryPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScoreHistoryPointBuilder();
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


