// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_send_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceSendInput extends InvoiceSendInput {
  @override
  final int lockVersion;

  factory _$InvoiceSendInput(
          [void Function(InvoiceSendInputBuilder)? updates]) =>
      (InvoiceSendInputBuilder()..update(updates))._build();

  _$InvoiceSendInput._({required this.lockVersion}) : super._();
  @override
  InvoiceSendInput rebuild(void Function(InvoiceSendInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceSendInputBuilder toBuilder() =>
      InvoiceSendInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceSendInput && lockVersion == other.lockVersion;
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
    return (newBuiltValueToStringHelper(r'InvoiceSendInput')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class InvoiceSendInputBuilder
    implements Builder<InvoiceSendInput, InvoiceSendInputBuilder> {
  _$InvoiceSendInput? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  InvoiceSendInputBuilder() {
    InvoiceSendInput._defaults(this);
  }

  InvoiceSendInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceSendInput other) {
    _$v = other as _$InvoiceSendInput;
  }

  @override
  void update(void Function(InvoiceSendInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceSendInput build() => _build();

  _$InvoiceSendInput _build() {
    final _$result = _$v ??
        _$InvoiceSendInput._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'InvoiceSendInput', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
