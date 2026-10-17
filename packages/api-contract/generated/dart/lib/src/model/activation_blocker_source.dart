//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'activation_blocker_source.g.dart';

/// ActivationBlockerSource
///
/// Properties:
/// * [type]
/// * [label]
/// * [revision]
/// * [status]
/// * [updatedAt]
@BuiltValue()
abstract class ActivationBlockerSource implements Built<ActivationBlockerSource, ActivationBlockerSourceBuilder> {
  @BuiltValueField(wireName: r'type')
  String? get type;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'revision')
  int? get revision;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  ActivationBlockerSource._();

  factory ActivationBlockerSource([void updates(ActivationBlockerSourceBuilder b)]) = _$ActivationBlockerSource;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ActivationBlockerSourceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ActivationBlockerSource> get serializer => _$ActivationBlockerSourceSerializer();
}

class _$ActivationBlockerSourceSerializer implements PrimitiveSerializer<ActivationBlockerSource> {
  @override
  final Iterable<Type> types = const [ActivationBlockerSource, _$ActivationBlockerSource];

  @override
  final String wireName = r'ActivationBlockerSource';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ActivationBlockerSource object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(String),
      );
    }
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.revision != null) {
      yield r'revision';
      yield serializers.serialize(
        object.revision,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ActivationBlockerSource object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ActivationBlockerSourceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.revision = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ActivationBlockerSource deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ActivationBlockerSourceBuilder();
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


