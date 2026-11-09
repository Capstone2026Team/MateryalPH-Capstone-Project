// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_register_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingRegisterEnvelope extends WithholdingRegisterEnvelope {
  @override
  final WithholdingRegister data;
  @override
  final WithholdingVendorDetailEnvelopeMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$WithholdingRegisterEnvelope(
          [void Function(WithholdingRegisterEnvelopeBuilder)? updates]) =>
      (WithholdingRegisterEnvelopeBuilder()..update(updates))._build();

  _$WithholdingRegisterEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  WithholdingRegisterEnvelope rebuild(
          void Function(WithholdingRegisterEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingRegisterEnvelopeBuilder toBuilder() =>
      WithholdingRegisterEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingRegisterEnvelope &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingRegisterEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class WithholdingRegisterEnvelopeBuilder
    implements
        Builder<WithholdingRegisterEnvelope,
            WithholdingRegisterEnvelopeBuilder> {
  _$WithholdingRegisterEnvelope? _$v;

  WithholdingRegisterBuilder? _data;
  WithholdingRegisterBuilder get data =>
      _$this._data ??= WithholdingRegisterBuilder();
  set data(WithholdingRegisterBuilder? data) => _$this._data = data;

  WithholdingVendorDetailEnvelopeMetaBuilder? _meta;
  WithholdingVendorDetailEnvelopeMetaBuilder get meta =>
      _$this._meta ??= WithholdingVendorDetailEnvelopeMetaBuilder();
  set meta(WithholdingVendorDetailEnvelopeMetaBuilder? meta) =>
      _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  WithholdingRegisterEnvelopeBuilder() {
    WithholdingRegisterEnvelope._defaults(this);
  }

  WithholdingRegisterEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingRegisterEnvelope other) {
    _$v = other as _$WithholdingRegisterEnvelope;
  }

  @override
  void update(void Function(WithholdingRegisterEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingRegisterEnvelope build() => _build();

  _$WithholdingRegisterEnvelope _build() {
    _$WithholdingRegisterEnvelope _$result;
    try {
      _$result = _$v ??
          _$WithholdingRegisterEnvelope._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingRegisterEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
