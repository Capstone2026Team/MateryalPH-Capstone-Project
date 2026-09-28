//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_allotment_update.g.dart';

/// AutoAcceptAllotmentUpdate
///
/// Properties:
/// * [lockVersion]
/// * [allotmentQuantity]
@BuiltValue()
abstract class AutoAcceptAllotmentUpdate implements Built<AutoAcceptAllotmentUpdate, AutoAcceptAllotmentUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'allotment_quantity')
  String get allotmentQuantity;

  AutoAcceptAllotmentUpdate._();

  factory AutoAcceptAllotmentUpdate([void updates(AutoAcceptAllotmentUpdateBuilder b)]) = _$AutoAcceptAllotmentUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptAllotmentUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptAllotmentUpdate> get serializer => _$AutoAcceptAllotmentUpdateSerializer();
}

class _$AutoAcceptAllotmentUpdateSerializer implements PrimitiveSerializer<AutoAcceptAllotmentUpdate> {
  @override
  final Iterable<Type> types = const [AutoAcceptAllotmentUpdate, _$AutoAcceptAllotmentUpdate];

  @override
  final String wireName = r'AutoAcceptAllotmentUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptAllotmentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'allotment_quantity';
    yield serializers.serialize(
      object.allotmentQuantity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptAllotmentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptAllotmentUpdateBuilder result,
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
        case r'allotment_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.allotmentQuantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptAllotmentUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptAllotmentUpdateBuilder();
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


