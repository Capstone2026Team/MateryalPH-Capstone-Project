// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingSearchEnvelope extends ListingSearchEnvelope {
  @override
  final BuiltList<ListingSearchResult> data;
  @override
  final ListingSearchMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ListingSearchEnvelope(
          [void Function(ListingSearchEnvelopeBuilder)? updates]) =>
      (ListingSearchEnvelopeBuilder()..update(updates))._build();

  _$ListingSearchEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ListingSearchEnvelope rebuild(
          void Function(ListingSearchEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchEnvelopeBuilder toBuilder() =>
      ListingSearchEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ListingSearchEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ListingSearchEnvelopeBuilder
    implements Builder<ListingSearchEnvelope, ListingSearchEnvelopeBuilder> {
  _$ListingSearchEnvelope? _$v;

  ListBuilder<ListingSearchResult>? _data;
  ListBuilder<ListingSearchResult> get data =>
      _$this._data ??= ListBuilder<ListingSearchResult>();
  set data(ListBuilder<ListingSearchResult>? data) => _$this._data = data;

  ListingSearchMetaBuilder? _meta;
  ListingSearchMetaBuilder get meta =>
      _$this._meta ??= ListingSearchMetaBuilder();
  set meta(ListingSearchMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ListingSearchEnvelopeBuilder() {
    ListingSearchEnvelope._defaults(this);
  }

  ListingSearchEnvelopeBuilder get _$this {
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
  void replace(ListingSearchEnvelope other) {
    _$v = other as _$ListingSearchEnvelope;
  }

  @override
  void update(void Function(ListingSearchEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchEnvelope build() => _build();

  _$ListingSearchEnvelope _build() {
    _$ListingSearchEnvelope _$result;
    try {
      _$result = _$v ??
          _$ListingSearchEnvelope._(
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
            r'ListingSearchEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
