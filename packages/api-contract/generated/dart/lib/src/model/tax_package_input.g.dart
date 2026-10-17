// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_package_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaxPackageInputFormEnum _$taxPackageInputFormEnum_n2307 =
    const TaxPackageInputFormEnum._('n2307');
const TaxPackageInputFormEnum _$taxPackageInputFormEnum_n0619e =
    const TaxPackageInputFormEnum._('n0619e');
const TaxPackageInputFormEnum _$taxPackageInputFormEnum_n1601eQ =
    const TaxPackageInputFormEnum._('n1601eQ');
const TaxPackageInputFormEnum _$taxPackageInputFormEnum_QAP =
    const TaxPackageInputFormEnum._('QAP');
const TaxPackageInputFormEnum _$taxPackageInputFormEnum_n1604e =
    const TaxPackageInputFormEnum._('n1604e');
const TaxPackageInputFormEnum _$taxPackageInputFormEnum_ANNUAL_ALPHALIST =
    const TaxPackageInputFormEnum._('ANNUAL_ALPHALIST');

TaxPackageInputFormEnum _$taxPackageInputFormEnumValueOf(String name) {
  switch (name) {
    case 'n2307':
      return _$taxPackageInputFormEnum_n2307;
    case 'n0619e':
      return _$taxPackageInputFormEnum_n0619e;
    case 'n1601eQ':
      return _$taxPackageInputFormEnum_n1601eQ;
    case 'QAP':
      return _$taxPackageInputFormEnum_QAP;
    case 'n1604e':
      return _$taxPackageInputFormEnum_n1604e;
    case 'ANNUAL_ALPHALIST':
      return _$taxPackageInputFormEnum_ANNUAL_ALPHALIST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxPackageInputFormEnum> _$taxPackageInputFormEnumValues =
    BuiltSet<TaxPackageInputFormEnum>(const <TaxPackageInputFormEnum>[
  _$taxPackageInputFormEnum_n2307,
  _$taxPackageInputFormEnum_n0619e,
  _$taxPackageInputFormEnum_n1601eQ,
  _$taxPackageInputFormEnum_QAP,
  _$taxPackageInputFormEnum_n1604e,
  _$taxPackageInputFormEnum_ANNUAL_ALPHALIST,
]);

const TaxPackageInputWithholdingEntityEnum
    _$taxPackageInputWithholdingEntityEnum_DEMO_PLATFORM_WITHHOLDER =
    const TaxPackageInputWithholdingEntityEnum._('DEMO_PLATFORM_WITHHOLDER');
const TaxPackageInputWithholdingEntityEnum
    _$taxPackageInputWithholdingEntityEnum_DEMO_PROVIDER_WITHHOLDER =
    const TaxPackageInputWithholdingEntityEnum._('DEMO_PROVIDER_WITHHOLDER');

TaxPackageInputWithholdingEntityEnum
    _$taxPackageInputWithholdingEntityEnumValueOf(String name) {
  switch (name) {
    case 'DEMO_PLATFORM_WITHHOLDER':
      return _$taxPackageInputWithholdingEntityEnum_DEMO_PLATFORM_WITHHOLDER;
    case 'DEMO_PROVIDER_WITHHOLDER':
      return _$taxPackageInputWithholdingEntityEnum_DEMO_PROVIDER_WITHHOLDER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxPackageInputWithholdingEntityEnum>
    _$taxPackageInputWithholdingEntityEnumValues = BuiltSet<
        TaxPackageInputWithholdingEntityEnum>(const <TaxPackageInputWithholdingEntityEnum>[
  _$taxPackageInputWithholdingEntityEnum_DEMO_PLATFORM_WITHHOLDER,
  _$taxPackageInputWithholdingEntityEnum_DEMO_PROVIDER_WITHHOLDER,
]);

Serializer<TaxPackageInputFormEnum> _$taxPackageInputFormEnumSerializer =
    _$TaxPackageInputFormEnumSerializer();
Serializer<TaxPackageInputWithholdingEntityEnum>
    _$taxPackageInputWithholdingEntityEnumSerializer =
    _$TaxPackageInputWithholdingEntityEnumSerializer();

class _$TaxPackageInputFormEnumSerializer
    implements PrimitiveSerializer<TaxPackageInputFormEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n2307': '2307',
    'n0619e': '0619-E',
    'n1601eQ': '1601-EQ',
    'QAP': 'QAP',
    'n1604e': '1604-E',
    'ANNUAL_ALPHALIST': 'ANNUAL_ALPHALIST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '2307': 'n2307',
    '0619-E': 'n0619e',
    '1601-EQ': 'n1601eQ',
    'QAP': 'QAP',
    '1604-E': 'n1604e',
    'ANNUAL_ALPHALIST': 'ANNUAL_ALPHALIST',
  };

  @override
  final Iterable<Type> types = const <Type>[TaxPackageInputFormEnum];
  @override
  final String wireName = 'TaxPackageInputFormEnum';

  @override
  Object serialize(Serializers serializers, TaxPackageInputFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxPackageInputFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxPackageInputFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxPackageInputWithholdingEntityEnumSerializer
    implements PrimitiveSerializer<TaxPackageInputWithholdingEntityEnum> {
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
    TaxPackageInputWithholdingEntityEnum
  ];
  @override
  final String wireName = 'TaxPackageInputWithholdingEntityEnum';

  @override
  Object serialize(
          Serializers serializers, TaxPackageInputWithholdingEntityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxPackageInputWithholdingEntityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxPackageInputWithholdingEntityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxPackageInput extends TaxPackageInput {
  @override
  final TaxPackageInputFormEnum form;
  @override
  final String periodStart;
  @override
  final TaxPackageInputWithholdingEntityEnum withholdingEntity;
  @override
  final String? vendorOrganizationId;

  factory _$TaxPackageInput([void Function(TaxPackageInputBuilder)? updates]) =>
      (TaxPackageInputBuilder()..update(updates))._build();

  _$TaxPackageInput._(
      {required this.form,
      required this.periodStart,
      required this.withholdingEntity,
      this.vendorOrganizationId})
      : super._();
  @override
  TaxPackageInput rebuild(void Function(TaxPackageInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxPackageInputBuilder toBuilder() => TaxPackageInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxPackageInput &&
        form == other.form &&
        periodStart == other.periodStart &&
        withholdingEntity == other.withholdingEntity &&
        vendorOrganizationId == other.vendorOrganizationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, form.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, withholdingEntity.hashCode);
    _$hash = $jc(_$hash, vendorOrganizationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxPackageInput')
          ..add('form', form)
          ..add('periodStart', periodStart)
          ..add('withholdingEntity', withholdingEntity)
          ..add('vendorOrganizationId', vendorOrganizationId))
        .toString();
  }
}

class TaxPackageInputBuilder
    implements Builder<TaxPackageInput, TaxPackageInputBuilder> {
  _$TaxPackageInput? _$v;

  TaxPackageInputFormEnum? _form;
  TaxPackageInputFormEnum? get form => _$this._form;
  set form(TaxPackageInputFormEnum? form) => _$this._form = form;

  String? _periodStart;
  String? get periodStart => _$this._periodStart;
  set periodStart(String? periodStart) => _$this._periodStart = periodStart;

  TaxPackageInputWithholdingEntityEnum? _withholdingEntity;
  TaxPackageInputWithholdingEntityEnum? get withholdingEntity =>
      _$this._withholdingEntity;
  set withholdingEntity(
          TaxPackageInputWithholdingEntityEnum? withholdingEntity) =>
      _$this._withholdingEntity = withholdingEntity;

  String? _vendorOrganizationId;
  String? get vendorOrganizationId => _$this._vendorOrganizationId;
  set vendorOrganizationId(String? vendorOrganizationId) =>
      _$this._vendorOrganizationId = vendorOrganizationId;

  TaxPackageInputBuilder() {
    TaxPackageInput._defaults(this);
  }

  TaxPackageInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _form = $v.form;
      _periodStart = $v.periodStart;
      _withholdingEntity = $v.withholdingEntity;
      _vendorOrganizationId = $v.vendorOrganizationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxPackageInput other) {
    _$v = other as _$TaxPackageInput;
  }

  @override
  void update(void Function(TaxPackageInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxPackageInput build() => _build();

  _$TaxPackageInput _build() {
    final _$result = _$v ??
        _$TaxPackageInput._(
          form: BuiltValueNullFieldError.checkNotNull(
              form, r'TaxPackageInput', 'form'),
          periodStart: BuiltValueNullFieldError.checkNotNull(
              periodStart, r'TaxPackageInput', 'periodStart'),
          withholdingEntity: BuiltValueNullFieldError.checkNotNull(
              withholdingEntity, r'TaxPackageInput', 'withholdingEntity'),
          vendorOrganizationId: vendorOrganizationId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
