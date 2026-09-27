//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_deactivation.g.dart';

/// CatalogDeactivation
///
/// Properties:
/// * [lockVersion]
/// * [reason]
@BuiltValue()
abstract class CatalogDeactivation implements Built<CatalogDeactivation, CatalogDeactivationBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CatalogDeactivation._();

  factory CatalogDeactivation([void updates(CatalogDeactivationBuilder b)]) = _$CatalogDeactivation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogDeactivationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogDeactivation> get serializer => _$CatalogDeactivationSerializer();
}

class _$CatalogDeactivationSerializer implements PrimitiveSerializer<CatalogDeactivation> {
  @override
  final Iterable<Type> types = const [CatalogDeactivation, _$CatalogDeactivation];

  @override
  final String wireName = r'CatalogDeactivation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogDeactivation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogDeactivation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogDeactivationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  CatalogDeactivation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogDeactivationBuilder();
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


