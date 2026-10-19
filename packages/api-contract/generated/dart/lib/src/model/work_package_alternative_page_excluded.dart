//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_alternative_page_excluded.g.dart';

/// Listings in range that were left out, so an empty result can say why.
///
/// Properties:
/// * [outOfStock]
/// * [cannotServeFulfillment]
@BuiltValue()
abstract class WorkPackageAlternativePageExcluded implements Built<WorkPackageAlternativePageExcluded, WorkPackageAlternativePageExcludedBuilder> {
  @BuiltValueField(wireName: r'out_of_stock')
  int get outOfStock;

  @BuiltValueField(wireName: r'cannot_serve_fulfillment')
  int get cannotServeFulfillment;

  WorkPackageAlternativePageExcluded._();

  factory WorkPackageAlternativePageExcluded([void updates(WorkPackageAlternativePageExcludedBuilder b)]) = _$WorkPackageAlternativePageExcluded;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageAlternativePageExcludedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageAlternativePageExcluded> get serializer => _$WorkPackageAlternativePageExcludedSerializer();
}

class _$WorkPackageAlternativePageExcludedSerializer implements PrimitiveSerializer<WorkPackageAlternativePageExcluded> {
  @override
  final Iterable<Type> types = const [WorkPackageAlternativePageExcluded, _$WorkPackageAlternativePageExcluded];

  @override
  final String wireName = r'WorkPackageAlternativePageExcluded';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageAlternativePageExcluded object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'out_of_stock';
    yield serializers.serialize(
      object.outOfStock,
      specifiedType: const FullType(int),
    );
    yield r'cannot_serve_fulfillment';
    yield serializers.serialize(
      object.cannotServeFulfillment,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageAlternativePageExcluded object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageAlternativePageExcludedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'out_of_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outOfStock = valueDes;
          break;
        case r'cannot_serve_fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cannotServeFulfillment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageAlternativePageExcluded deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageAlternativePageExcludedBuilder();
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


