// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_order_quotation_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PendingOrderQuotationInput extends PendingOrderQuotationInput {
  @override
  final int lockVersion;

  factory _$PendingOrderQuotationInput(
          [void Function(PendingOrderQuotationInputBuilder)? updates]) =>
      (PendingOrderQuotationInputBuilder()..update(updates))._build();

  _$PendingOrderQuotationInput._({required this.lockVersion}) : super._();
  @override
  PendingOrderQuotationInput rebuild(
          void Function(PendingOrderQuotationInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PendingOrderQuotationInputBuilder toBuilder() =>
      PendingOrderQuotationInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PendingOrderQuotationInput &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PendingOrderQuotationInput')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class PendingOrderQuotationInputBuilder
    implements
        Builder<PendingOrderQuotationInput, PendingOrderQuotationInputBuilder> {
  _$PendingOrderQuotationInput? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  PendingOrderQuotationInputBuilder() {
    PendingOrderQuotationInput._defaults(this);
  }

  PendingOrderQuotationInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PendingOrderQuotationInput other) {
    _$v = other as _$PendingOrderQuotationInput;
  }

  @override
  void update(void Function(PendingOrderQuotationInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PendingOrderQuotationInput build() => _build();

  _$PendingOrderQuotationInput _build() {
    final _$result = _$v ??
        _$PendingOrderQuotationInput._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'PendingOrderQuotationInput', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
