// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_refundable.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeRefundable extends DisputeRefundable {
  @override
  final int onlineCentavos;
  @override
  final int cashCentavos;

  factory _$DisputeRefundable(
          [void Function(DisputeRefundableBuilder)? updates]) =>
      (DisputeRefundableBuilder()..update(updates))._build();

  _$DisputeRefundable._(
      {required this.onlineCentavos, required this.cashCentavos})
      : super._();
  @override
  DisputeRefundable rebuild(void Function(DisputeRefundableBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeRefundableBuilder toBuilder() =>
      DisputeRefundableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeRefundable &&
        onlineCentavos == other.onlineCentavos &&
        cashCentavos == other.cashCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, onlineCentavos.hashCode);
    _$hash = $jc(_$hash, cashCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeRefundable')
          ..add('onlineCentavos', onlineCentavos)
          ..add('cashCentavos', cashCentavos))
        .toString();
  }
}

class DisputeRefundableBuilder
    implements Builder<DisputeRefundable, DisputeRefundableBuilder> {
  _$DisputeRefundable? _$v;

  int? _onlineCentavos;
  int? get onlineCentavos => _$this._onlineCentavos;
  set onlineCentavos(int? onlineCentavos) =>
      _$this._onlineCentavos = onlineCentavos;

  int? _cashCentavos;
  int? get cashCentavos => _$this._cashCentavos;
  set cashCentavos(int? cashCentavos) => _$this._cashCentavos = cashCentavos;

  DisputeRefundableBuilder() {
    DisputeRefundable._defaults(this);
  }

  DisputeRefundableBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _onlineCentavos = $v.onlineCentavos;
      _cashCentavos = $v.cashCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeRefundable other) {
    _$v = other as _$DisputeRefundable;
  }

  @override
  void update(void Function(DisputeRefundableBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeRefundable build() => _build();

  _$DisputeRefundable _build() {
    final _$result = _$v ??
        _$DisputeRefundable._(
          onlineCentavos: BuiltValueNullFieldError.checkNotNull(
              onlineCentavos, r'DisputeRefundable', 'onlineCentavos'),
          cashCentavos: BuiltValueNullFieldError.checkNotNull(
              cashCentavos, r'DisputeRefundable', 'cashCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
