//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_group_envelope_data.g.dart';

/// ComparableGroupEnvelopeData
///
/// Properties:
/// * [groupId]
/// * [groupVersionId]
/// * [mappedVariants]
@BuiltValue()
abstract class ComparableGroupEnvelopeData implements Built<ComparableGroupEnvelopeData, ComparableGroupEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'group_id')
  String get groupId;

  @BuiltValueField(wireName: r'group_version_id')
  String get groupVersionId;

  @BuiltValueField(wireName: r'mapped_variants')
  int get mappedVariants;

  ComparableGroupEnvelopeData._();

  factory ComparableGroupEnvelopeData([void updates(ComparableGroupEnvelopeDataBuilder b)]) = _$ComparableGroupEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableGroupEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableGroupEnvelopeData> get serializer => _$ComparableGroupEnvelopeDataSerializer();
}

class _$ComparableGroupEnvelopeDataSerializer implements PrimitiveSerializer<ComparableGroupEnvelopeData> {
  @override
  final Iterable<Type> types = const [ComparableGroupEnvelopeData, _$ComparableGroupEnvelopeData];

  @override
  final String wireName = r'ComparableGroupEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableGroupEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group_id';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
    yield r'group_version_id';
    yield serializers.serialize(
      object.groupVersionId,
      specifiedType: const FullType(String),
    );
    yield r'mapped_variants';
    yield serializers.serialize(
      object.mappedVariants,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableGroupEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableGroupEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
        case r'group_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupVersionId = valueDes;
          break;
        case r'mapped_variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.mappedVariants = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableGroupEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableGroupEnvelopeDataBuilder();
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


