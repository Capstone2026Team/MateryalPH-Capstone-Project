// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_details_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingDetailsEnvelope extends ListingDetailsEnvelope {
  @override
  final ListingDetails data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ListingDetailsEnvelope(
          [void Function(ListingDetailsEnvelopeBuilder)? updates]) =>
      (ListingDetailsEnvelopeBuilder()..update(updates))._build();

  _$ListingDetailsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ListingDetailsEnvelope rebuild(
          void Function(ListingDetailsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingDetailsEnvelopeBuilder toBuilder() =>
      ListingDetailsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingDetailsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ListingDetailsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ListingDetailsEnvelopeBuilder
    implements Builder<ListingDetailsEnvelope, ListingDetailsEnvelopeBuilder> {
  _$ListingDetailsEnvelope? _$v;

  ListingDetailsBuilder? _data;
  ListingDetailsBuilder get data => _$this._data ??= ListingDetailsBuilder();
  set data(ListingDetailsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ListingDetailsEnvelopeBuilder() {
    ListingDetailsEnvelope._defaults(this);
  }

  ListingDetailsEnvelopeBuilder get _$this {
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
  void replace(ListingDetailsEnvelope other) {
    _$v = other as _$ListingDetailsEnvelope;
  }

  @override
  void update(void Function(ListingDetailsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingDetailsEnvelope build() => _build();

  _$ListingDetailsEnvelope _build() {
    _$ListingDetailsEnvelope _$result;
    try {
      _$result = _$v ??
          _$ListingDetailsEnvelope._(
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
            r'ListingDetailsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
