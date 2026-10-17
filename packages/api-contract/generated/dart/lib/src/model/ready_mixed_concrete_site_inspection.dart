//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/ready_mixed_concrete_open_inspection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready_mixed_concrete_site_inspection.g.dart';

/// ReadyMixedConcreteSiteInspection
///
/// Properties:
/// * [free]
/// * [available] - False outside the radius
/// * [openRequest]
@BuiltValue()
abstract class ReadyMixedConcreteSiteInspection implements Built<ReadyMixedConcreteSiteInspection, ReadyMixedConcreteSiteInspectionBuilder> {
  @BuiltValueField(wireName: r'free')
  bool get free;

  /// False outside the radius
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'open_request')
  ReadyMixedConcreteOpenInspection? get openRequest;

  ReadyMixedConcreteSiteInspection._();

  factory ReadyMixedConcreteSiteInspection([void updates(ReadyMixedConcreteSiteInspectionBuilder b)]) = _$ReadyMixedConcreteSiteInspection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyMixedConcreteSiteInspectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadyMixedConcreteSiteInspection> get serializer => _$ReadyMixedConcreteSiteInspectionSerializer();
}

class _$ReadyMixedConcreteSiteInspectionSerializer implements PrimitiveSerializer<ReadyMixedConcreteSiteInspection> {
  @override
  final Iterable<Type> types = const [ReadyMixedConcreteSiteInspection, _$ReadyMixedConcreteSiteInspection];

  @override
  final String wireName = r'ReadyMixedConcreteSiteInspection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadyMixedConcreteSiteInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'free';
    yield serializers.serialize(
      object.free,
      specifiedType: const FullType(bool),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'open_request';
    yield object.openRequest == null ? null : serializers.serialize(
      object.openRequest,
      specifiedType: const FullType.nullable(ReadyMixedConcreteOpenInspection),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadyMixedConcreteSiteInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyMixedConcreteSiteInspectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'free':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.free = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'open_request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReadyMixedConcreteOpenInspection),
          ) as ReadyMixedConcreteOpenInspection?;
          if (valueDes == null) continue;
          result.openRequest.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadyMixedConcreteSiteInspection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyMixedConcreteSiteInspectionBuilder();
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


