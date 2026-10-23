// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinancePaymentMethodKindEnum _$financePaymentMethodKindEnum_ONLINE =
    const FinancePaymentMethodKindEnum._('ONLINE');
const FinancePaymentMethodKindEnum _$financePaymentMethodKindEnum_PHYSICAL =
    const FinancePaymentMethodKindEnum._('PHYSICAL');

FinancePaymentMethodKindEnum _$financePaymentMethodKindEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$financePaymentMethodKindEnum_ONLINE;
    case 'PHYSICAL':
      return _$financePaymentMethodKindEnum_PHYSICAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancePaymentMethodKindEnum>
    _$financePaymentMethodKindEnumValues =
    BuiltSet<FinancePaymentMethodKindEnum>(const <FinancePaymentMethodKindEnum>[
  _$financePaymentMethodKindEnum_ONLINE,
  _$financePaymentMethodKindEnum_PHYSICAL,
]);

Serializer<FinancePaymentMethodKindEnum>
    _$financePaymentMethodKindEnumSerializer =
    _$FinancePaymentMethodKindEnumSerializer();

class _$FinancePaymentMethodKindEnumSerializer
    implements PrimitiveSerializer<FinancePaymentMethodKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'PHYSICAL': 'PHYSICAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'PHYSICAL': 'PHYSICAL',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancePaymentMethodKindEnum];
  @override
  final String wireName = 'FinancePaymentMethodKindEnum';

  @override
  Object serialize(Serializers serializers, FinancePaymentMethodKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancePaymentMethodKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancePaymentMethodKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancePaymentMethod extends FinancePaymentMethod {
  @override
  final String method;
  @override
  final String label;
  @override
  final FinancePaymentMethodKindEnum kind;
  @override
  final int payments;
  @override
  final int amountCentavos;

  factory _$FinancePaymentMethod(
          [void Function(FinancePaymentMethodBuilder)? updates]) =>
      (FinancePaymentMethodBuilder()..update(updates))._build();

  _$FinancePaymentMethod._(
      {required this.method,
      required this.label,
      required this.kind,
      required this.payments,
      required this.amountCentavos})
      : super._();
  @override
  FinancePaymentMethod rebuild(
          void Function(FinancePaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinancePaymentMethodBuilder toBuilder() =>
      FinancePaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinancePaymentMethod &&
        method == other.method &&
        label == other.label &&
        kind == other.kind &&
        payments == other.payments &&
        amountCentavos == other.amountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinancePaymentMethod')
          ..add('method', method)
          ..add('label', label)
          ..add('kind', kind)
          ..add('payments', payments)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class FinancePaymentMethodBuilder
    implements Builder<FinancePaymentMethod, FinancePaymentMethodBuilder> {
  _$FinancePaymentMethod? _$v;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  FinancePaymentMethodKindEnum? _kind;
  FinancePaymentMethodKindEnum? get kind => _$this._kind;
  set kind(FinancePaymentMethodKindEnum? kind) => _$this._kind = kind;

  int? _payments;
  int? get payments => _$this._payments;
  set payments(int? payments) => _$this._payments = payments;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  FinancePaymentMethodBuilder() {
    FinancePaymentMethod._defaults(this);
  }

  FinancePaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _method = $v.method;
      _label = $v.label;
      _kind = $v.kind;
      _payments = $v.payments;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinancePaymentMethod other) {
    _$v = other as _$FinancePaymentMethod;
  }

  @override
  void update(void Function(FinancePaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinancePaymentMethod build() => _build();

  _$FinancePaymentMethod _build() {
    final _$result = _$v ??
        _$FinancePaymentMethod._(
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'FinancePaymentMethod', 'method'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'FinancePaymentMethod', 'label'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'FinancePaymentMethod', 'kind'),
          payments: BuiltValueNullFieldError.checkNotNull(
              payments, r'FinancePaymentMethod', 'payments'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'FinancePaymentMethod', 'amountCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
