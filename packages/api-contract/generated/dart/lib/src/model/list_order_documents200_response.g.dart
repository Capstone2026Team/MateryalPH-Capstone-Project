// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_order_documents200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListOrderDocuments200Response extends ListOrderDocuments200Response {
  @override
  final BuiltList<PlatformDocumentRef> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ListOrderDocuments200Response(
          [void Function(ListOrderDocuments200ResponseBuilder)? updates]) =>
      (ListOrderDocuments200ResponseBuilder()..update(updates))._build();

  _$ListOrderDocuments200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ListOrderDocuments200Response rebuild(
          void Function(ListOrderDocuments200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListOrderDocuments200ResponseBuilder toBuilder() =>
      ListOrderDocuments200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListOrderDocuments200Response &&
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
    return (newBuiltValueToStringHelper(r'ListOrderDocuments200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ListOrderDocuments200ResponseBuilder
    implements
        Builder<ListOrderDocuments200Response,
            ListOrderDocuments200ResponseBuilder> {
  _$ListOrderDocuments200Response? _$v;

  ListBuilder<PlatformDocumentRef>? _data;
  ListBuilder<PlatformDocumentRef> get data =>
      _$this._data ??= ListBuilder<PlatformDocumentRef>();
  set data(ListBuilder<PlatformDocumentRef>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ListOrderDocuments200ResponseBuilder() {
    ListOrderDocuments200Response._defaults(this);
  }

  ListOrderDocuments200ResponseBuilder get _$this {
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
  void replace(ListOrderDocuments200Response other) {
    _$v = other as _$ListOrderDocuments200Response;
  }

  @override
  void update(void Function(ListOrderDocuments200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListOrderDocuments200Response build() => _build();

  _$ListOrderDocuments200Response _build() {
    _$ListOrderDocuments200Response _$result;
    try {
      _$result = _$v ??
          _$ListOrderDocuments200Response._(
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
            r'ListOrderDocuments200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
