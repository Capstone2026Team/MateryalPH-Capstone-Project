// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerEnvelope extends DirectoryBuyerEnvelope {
  @override
  final DirectoryBuyerProfile data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DirectoryBuyerEnvelope(
          [void Function(DirectoryBuyerEnvelopeBuilder)? updates]) =>
      (DirectoryBuyerEnvelopeBuilder()..update(updates))._build();

  _$DirectoryBuyerEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DirectoryBuyerEnvelope rebuild(
          void Function(DirectoryBuyerEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerEnvelopeBuilder toBuilder() =>
      DirectoryBuyerEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DirectoryBuyerEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DirectoryBuyerEnvelopeBuilder
    implements Builder<DirectoryBuyerEnvelope, DirectoryBuyerEnvelopeBuilder> {
  _$DirectoryBuyerEnvelope? _$v;

  DirectoryBuyerProfileBuilder? _data;
  DirectoryBuyerProfileBuilder get data =>
      _$this._data ??= DirectoryBuyerProfileBuilder();
  set data(DirectoryBuyerProfileBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DirectoryBuyerEnvelopeBuilder() {
    DirectoryBuyerEnvelope._defaults(this);
  }

  DirectoryBuyerEnvelopeBuilder get _$this {
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
  void replace(DirectoryBuyerEnvelope other) {
    _$v = other as _$DirectoryBuyerEnvelope;
  }

  @override
  void update(void Function(DirectoryBuyerEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerEnvelope build() => _build();

  _$DirectoryBuyerEnvelope _build() {
    _$DirectoryBuyerEnvelope _$result;
    try {
      _$result = _$v ??
          _$DirectoryBuyerEnvelope._(
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
            r'DirectoryBuyerEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
