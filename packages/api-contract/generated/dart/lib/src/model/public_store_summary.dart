//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_store_summary.g.dart';

/// PublicStoreSummary
///
/// Properties:
/// * [id]
/// * [publicStoreName]
/// * [description]
@BuiltValue()
abstract class PublicStoreSummary implements Built<PublicStoreSummary, PublicStoreSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'public_store_name')
  String get publicStoreName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  PublicStoreSummary._();

  factory PublicStoreSummary([void updates(PublicStoreSummaryBuilder b)]) = _$PublicStoreSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicStoreSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicStoreSummary> get serializer => _$PublicStoreSummarySerializer();
}

class _$PublicStoreSummarySerializer implements PrimitiveSerializer<PublicStoreSummary> {
  @override
  final Iterable<Type> types = const [PublicStoreSummary, _$PublicStoreSummary];

  @override
  final String wireName = r'PublicStoreSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicStoreSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'public_store_name';
    yield serializers.serialize(
      object.publicStoreName,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicStoreSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicStoreSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'public_store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicStoreName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicStoreSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicStoreSummaryBuilder();
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


