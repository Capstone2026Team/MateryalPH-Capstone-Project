//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connect_vendor_test.g.dart';

/// ConnectVendorTest
///
/// Properties:
/// * [lockVersion]
/// * [withholdingDemoScenario]
@BuiltValue()
abstract class ConnectVendorTest implements Built<ConnectVendorTest, ConnectVendorTestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'withholding_demo_scenario')
  ConnectVendorTestWithholdingDemoScenarioEnum get withholdingDemoScenario;
  // enum withholdingDemoScenarioEnum {  DEMO_PLATFORM_WITHHOLDER,  DEMO_PROVIDER_WITHHOLDER,  };

  ConnectVendorTest._();

  factory ConnectVendorTest([void updates(ConnectVendorTestBuilder b)]) = _$ConnectVendorTest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectVendorTestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectVendorTest> get serializer => _$ConnectVendorTestSerializer();
}

class _$ConnectVendorTestSerializer implements PrimitiveSerializer<ConnectVendorTest> {
  @override
  final Iterable<Type> types = const [ConnectVendorTest, _$ConnectVendorTest];

  @override
  final String wireName = r'ConnectVendorTest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectVendorTest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'withholding_demo_scenario';
    yield serializers.serialize(
      object.withholdingDemoScenario,
      specifiedType: const FullType(ConnectVendorTestWithholdingDemoScenarioEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectVendorTest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConnectVendorTestBuilder result,
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
        case r'withholding_demo_scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConnectVendorTestWithholdingDemoScenarioEnum),
          ) as ConnectVendorTestWithholdingDemoScenarioEnum;
          result.withholdingDemoScenario = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectVendorTest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectVendorTestBuilder();
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


class ConnectVendorTestWithholdingDemoScenarioEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEMO_PLATFORM_WITHHOLDER')
  static const ConnectVendorTestWithholdingDemoScenarioEnum DEMO_PLATFORM_WITHHOLDER = _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PLATFORM_WITHHOLDER;
  @BuiltValueEnumConst(wireName: r'DEMO_PROVIDER_WITHHOLDER')
  static const ConnectVendorTestWithholdingDemoScenarioEnum DEMO_PROVIDER_WITHHOLDER = _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PROVIDER_WITHHOLDER;

  static Serializer<ConnectVendorTestWithholdingDemoScenarioEnum> get serializer => _$connectVendorTestWithholdingDemoScenarioEnumSerializer;

  const ConnectVendorTestWithholdingDemoScenarioEnum._(String name): super(name);

  static BuiltSet<ConnectVendorTestWithholdingDemoScenarioEnum> get values => _$connectVendorTestWithholdingDemoScenarioEnumValues;
  static ConnectVendorTestWithholdingDemoScenarioEnum valueOf(String name) => _$connectVendorTestWithholdingDemoScenarioEnumValueOf(name);
}

