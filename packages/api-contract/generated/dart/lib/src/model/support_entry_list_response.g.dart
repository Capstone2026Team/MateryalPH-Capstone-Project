// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_entry_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportEntryListResponse extends SupportEntryListResponse {
  @override
  final BuiltList<SupportEntry> data;
  @override
  final SupportPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportEntryListResponse(
          [void Function(SupportEntryListResponseBuilder)? updates]) =>
      (SupportEntryListResponseBuilder()..update(updates))._build();

  _$SupportEntryListResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportEntryListResponse rebuild(
          void Function(SupportEntryListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportEntryListResponseBuilder toBuilder() =>
      SupportEntryListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportEntryListResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportEntryListResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportEntryListResponseBuilder
    implements
        Builder<SupportEntryListResponse, SupportEntryListResponseBuilder> {
  _$SupportEntryListResponse? _$v;

  ListBuilder<SupportEntry>? _data;
  ListBuilder<SupportEntry> get data =>
      _$this._data ??= ListBuilder<SupportEntry>();
  set data(ListBuilder<SupportEntry>? data) => _$this._data = data;

  SupportPageMetaBuilder? _meta;
  SupportPageMetaBuilder get meta => _$this._meta ??= SupportPageMetaBuilder();
  set meta(SupportPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportEntryListResponseBuilder() {
    SupportEntryListResponse._defaults(this);
  }

  SupportEntryListResponseBuilder get _$this {
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
  void replace(SupportEntryListResponse other) {
    _$v = other as _$SupportEntryListResponse;
  }

  @override
  void update(void Function(SupportEntryListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportEntryListResponse build() => _build();

  _$SupportEntryListResponse _build() {
    _$SupportEntryListResponse _$result;
    try {
      _$result = _$v ??
          _$SupportEntryListResponse._(
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
            r'SupportEntryListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
