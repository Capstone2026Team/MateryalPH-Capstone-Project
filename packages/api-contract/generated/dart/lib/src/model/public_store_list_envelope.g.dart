// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicStoreListEnvelope extends PublicStoreListEnvelope {
  @override
  final BuiltList<PublicStoreSummary> data;
  @override
  final PublicStoreListEnvelopeMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$PublicStoreListEnvelope(
          [void Function(PublicStoreListEnvelopeBuilder)? updates]) =>
      (PublicStoreListEnvelopeBuilder()..update(updates))._build();

  _$PublicStoreListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PublicStoreListEnvelope rebuild(
          void Function(PublicStoreListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicStoreListEnvelopeBuilder toBuilder() =>
      PublicStoreListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicStoreListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PublicStoreListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PublicStoreListEnvelopeBuilder
    implements
        Builder<PublicStoreListEnvelope, PublicStoreListEnvelopeBuilder> {
  _$PublicStoreListEnvelope? _$v;

  ListBuilder<PublicStoreSummary>? _data;
  ListBuilder<PublicStoreSummary> get data =>
      _$this._data ??= ListBuilder<PublicStoreSummary>();
  set data(ListBuilder<PublicStoreSummary>? data) => _$this._data = data;

  PublicStoreListEnvelopeMetaBuilder? _meta;
  PublicStoreListEnvelopeMetaBuilder get meta =>
      _$this._meta ??= PublicStoreListEnvelopeMetaBuilder();
  set meta(PublicStoreListEnvelopeMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  PublicStoreListEnvelopeBuilder() {
    PublicStoreListEnvelope._defaults(this);
  }

  PublicStoreListEnvelopeBuilder get _$this {
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
  void replace(PublicStoreListEnvelope other) {
    _$v = other as _$PublicStoreListEnvelope;
  }

  @override
  void update(void Function(PublicStoreListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicStoreListEnvelope build() => _build();

  _$PublicStoreListEnvelope _build() {
    _$PublicStoreListEnvelope _$result;
    try {
      _$result = _$v ??
          _$PublicStoreListEnvelope._(
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
            r'PublicStoreListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
