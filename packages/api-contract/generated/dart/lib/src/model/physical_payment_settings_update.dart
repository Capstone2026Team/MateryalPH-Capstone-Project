//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_payment_settings_update.g.dart';

/// PhysicalPaymentSettingsUpdate
///
/// Properties:
/// * [lockVersion]
/// * [codEnabled]
/// * [inStoreEnabled]
@BuiltValue()
abstract class PhysicalPaymentSettingsUpdate implements Built<PhysicalPaymentSettingsUpdate, PhysicalPaymentSettingsUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'cod_enabled')
  bool get codEnabled;

  @BuiltValueField(wireName: r'in_store_enabled')
  bool get inStoreEnabled;

  PhysicalPaymentSettingsUpdate._();

  factory PhysicalPaymentSettingsUpdate([void updates(PhysicalPaymentSettingsUpdateBuilder b)]) = _$PhysicalPaymentSettingsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalPaymentSettingsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalPaymentSettingsUpdate> get serializer => _$PhysicalPaymentSettingsUpdateSerializer();
}

class _$PhysicalPaymentSettingsUpdateSerializer implements PrimitiveSerializer<PhysicalPaymentSettingsUpdate> {
  @override
  final Iterable<Type> types = const [PhysicalPaymentSettingsUpdate, _$PhysicalPaymentSettingsUpdate];

  @override
  final String wireName = r'PhysicalPaymentSettingsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalPaymentSettingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'cod_enabled';
    yield serializers.serialize(
      object.codEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'in_store_enabled';
    yield serializers.serialize(
      object.inStoreEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PhysicalPaymentSettingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalPaymentSettingsUpdateBuilder result,
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
        case r'cod_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.codEnabled = valueDes;
          break;
        case r'in_store_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inStoreEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhysicalPaymentSettingsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalPaymentSettingsUpdateBuilder();
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


