// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerListEnvelope extends DirectoryBuyerListEnvelope {
  @override
  final BuiltList<DirectoryBuyerRow> data;
  @override
  final DirectoryPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DirectoryBuyerListEnvelope(
          [void Function(DirectoryBuyerListEnvelopeBuilder)? updates]) =>
      (DirectoryBuyerListEnvelopeBuilder()..update(updates))._build();

  _$DirectoryBuyerListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DirectoryBuyerListEnvelope rebuild(
          void Function(DirectoryBuyerListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerListEnvelopeBuilder toBuilder() =>
      DirectoryBuyerListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DirectoryBuyerListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DirectoryBuyerListEnvelopeBuilder
    implements
        Builder<DirectoryBuyerListEnvelope, DirectoryBuyerListEnvelopeBuilder> {
  _$DirectoryBuyerListEnvelope? _$v;

  ListBuilder<DirectoryBuyerRow>? _data;
  ListBuilder<DirectoryBuyerRow> get data =>
      _$this._data ??= ListBuilder<DirectoryBuyerRow>();
  set data(ListBuilder<DirectoryBuyerRow>? data) => _$this._data = data;

  DirectoryPageMetaBuilder? _meta;
  DirectoryPageMetaBuilder get meta =>
      _$this._meta ??= DirectoryPageMetaBuilder();
  set meta(DirectoryPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DirectoryBuyerListEnvelopeBuilder() {
    DirectoryBuyerListEnvelope._defaults(this);
  }

  DirectoryBuyerListEnvelopeBuilder get _$this {
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
  void replace(DirectoryBuyerListEnvelope other) {
    _$v = other as _$DirectoryBuyerListEnvelope;
  }

  @override
  void update(void Function(DirectoryBuyerListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerListEnvelope build() => _build();

  _$DirectoryBuyerListEnvelope _build() {
    _$DirectoryBuyerListEnvelope _$result;
    try {
      _$result = _$v ??
          _$DirectoryBuyerListEnvelope._(
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
            r'DirectoryBuyerListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
