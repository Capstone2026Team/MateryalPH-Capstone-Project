// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionListResponse extends SiteInspectionListResponse {
  @override
  final SiteInspectionListResponseData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SiteInspectionListResponse(
          [void Function(SiteInspectionListResponseBuilder)? updates]) =>
      (SiteInspectionListResponseBuilder()..update(updates))._build();

  _$SiteInspectionListResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SiteInspectionListResponse rebuild(
          void Function(SiteInspectionListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionListResponseBuilder toBuilder() =>
      SiteInspectionListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionListResponse &&
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
    return (newBuiltValueToStringHelper(r'SiteInspectionListResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SiteInspectionListResponseBuilder
    implements
        Builder<SiteInspectionListResponse, SiteInspectionListResponseBuilder> {
  _$SiteInspectionListResponse? _$v;

  SiteInspectionListResponseDataBuilder? _data;
  SiteInspectionListResponseDataBuilder get data =>
      _$this._data ??= SiteInspectionListResponseDataBuilder();
  set data(SiteInspectionListResponseDataBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SiteInspectionListResponseBuilder() {
    SiteInspectionListResponse._defaults(this);
  }

  SiteInspectionListResponseBuilder get _$this {
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
  void replace(SiteInspectionListResponse other) {
    _$v = other as _$SiteInspectionListResponse;
  }

  @override
  void update(void Function(SiteInspectionListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionListResponse build() => _build();

  _$SiteInspectionListResponse _build() {
    _$SiteInspectionListResponse _$result;
    try {
      _$result = _$v ??
          _$SiteInspectionListResponse._(
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
            r'SiteInspectionListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
