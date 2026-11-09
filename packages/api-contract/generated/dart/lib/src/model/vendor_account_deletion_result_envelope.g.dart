// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_account_deletion_result_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorAccountDeletionResultEnvelope
    extends VendorAccountDeletionResultEnvelope {
  @override
  final VendorAccountDeletionResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorAccountDeletionResultEnvelope(
          [void Function(VendorAccountDeletionResultEnvelopeBuilder)?
              updates]) =>
      (VendorAccountDeletionResultEnvelopeBuilder()..update(updates))._build();

  _$VendorAccountDeletionResultEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorAccountDeletionResultEnvelope rebuild(
          void Function(VendorAccountDeletionResultEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAccountDeletionResultEnvelopeBuilder toBuilder() =>
      VendorAccountDeletionResultEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAccountDeletionResultEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorAccountDeletionResultEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorAccountDeletionResultEnvelopeBuilder
    implements
        Builder<VendorAccountDeletionResultEnvelope,
            VendorAccountDeletionResultEnvelopeBuilder> {
  _$VendorAccountDeletionResultEnvelope? _$v;

  VendorAccountDeletionResultBuilder? _data;
  VendorAccountDeletionResultBuilder get data =>
      _$this._data ??= VendorAccountDeletionResultBuilder();
  set data(VendorAccountDeletionResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorAccountDeletionResultEnvelopeBuilder() {
    VendorAccountDeletionResultEnvelope._defaults(this);
  }

  VendorAccountDeletionResultEnvelopeBuilder get _$this {
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
  void replace(VendorAccountDeletionResultEnvelope other) {
    _$v = other as _$VendorAccountDeletionResultEnvelope;
  }

  @override
  void update(
      void Function(VendorAccountDeletionResultEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAccountDeletionResultEnvelope build() => _build();

  _$VendorAccountDeletionResultEnvelope _build() {
    _$VendorAccountDeletionResultEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorAccountDeletionResultEnvelope._(
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
        throw BuiltValueNestedFieldError(r'VendorAccountDeletionResultEnvelope',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
