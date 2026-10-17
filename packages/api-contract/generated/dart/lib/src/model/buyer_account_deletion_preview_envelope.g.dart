// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_preview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountDeletionPreviewEnvelope
    extends BuyerAccountDeletionPreviewEnvelope {
  @override
  final BuyerAccountDeletionPreview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerAccountDeletionPreviewEnvelope(
          [void Function(BuyerAccountDeletionPreviewEnvelopeBuilder)?
              updates]) =>
      (BuyerAccountDeletionPreviewEnvelopeBuilder()..update(updates))._build();

  _$BuyerAccountDeletionPreviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerAccountDeletionPreviewEnvelope rebuild(
          void Function(BuyerAccountDeletionPreviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionPreviewEnvelopeBuilder toBuilder() =>
      BuyerAccountDeletionPreviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionPreviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionPreviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerAccountDeletionPreviewEnvelopeBuilder
    implements
        Builder<BuyerAccountDeletionPreviewEnvelope,
            BuyerAccountDeletionPreviewEnvelopeBuilder> {
  _$BuyerAccountDeletionPreviewEnvelope? _$v;

  BuyerAccountDeletionPreviewBuilder? _data;
  BuyerAccountDeletionPreviewBuilder get data =>
      _$this._data ??= BuyerAccountDeletionPreviewBuilder();
  set data(BuyerAccountDeletionPreviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerAccountDeletionPreviewEnvelopeBuilder() {
    BuyerAccountDeletionPreviewEnvelope._defaults(this);
  }

  BuyerAccountDeletionPreviewEnvelopeBuilder get _$this {
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
  void replace(BuyerAccountDeletionPreviewEnvelope other) {
    _$v = other as _$BuyerAccountDeletionPreviewEnvelope;
  }

  @override
  void update(
      void Function(BuyerAccountDeletionPreviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionPreviewEnvelope build() => _build();

  _$BuyerAccountDeletionPreviewEnvelope _build() {
    _$BuyerAccountDeletionPreviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerAccountDeletionPreviewEnvelope._(
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
        throw BuiltValueNestedFieldError(r'BuyerAccountDeletionPreviewEnvelope',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
