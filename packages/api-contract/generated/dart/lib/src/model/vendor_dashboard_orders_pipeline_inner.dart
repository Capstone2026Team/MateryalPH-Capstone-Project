//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_pipeline_inner.g.dart';

/// VendorDashboardOrdersPipelineInner
///
/// Properties:
/// * [state]
/// * [count]
@BuiltValue()
abstract class VendorDashboardOrdersPipelineInner implements Built<VendorDashboardOrdersPipelineInner, VendorDashboardOrdersPipelineInnerBuilder> {
  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'count')
  int get count;

  VendorDashboardOrdersPipelineInner._();

  factory VendorDashboardOrdersPipelineInner([void updates(VendorDashboardOrdersPipelineInnerBuilder b)]) = _$VendorDashboardOrdersPipelineInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersPipelineInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersPipelineInner> get serializer => _$VendorDashboardOrdersPipelineInnerSerializer();
}

class _$VendorDashboardOrdersPipelineInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersPipelineInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersPipelineInner, _$VendorDashboardOrdersPipelineInner];

  @override
  final String wireName = r'VendorDashboardOrdersPipelineInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersPipelineInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersPipelineInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersPipelineInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersPipelineInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersPipelineInnerBuilder();
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


