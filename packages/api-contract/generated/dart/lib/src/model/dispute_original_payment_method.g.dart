// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_original_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeOriginalPaymentMethod extends DisputeOriginalPaymentMethod {
  @override
  final String label;
  @override
  final bool physical;
  @override
  final String notice;

  factory _$DisputeOriginalPaymentMethod(
          [void Function(DisputeOriginalPaymentMethodBuilder)? updates]) =>
      (DisputeOriginalPaymentMethodBuilder()..update(updates))._build();

  _$DisputeOriginalPaymentMethod._(
      {required this.label, required this.physical, required this.notice})
      : super._();
  @override
  DisputeOriginalPaymentMethod rebuild(
          void Function(DisputeOriginalPaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeOriginalPaymentMethodBuilder toBuilder() =>
      DisputeOriginalPaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeOriginalPaymentMethod &&
        label == other.label &&
        physical == other.physical &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, physical.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeOriginalPaymentMethod')
          ..add('label', label)
          ..add('physical', physical)
          ..add('notice', notice))
        .toString();
  }
}

class DisputeOriginalPaymentMethodBuilder
    implements
        Builder<DisputeOriginalPaymentMethod,
            DisputeOriginalPaymentMethodBuilder> {
  _$DisputeOriginalPaymentMethod? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _physical;
  bool? get physical => _$this._physical;
  set physical(bool? physical) => _$this._physical = physical;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  DisputeOriginalPaymentMethodBuilder() {
    DisputeOriginalPaymentMethod._defaults(this);
  }

  DisputeOriginalPaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _physical = $v.physical;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeOriginalPaymentMethod other) {
    _$v = other as _$DisputeOriginalPaymentMethod;
  }

  @override
  void update(void Function(DisputeOriginalPaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeOriginalPaymentMethod build() => _build();

  _$DisputeOriginalPaymentMethod _build() {
    final _$result = _$v ??
        _$DisputeOriginalPaymentMethod._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DisputeOriginalPaymentMethod', 'label'),
          physical: BuiltValueNullFieldError.checkNotNull(
              physical, r'DisputeOriginalPaymentMethod', 'physical'),
          notice: BuiltValueNullFieldError.checkNotNull(
              notice, r'DisputeOriginalPaymentMethod', 'notice'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
