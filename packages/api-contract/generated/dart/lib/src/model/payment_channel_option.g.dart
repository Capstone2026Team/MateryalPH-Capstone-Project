// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_channel_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentChannelOptionKindEnum _$paymentChannelOptionKindEnum_CARD =
    const PaymentChannelOptionKindEnum._('CARD');
const PaymentChannelOptionKindEnum _$paymentChannelOptionKindEnum_EWALLET =
    const PaymentChannelOptionKindEnum._('EWALLET');
const PaymentChannelOptionKindEnum _$paymentChannelOptionKindEnum_QR =
    const PaymentChannelOptionKindEnum._('QR');
const PaymentChannelOptionKindEnum
    _$paymentChannelOptionKindEnum_OVER_THE_COUNTER =
    const PaymentChannelOptionKindEnum._('OVER_THE_COUNTER');
const PaymentChannelOptionKindEnum _$paymentChannelOptionKindEnum_DIRECT_DEBIT =
    const PaymentChannelOptionKindEnum._('DIRECT_DEBIT');
const PaymentChannelOptionKindEnum
    _$paymentChannelOptionKindEnum_BANK_TRANSFER =
    const PaymentChannelOptionKindEnum._('BANK_TRANSFER');

PaymentChannelOptionKindEnum _$paymentChannelOptionKindEnumValueOf(
    String name) {
  switch (name) {
    case 'CARD':
      return _$paymentChannelOptionKindEnum_CARD;
    case 'EWALLET':
      return _$paymentChannelOptionKindEnum_EWALLET;
    case 'QR':
      return _$paymentChannelOptionKindEnum_QR;
    case 'OVER_THE_COUNTER':
      return _$paymentChannelOptionKindEnum_OVER_THE_COUNTER;
    case 'DIRECT_DEBIT':
      return _$paymentChannelOptionKindEnum_DIRECT_DEBIT;
    case 'BANK_TRANSFER':
      return _$paymentChannelOptionKindEnum_BANK_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentChannelOptionKindEnum>
    _$paymentChannelOptionKindEnumValues =
    BuiltSet<PaymentChannelOptionKindEnum>(const <PaymentChannelOptionKindEnum>[
  _$paymentChannelOptionKindEnum_CARD,
  _$paymentChannelOptionKindEnum_EWALLET,
  _$paymentChannelOptionKindEnum_QR,
  _$paymentChannelOptionKindEnum_OVER_THE_COUNTER,
  _$paymentChannelOptionKindEnum_DIRECT_DEBIT,
  _$paymentChannelOptionKindEnum_BANK_TRANSFER,
]);

const PaymentChannelOptionFeeBearerEnum
    _$paymentChannelOptionFeeBearerEnum_BUYER =
    const PaymentChannelOptionFeeBearerEnum._('BUYER');
const PaymentChannelOptionFeeBearerEnum
    _$paymentChannelOptionFeeBearerEnum_PLATFORM =
    const PaymentChannelOptionFeeBearerEnum._('PLATFORM');

PaymentChannelOptionFeeBearerEnum _$paymentChannelOptionFeeBearerEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$paymentChannelOptionFeeBearerEnum_BUYER;
    case 'PLATFORM':
      return _$paymentChannelOptionFeeBearerEnum_PLATFORM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentChannelOptionFeeBearerEnum>
    _$paymentChannelOptionFeeBearerEnumValues = BuiltSet<
        PaymentChannelOptionFeeBearerEnum>(const <PaymentChannelOptionFeeBearerEnum>[
  _$paymentChannelOptionFeeBearerEnum_BUYER,
  _$paymentChannelOptionFeeBearerEnum_PLATFORM,
]);

const PaymentChannelOptionRateSourceEnum
    _$paymentChannelOptionRateSourceEnum_DEMO_PUBLISHED_RATE =
    const PaymentChannelOptionRateSourceEnum._('DEMO_PUBLISHED_RATE');

PaymentChannelOptionRateSourceEnum _$paymentChannelOptionRateSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'DEMO_PUBLISHED_RATE':
      return _$paymentChannelOptionRateSourceEnum_DEMO_PUBLISHED_RATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentChannelOptionRateSourceEnum>
    _$paymentChannelOptionRateSourceEnumValues = BuiltSet<
        PaymentChannelOptionRateSourceEnum>(const <PaymentChannelOptionRateSourceEnum>[
  _$paymentChannelOptionRateSourceEnum_DEMO_PUBLISHED_RATE,
]);

Serializer<PaymentChannelOptionKindEnum>
    _$paymentChannelOptionKindEnumSerializer =
    _$PaymentChannelOptionKindEnumSerializer();
Serializer<PaymentChannelOptionFeeBearerEnum>
    _$paymentChannelOptionFeeBearerEnumSerializer =
    _$PaymentChannelOptionFeeBearerEnumSerializer();
Serializer<PaymentChannelOptionRateSourceEnum>
    _$paymentChannelOptionRateSourceEnumSerializer =
    _$PaymentChannelOptionRateSourceEnumSerializer();

class _$PaymentChannelOptionKindEnumSerializer
    implements PrimitiveSerializer<PaymentChannelOptionKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CARD': 'CARD',
    'EWALLET': 'EWALLET',
    'QR': 'QR',
    'OVER_THE_COUNTER': 'OVER_THE_COUNTER',
    'DIRECT_DEBIT': 'DIRECT_DEBIT',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CARD': 'CARD',
    'EWALLET': 'EWALLET',
    'QR': 'QR',
    'OVER_THE_COUNTER': 'OVER_THE_COUNTER',
    'DIRECT_DEBIT': 'DIRECT_DEBIT',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentChannelOptionKindEnum];
  @override
  final String wireName = 'PaymentChannelOptionKindEnum';

  @override
  Object serialize(Serializers serializers, PaymentChannelOptionKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentChannelOptionKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentChannelOptionKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentChannelOptionFeeBearerEnumSerializer
    implements PrimitiveSerializer<PaymentChannelOptionFeeBearerEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'PLATFORM': 'PLATFORM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'PLATFORM': 'PLATFORM',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentChannelOptionFeeBearerEnum];
  @override
  final String wireName = 'PaymentChannelOptionFeeBearerEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentChannelOptionFeeBearerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentChannelOptionFeeBearerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentChannelOptionFeeBearerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentChannelOptionRateSourceEnumSerializer
    implements PrimitiveSerializer<PaymentChannelOptionRateSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEMO_PUBLISHED_RATE': 'DEMO_PUBLISHED_RATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEMO_PUBLISHED_RATE': 'DEMO_PUBLISHED_RATE',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentChannelOptionRateSourceEnum];
  @override
  final String wireName = 'PaymentChannelOptionRateSourceEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentChannelOptionRateSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentChannelOptionRateSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentChannelOptionRateSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentChannelOption extends PaymentChannelOption {
  @override
  final String code;
  @override
  final String displayName;
  @override
  final PaymentChannelOptionKindEnum kind;
  @override
  final bool available;
  @override
  final String? unavailableReason;
  @override
  final bool refundSupported;
  @override
  final int feeVersion;
  @override
  final String rateLabel;
  @override
  final int? feeCentavos;
  @override
  final int? totalCentavos;
  @override
  final PaymentChannelOptionFeeBearerEnum feeBearer;
  @override
  final PaymentChannelOptionRateSourceEnum rateSource;

  factory _$PaymentChannelOption(
          [void Function(PaymentChannelOptionBuilder)? updates]) =>
      (PaymentChannelOptionBuilder()..update(updates))._build();

  _$PaymentChannelOption._(
      {required this.code,
      required this.displayName,
      required this.kind,
      required this.available,
      this.unavailableReason,
      required this.refundSupported,
      required this.feeVersion,
      required this.rateLabel,
      this.feeCentavos,
      this.totalCentavos,
      required this.feeBearer,
      required this.rateSource})
      : super._();
  @override
  PaymentChannelOption rebuild(
          void Function(PaymentChannelOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentChannelOptionBuilder toBuilder() =>
      PaymentChannelOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentChannelOption &&
        code == other.code &&
        displayName == other.displayName &&
        kind == other.kind &&
        available == other.available &&
        unavailableReason == other.unavailableReason &&
        refundSupported == other.refundSupported &&
        feeVersion == other.feeVersion &&
        rateLabel == other.rateLabel &&
        feeCentavos == other.feeCentavos &&
        totalCentavos == other.totalCentavos &&
        feeBearer == other.feeBearer &&
        rateSource == other.rateSource;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, unavailableReason.hashCode);
    _$hash = $jc(_$hash, refundSupported.hashCode);
    _$hash = $jc(_$hash, feeVersion.hashCode);
    _$hash = $jc(_$hash, rateLabel.hashCode);
    _$hash = $jc(_$hash, feeCentavos.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jc(_$hash, feeBearer.hashCode);
    _$hash = $jc(_$hash, rateSource.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentChannelOption')
          ..add('code', code)
          ..add('displayName', displayName)
          ..add('kind', kind)
          ..add('available', available)
          ..add('unavailableReason', unavailableReason)
          ..add('refundSupported', refundSupported)
          ..add('feeVersion', feeVersion)
          ..add('rateLabel', rateLabel)
          ..add('feeCentavos', feeCentavos)
          ..add('totalCentavos', totalCentavos)
          ..add('feeBearer', feeBearer)
          ..add('rateSource', rateSource))
        .toString();
  }
}

class PaymentChannelOptionBuilder
    implements Builder<PaymentChannelOption, PaymentChannelOptionBuilder> {
  _$PaymentChannelOption? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  PaymentChannelOptionKindEnum? _kind;
  PaymentChannelOptionKindEnum? get kind => _$this._kind;
  set kind(PaymentChannelOptionKindEnum? kind) => _$this._kind = kind;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _unavailableReason;
  String? get unavailableReason => _$this._unavailableReason;
  set unavailableReason(String? unavailableReason) =>
      _$this._unavailableReason = unavailableReason;

  bool? _refundSupported;
  bool? get refundSupported => _$this._refundSupported;
  set refundSupported(bool? refundSupported) =>
      _$this._refundSupported = refundSupported;

  int? _feeVersion;
  int? get feeVersion => _$this._feeVersion;
  set feeVersion(int? feeVersion) => _$this._feeVersion = feeVersion;

  String? _rateLabel;
  String? get rateLabel => _$this._rateLabel;
  set rateLabel(String? rateLabel) => _$this._rateLabel = rateLabel;

  int? _feeCentavos;
  int? get feeCentavos => _$this._feeCentavos;
  set feeCentavos(int? feeCentavos) => _$this._feeCentavos = feeCentavos;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  PaymentChannelOptionFeeBearerEnum? _feeBearer;
  PaymentChannelOptionFeeBearerEnum? get feeBearer => _$this._feeBearer;
  set feeBearer(PaymentChannelOptionFeeBearerEnum? feeBearer) =>
      _$this._feeBearer = feeBearer;

  PaymentChannelOptionRateSourceEnum? _rateSource;
  PaymentChannelOptionRateSourceEnum? get rateSource => _$this._rateSource;
  set rateSource(PaymentChannelOptionRateSourceEnum? rateSource) =>
      _$this._rateSource = rateSource;

  PaymentChannelOptionBuilder() {
    PaymentChannelOption._defaults(this);
  }

  PaymentChannelOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _displayName = $v.displayName;
      _kind = $v.kind;
      _available = $v.available;
      _unavailableReason = $v.unavailableReason;
      _refundSupported = $v.refundSupported;
      _feeVersion = $v.feeVersion;
      _rateLabel = $v.rateLabel;
      _feeCentavos = $v.feeCentavos;
      _totalCentavos = $v.totalCentavos;
      _feeBearer = $v.feeBearer;
      _rateSource = $v.rateSource;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentChannelOption other) {
    _$v = other as _$PaymentChannelOption;
  }

  @override
  void update(void Function(PaymentChannelOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentChannelOption build() => _build();

  _$PaymentChannelOption _build() {
    final _$result = _$v ??
        _$PaymentChannelOption._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PaymentChannelOption', 'code'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'PaymentChannelOption', 'displayName'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'PaymentChannelOption', 'kind'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'PaymentChannelOption', 'available'),
          unavailableReason: unavailableReason,
          refundSupported: BuiltValueNullFieldError.checkNotNull(
              refundSupported, r'PaymentChannelOption', 'refundSupported'),
          feeVersion: BuiltValueNullFieldError.checkNotNull(
              feeVersion, r'PaymentChannelOption', 'feeVersion'),
          rateLabel: BuiltValueNullFieldError.checkNotNull(
              rateLabel, r'PaymentChannelOption', 'rateLabel'),
          feeCentavos: feeCentavos,
          totalCentavos: totalCentavos,
          feeBearer: BuiltValueNullFieldError.checkNotNull(
              feeBearer, r'PaymentChannelOption', 'feeBearer'),
          rateSource: BuiltValueNullFieldError.checkNotNull(
              rateSource, r'PaymentChannelOption', 'rateSource'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
