//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_payment_settings.g.dart';

/// PhysicalPaymentSettings
///
/// Properties:
/// * [codEnabled]
/// * [inStoreEnabled]
/// * [lockVersion]
/// * [updatedAt]
@BuiltValue()
abstract class PhysicalPaymentSettings implements Built<PhysicalPaymentSettings, PhysicalPaymentSettingsBuilder> {
  @BuiltValueField(wireName: r'cod_enabled')
  bool get codEnabled;

  @BuiltValueField(wireName: r'in_store_enabled')
  bool get inStoreEnabled;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'updated_at')
  String? get updatedAt;

  PhysicalPaymentSettings._();

  factory PhysicalPaymentSettings([void updates(PhysicalPaymentSettingsBuilder b)]) = _$PhysicalPaymentSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalPaymentSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalPaymentSettings> get serializer => _$PhysicalPaymentSettingsSerializer();
}

class _$PhysicalPaymentSettingsSerializer implements PrimitiveSerializer<PhysicalPaymentSettings> {
  @override
  final Iterable<Type> types = const [PhysicalPaymentSettings, _$PhysicalPaymentSettings];

  @override
  final String wireName = r'PhysicalPaymentSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalPaymentSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PhysicalPaymentSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalPaymentSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  PhysicalPaymentSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalPaymentSettingsBuilder();
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


