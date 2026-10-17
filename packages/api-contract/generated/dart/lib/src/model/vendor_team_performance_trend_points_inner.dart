//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_performance_trend_points_inner.g.dart';

/// VendorTeamPerformanceTrendPointsInner
///
/// Properties:
/// * [date]
/// * [value]
@BuiltValue()
abstract class VendorTeamPerformanceTrendPointsInner implements Built<VendorTeamPerformanceTrendPointsInner, VendorTeamPerformanceTrendPointsInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'value')
  int get value;

  VendorTeamPerformanceTrendPointsInner._();

  factory VendorTeamPerformanceTrendPointsInner([void updates(VendorTeamPerformanceTrendPointsInnerBuilder b)]) = _$VendorTeamPerformanceTrendPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamPerformanceTrendPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamPerformanceTrendPointsInner> get serializer => _$VendorTeamPerformanceTrendPointsInnerSerializer();
}

class _$VendorTeamPerformanceTrendPointsInnerSerializer implements PrimitiveSerializer<VendorTeamPerformanceTrendPointsInner> {
  @override
  final Iterable<Type> types = const [VendorTeamPerformanceTrendPointsInner, _$VendorTeamPerformanceTrendPointsInner];

  @override
  final String wireName = r'VendorTeamPerformanceTrendPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamPerformanceTrendPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamPerformanceTrendPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamPerformanceTrendPointsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamPerformanceTrendPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamPerformanceTrendPointsInnerBuilder();
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


