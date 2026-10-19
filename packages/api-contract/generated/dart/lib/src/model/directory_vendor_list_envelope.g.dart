// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorListEnvelope extends DirectoryVendorListEnvelope {
  @override
  final BuiltList<DirectoryVendorRow> data;
  @override
  final DirectoryPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DirectoryVendorListEnvelope(
          [void Function(DirectoryVendorListEnvelopeBuilder)? updates]) =>
      (DirectoryVendorListEnvelopeBuilder()..update(updates))._build();

  _$DirectoryVendorListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DirectoryVendorListEnvelope rebuild(
          void Function(DirectoryVendorListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorListEnvelopeBuilder toBuilder() =>
      DirectoryVendorListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DirectoryVendorListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DirectoryVendorListEnvelopeBuilder
    implements
        Builder<DirectoryVendorListEnvelope,
            DirectoryVendorListEnvelopeBuilder> {
  _$DirectoryVendorListEnvelope? _$v;

  ListBuilder<DirectoryVendorRow>? _data;
  ListBuilder<DirectoryVendorRow> get data =>
      _$this._data ??= ListBuilder<DirectoryVendorRow>();
  set data(ListBuilder<DirectoryVendorRow>? data) => _$this._data = data;

  DirectoryPageMetaBuilder? _meta;
  DirectoryPageMetaBuilder get meta =>
      _$this._meta ??= DirectoryPageMetaBuilder();
  set meta(DirectoryPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DirectoryVendorListEnvelopeBuilder() {
    DirectoryVendorListEnvelope._defaults(this);
  }

  DirectoryVendorListEnvelopeBuilder get _$this {
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
  void replace(DirectoryVendorListEnvelope other) {
    _$v = other as _$DirectoryVendorListEnvelope;
  }

  @override
  void update(void Function(DirectoryVendorListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorListEnvelope build() => _build();

  _$DirectoryVendorListEnvelope _build() {
    _$DirectoryVendorListEnvelope _$result;
    try {
      _$result = _$v ??
          _$DirectoryVendorListEnvelope._(
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
            r'DirectoryVendorListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
