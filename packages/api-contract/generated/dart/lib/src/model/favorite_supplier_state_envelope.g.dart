// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_supplier_state_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FavoriteSupplierStateEnvelope extends FavoriteSupplierStateEnvelope {
  @override
  final FavoriteSupplierState data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$FavoriteSupplierStateEnvelope(
          [void Function(FavoriteSupplierStateEnvelopeBuilder)? updates]) =>
      (FavoriteSupplierStateEnvelopeBuilder()..update(updates))._build();

  _$FavoriteSupplierStateEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FavoriteSupplierStateEnvelope rebuild(
          void Function(FavoriteSupplierStateEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteSupplierStateEnvelopeBuilder toBuilder() =>
      FavoriteSupplierStateEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteSupplierStateEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FavoriteSupplierStateEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FavoriteSupplierStateEnvelopeBuilder
    implements
        Builder<FavoriteSupplierStateEnvelope,
            FavoriteSupplierStateEnvelopeBuilder> {
  _$FavoriteSupplierStateEnvelope? _$v;

  FavoriteSupplierStateBuilder? _data;
  FavoriteSupplierStateBuilder get data =>
      _$this._data ??= FavoriteSupplierStateBuilder();
  set data(FavoriteSupplierStateBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  FavoriteSupplierStateEnvelopeBuilder() {
    FavoriteSupplierStateEnvelope._defaults(this);
  }

  FavoriteSupplierStateEnvelopeBuilder get _$this {
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
  void replace(FavoriteSupplierStateEnvelope other) {
    _$v = other as _$FavoriteSupplierStateEnvelope;
  }

  @override
  void update(void Function(FavoriteSupplierStateEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FavoriteSupplierStateEnvelope build() => _build();

  _$FavoriteSupplierStateEnvelope _build() {
    _$FavoriteSupplierStateEnvelope _$result;
    try {
      _$result = _$v ??
          _$FavoriteSupplierStateEnvelope._(
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
            r'FavoriteSupplierStateEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
