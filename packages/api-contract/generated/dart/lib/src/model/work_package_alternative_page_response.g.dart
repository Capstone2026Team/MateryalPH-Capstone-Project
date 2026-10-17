// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageAlternativePageResponse
    extends WorkPackageAlternativePageResponse {
  @override
  final WorkPackageAlternativePage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$WorkPackageAlternativePageResponse(
          [void Function(WorkPackageAlternativePageResponseBuilder)?
              updates]) =>
      (WorkPackageAlternativePageResponseBuilder()..update(updates))._build();

  _$WorkPackageAlternativePageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  WorkPackageAlternativePageResponse rebuild(
          void Function(WorkPackageAlternativePageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageAlternativePageResponseBuilder toBuilder() =>
      WorkPackageAlternativePageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageAlternativePageResponse &&
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
    return (newBuiltValueToStringHelper(r'WorkPackageAlternativePageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class WorkPackageAlternativePageResponseBuilder
    implements
        Builder<WorkPackageAlternativePageResponse,
            WorkPackageAlternativePageResponseBuilder> {
  _$WorkPackageAlternativePageResponse? _$v;

  WorkPackageAlternativePageBuilder? _data;
  WorkPackageAlternativePageBuilder get data =>
      _$this._data ??= WorkPackageAlternativePageBuilder();
  set data(WorkPackageAlternativePageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  WorkPackageAlternativePageResponseBuilder() {
    WorkPackageAlternativePageResponse._defaults(this);
  }

  WorkPackageAlternativePageResponseBuilder get _$this {
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
  void replace(WorkPackageAlternativePageResponse other) {
    _$v = other as _$WorkPackageAlternativePageResponse;
  }

  @override
  void update(
      void Function(WorkPackageAlternativePageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageAlternativePageResponse build() => _build();

  _$WorkPackageAlternativePageResponse _build() {
    _$WorkPackageAlternativePageResponse _$result;
    try {
      _$result = _$v ??
          _$WorkPackageAlternativePageResponse._(
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
            r'WorkPackageAlternativePageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
