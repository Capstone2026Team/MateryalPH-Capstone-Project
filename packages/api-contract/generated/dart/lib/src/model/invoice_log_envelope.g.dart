// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_log_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceLogEnvelope extends InvoiceLogEnvelope {
  @override
  final BuiltList<InvoiceLogRow> data;
  @override
  final InvoiceListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$InvoiceLogEnvelope(
          [void Function(InvoiceLogEnvelopeBuilder)? updates]) =>
      (InvoiceLogEnvelopeBuilder()..update(updates))._build();

  _$InvoiceLogEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InvoiceLogEnvelope rebuild(
          void Function(InvoiceLogEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceLogEnvelopeBuilder toBuilder() =>
      InvoiceLogEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceLogEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InvoiceLogEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InvoiceLogEnvelopeBuilder
    implements Builder<InvoiceLogEnvelope, InvoiceLogEnvelopeBuilder> {
  _$InvoiceLogEnvelope? _$v;

  ListBuilder<InvoiceLogRow>? _data;
  ListBuilder<InvoiceLogRow> get data =>
      _$this._data ??= ListBuilder<InvoiceLogRow>();
  set data(ListBuilder<InvoiceLogRow>? data) => _$this._data = data;

  InvoiceListMetaBuilder? _meta;
  InvoiceListMetaBuilder get meta => _$this._meta ??= InvoiceListMetaBuilder();
  set meta(InvoiceListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  InvoiceLogEnvelopeBuilder() {
    InvoiceLogEnvelope._defaults(this);
  }

  InvoiceLogEnvelopeBuilder get _$this {
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
  void replace(InvoiceLogEnvelope other) {
    _$v = other as _$InvoiceLogEnvelope;
  }

  @override
  void update(void Function(InvoiceLogEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceLogEnvelope build() => _build();

  _$InvoiceLogEnvelope _build() {
    _$InvoiceLogEnvelope _$result;
    try {
      _$result = _$v ??
          _$InvoiceLogEnvelope._(
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
            r'InvoiceLogEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
