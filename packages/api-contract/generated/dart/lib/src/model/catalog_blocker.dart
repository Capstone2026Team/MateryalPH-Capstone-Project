//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_blocker.g.dart';

/// CatalogBlocker
///
/// Properties:
/// * [key] - Field key matching the wizard input
/// * [step]
/// * [reason]
@BuiltValue()
abstract class CatalogBlocker implements Built<CatalogBlocker, CatalogBlockerBuilder> {
  /// Field key matching the wizard input
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'step')
  String get step;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  CatalogBlocker._();

  factory CatalogBlocker([void updates(CatalogBlockerBuilder b)]) = _$CatalogBlocker;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogBlockerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogBlocker> get serializer => _$CatalogBlockerSerializer();
}

class _$CatalogBlockerSerializer implements PrimitiveSerializer<CatalogBlocker> {
  @override
  final Iterable<Type> types = const [CatalogBlocker, _$CatalogBlocker];

  @override
  final String wireName = r'CatalogBlocker';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogBlockerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.step = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogBlocker deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogBlockerBuilder();
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


