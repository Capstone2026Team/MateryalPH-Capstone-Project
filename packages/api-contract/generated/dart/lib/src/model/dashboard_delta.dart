//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_delta.g.dart';

/// The period value and the equal-length period before it.
///
/// Properties:
/// * [value]
/// * [previous]
/// * [changePercent]
@BuiltValue()
abstract class DashboardDelta implements Built<DashboardDelta, DashboardDeltaBuilder> {
  @BuiltValueField(wireName: r'value')
  int get value;

  @BuiltValueField(wireName: r'previous')
  int get previous;

  @BuiltValueField(wireName: r'change_percent')
  num? get changePercent;

  DashboardDelta._();

  factory DashboardDelta([void updates(DashboardDeltaBuilder b)]) = _$DashboardDelta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardDeltaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardDelta> get serializer => _$DashboardDeltaSerializer();
}

class _$DashboardDeltaSerializer implements PrimitiveSerializer<DashboardDelta> {
  @override
  final Iterable<Type> types = const [DashboardDelta, _$DashboardDelta];

  @override
  final String wireName = r'DashboardDelta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardDelta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(int),
    );
    yield r'previous';
    yield serializers.serialize(
      object.previous,
      specifiedType: const FullType(int),
    );
    if (object.changePercent != null) {
      yield r'change_percent';
      yield serializers.serialize(
        object.changePercent,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardDelta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardDeltaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value = valueDes;
          break;
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.previous = valueDes;
          break;
        case r'change_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.changePercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardDelta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardDeltaBuilder();
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


