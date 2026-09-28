// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_search_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiscoverySearchEnvelope extends DiscoverySearchEnvelope {
  @override
  final BuiltList<SupplierResult> data;
  @override
  final DiscoverySearchMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$DiscoverySearchEnvelope(
          [void Function(DiscoverySearchEnvelopeBuilder)? updates]) =>
      (DiscoverySearchEnvelopeBuilder()..update(updates))._build();

  _$DiscoverySearchEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DiscoverySearchEnvelope rebuild(
          void Function(DiscoverySearchEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoverySearchEnvelopeBuilder toBuilder() =>
      DiscoverySearchEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoverySearchEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DiscoverySearchEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DiscoverySearchEnvelopeBuilder
    implements
        Builder<DiscoverySearchEnvelope, DiscoverySearchEnvelopeBuilder> {
  _$DiscoverySearchEnvelope? _$v;

  ListBuilder<SupplierResult>? _data;
  ListBuilder<SupplierResult> get data =>
      _$this._data ??= ListBuilder<SupplierResult>();
  set data(ListBuilder<SupplierResult>? data) => _$this._data = data;

  DiscoverySearchMetaBuilder? _meta;
  DiscoverySearchMetaBuilder get meta =>
      _$this._meta ??= DiscoverySearchMetaBuilder();
  set meta(DiscoverySearchMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  DiscoverySearchEnvelopeBuilder() {
    DiscoverySearchEnvelope._defaults(this);
  }

  DiscoverySearchEnvelopeBuilder get _$this {
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
  void replace(DiscoverySearchEnvelope other) {
    _$v = other as _$DiscoverySearchEnvelope;
  }

  @override
  void update(void Function(DiscoverySearchEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoverySearchEnvelope build() => _build();

  _$DiscoverySearchEnvelope _build() {
    _$DiscoverySearchEnvelope _$result;
    try {
      _$result = _$v ??
          _$DiscoverySearchEnvelope._(
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
            r'DiscoverySearchEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
