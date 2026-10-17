// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_document_export202_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RequestDocumentExport202Response
    extends RequestDocumentExport202Response {
  @override
  final DocumentExport data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RequestDocumentExport202Response(
          [void Function(RequestDocumentExport202ResponseBuilder)? updates]) =>
      (RequestDocumentExport202ResponseBuilder()..update(updates))._build();

  _$RequestDocumentExport202Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RequestDocumentExport202Response rebuild(
          void Function(RequestDocumentExport202ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestDocumentExport202ResponseBuilder toBuilder() =>
      RequestDocumentExport202ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestDocumentExport202Response &&
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
    return (newBuiltValueToStringHelper(r'RequestDocumentExport202Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RequestDocumentExport202ResponseBuilder
    implements
        Builder<RequestDocumentExport202Response,
            RequestDocumentExport202ResponseBuilder> {
  _$RequestDocumentExport202Response? _$v;

  DocumentExportBuilder? _data;
  DocumentExportBuilder get data => _$this._data ??= DocumentExportBuilder();
  set data(DocumentExportBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RequestDocumentExport202ResponseBuilder() {
    RequestDocumentExport202Response._defaults(this);
  }

  RequestDocumentExport202ResponseBuilder get _$this {
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
  void replace(RequestDocumentExport202Response other) {
    _$v = other as _$RequestDocumentExport202Response;
  }

  @override
  void update(void Function(RequestDocumentExport202ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestDocumentExport202Response build() => _build();

  _$RequestDocumentExport202Response _build() {
    _$RequestDocumentExport202Response _$result;
    try {
      _$result = _$v ??
          _$RequestDocumentExport202Response._(
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
            r'RequestDocumentExport202Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
