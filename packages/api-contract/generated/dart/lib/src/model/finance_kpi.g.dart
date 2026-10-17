// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_kpi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceKpi extends FinanceKpi {
  @override
  final String key;
  @override
  final String label;
  @override
  final int valueCentavos;
  @override
  final String definition;

  factory _$FinanceKpi([void Function(FinanceKpiBuilder)? updates]) =>
      (FinanceKpiBuilder()..update(updates))._build();

  _$FinanceKpi._(
      {required this.key,
      required this.label,
      required this.valueCentavos,
      required this.definition})
      : super._();
  @override
  FinanceKpi rebuild(void Function(FinanceKpiBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceKpiBuilder toBuilder() => FinanceKpiBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceKpi &&
        key == other.key &&
        label == other.label &&
        valueCentavos == other.valueCentavos &&
        definition == other.definition;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jc(_$hash, definition.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceKpi')
          ..add('key', key)
          ..add('label', label)
          ..add('valueCentavos', valueCentavos)
          ..add('definition', definition))
        .toString();
  }
}

class FinanceKpiBuilder implements Builder<FinanceKpi, FinanceKpiBuilder> {
  _$FinanceKpi? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  String? _definition;
  String? get definition => _$this._definition;
  set definition(String? definition) => _$this._definition = definition;

  FinanceKpiBuilder() {
    FinanceKpi._defaults(this);
  }

  FinanceKpiBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _valueCentavos = $v.valueCentavos;
      _definition = $v.definition;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceKpi other) {
    _$v = other as _$FinanceKpi;
  }

  @override
  void update(void Function(FinanceKpiBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceKpi build() => _build();

  _$FinanceKpi _build() {
    final _$result = _$v ??
        _$FinanceKpi._(
          key: BuiltValueNullFieldError.checkNotNull(key, r'FinanceKpi', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'FinanceKpi', 'label'),
          valueCentavos: BuiltValueNullFieldError.checkNotNull(
              valueCentavos, r'FinanceKpi', 'valueCentavos'),
          definition: BuiltValueNullFieldError.checkNotNull(
              definition, r'FinanceKpi', 'definition'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
