// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_vendor_test.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConnectVendorTestWithholdingDemoScenarioEnum
    _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PLATFORM_WITHHOLDER =
    const ConnectVendorTestWithholdingDemoScenarioEnum._(
        'DEMO_PLATFORM_WITHHOLDER');
const ConnectVendorTestWithholdingDemoScenarioEnum
    _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PROVIDER_WITHHOLDER =
    const ConnectVendorTestWithholdingDemoScenarioEnum._(
        'DEMO_PROVIDER_WITHHOLDER');

ConnectVendorTestWithholdingDemoScenarioEnum
    _$connectVendorTestWithholdingDemoScenarioEnumValueOf(String name) {
  switch (name) {
    case 'DEMO_PLATFORM_WITHHOLDER':
      return _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PLATFORM_WITHHOLDER;
    case 'DEMO_PROVIDER_WITHHOLDER':
      return _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PROVIDER_WITHHOLDER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ConnectVendorTestWithholdingDemoScenarioEnum>
    _$connectVendorTestWithholdingDemoScenarioEnumValues = BuiltSet<
        ConnectVendorTestWithholdingDemoScenarioEnum>(const <ConnectVendorTestWithholdingDemoScenarioEnum>[
  _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PLATFORM_WITHHOLDER,
  _$connectVendorTestWithholdingDemoScenarioEnum_DEMO_PROVIDER_WITHHOLDER,
]);

Serializer<ConnectVendorTestWithholdingDemoScenarioEnum>
    _$connectVendorTestWithholdingDemoScenarioEnumSerializer =
    _$ConnectVendorTestWithholdingDemoScenarioEnumSerializer();

class _$ConnectVendorTestWithholdingDemoScenarioEnumSerializer
    implements
        PrimitiveSerializer<ConnectVendorTestWithholdingDemoScenarioEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEMO_PLATFORM_WITHHOLDER': 'DEMO_PLATFORM_WITHHOLDER',
    'DEMO_PROVIDER_WITHHOLDER': 'DEMO_PROVIDER_WITHHOLDER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEMO_PLATFORM_WITHHOLDER': 'DEMO_PLATFORM_WITHHOLDER',
    'DEMO_PROVIDER_WITHHOLDER': 'DEMO_PROVIDER_WITHHOLDER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ConnectVendorTestWithholdingDemoScenarioEnum
  ];
  @override
  final String wireName = 'ConnectVendorTestWithholdingDemoScenarioEnum';

  @override
  Object serialize(Serializers serializers,
          ConnectVendorTestWithholdingDemoScenarioEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConnectVendorTestWithholdingDemoScenarioEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConnectVendorTestWithholdingDemoScenarioEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ConnectVendorTest extends ConnectVendorTest {
  @override
  final int lockVersion;
  @override
  final ConnectVendorTestWithholdingDemoScenarioEnum withholdingDemoScenario;

  factory _$ConnectVendorTest(
          [void Function(ConnectVendorTestBuilder)? updates]) =>
      (ConnectVendorTestBuilder()..update(updates))._build();

  _$ConnectVendorTest._(
      {required this.lockVersion, required this.withholdingDemoScenario})
      : super._();
  @override
  ConnectVendorTest rebuild(void Function(ConnectVendorTestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectVendorTestBuilder toBuilder() =>
      ConnectVendorTestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectVendorTest &&
        lockVersion == other.lockVersion &&
        withholdingDemoScenario == other.withholdingDemoScenario;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, withholdingDemoScenario.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectVendorTest')
          ..add('lockVersion', lockVersion)
          ..add('withholdingDemoScenario', withholdingDemoScenario))
        .toString();
  }
}

class ConnectVendorTestBuilder
    implements Builder<ConnectVendorTest, ConnectVendorTestBuilder> {
  _$ConnectVendorTest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ConnectVendorTestWithholdingDemoScenarioEnum? _withholdingDemoScenario;
  ConnectVendorTestWithholdingDemoScenarioEnum? get withholdingDemoScenario =>
      _$this._withholdingDemoScenario;
  set withholdingDemoScenario(
          ConnectVendorTestWithholdingDemoScenarioEnum?
              withholdingDemoScenario) =>
      _$this._withholdingDemoScenario = withholdingDemoScenario;

  ConnectVendorTestBuilder() {
    ConnectVendorTest._defaults(this);
  }

  ConnectVendorTestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _withholdingDemoScenario = $v.withholdingDemoScenario;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectVendorTest other) {
    _$v = other as _$ConnectVendorTest;
  }

  @override
  void update(void Function(ConnectVendorTestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectVendorTest build() => _build();

  _$ConnectVendorTest _build() {
    final _$result = _$v ??
        _$ConnectVendorTest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ConnectVendorTest', 'lockVersion'),
          withholdingDemoScenario: BuiltValueNullFieldError.checkNotNull(
              withholdingDemoScenario,
              r'ConnectVendorTest',
              'withholdingDemoScenario'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
