// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_closure_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderClosureReason extends OrderClosureReason {
  @override
  final String code;
  @override
  final String label;

  factory _$OrderClosureReason(
          [void Function(OrderClosureReasonBuilder)? updates]) =>
      (OrderClosureReasonBuilder()..update(updates))._build();

  _$OrderClosureReason._({required this.code, required this.label}) : super._();
  @override
  OrderClosureReason rebuild(
          void Function(OrderClosureReasonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderClosureReasonBuilder toBuilder() =>
      OrderClosureReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderClosureReason &&
        code == other.code &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderClosureReason')
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class OrderClosureReasonBuilder
    implements Builder<OrderClosureReason, OrderClosureReasonBuilder> {
  _$OrderClosureReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  OrderClosureReasonBuilder() {
    OrderClosureReason._defaults(this);
  }

  OrderClosureReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderClosureReason other) {
    _$v = other as _$OrderClosureReason;
  }

  @override
  void update(void Function(OrderClosureReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderClosureReason build() => _build();

  _$OrderClosureReason _build() {
    final _$result = _$v ??
        _$OrderClosureReason._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'OrderClosureReason', 'code'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OrderClosureReason', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
