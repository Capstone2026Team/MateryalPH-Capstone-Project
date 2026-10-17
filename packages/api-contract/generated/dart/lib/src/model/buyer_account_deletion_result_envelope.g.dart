// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_result_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountDeletionResultEnvelope
    extends BuyerAccountDeletionResultEnvelope {
  @override
  final BuyerAccountDeletionResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerAccountDeletionResultEnvelope(
          [void Function(BuyerAccountDeletionResultEnvelopeBuilder)?
              updates]) =>
      (BuyerAccountDeletionResultEnvelopeBuilder()..update(updates))._build();

  _$BuyerAccountDeletionResultEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerAccountDeletionResultEnvelope rebuild(
          void Function(BuyerAccountDeletionResultEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionResultEnvelopeBuilder toBuilder() =>
      BuyerAccountDeletionResultEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionResultEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionResultEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerAccountDeletionResultEnvelopeBuilder
    implements
        Builder<BuyerAccountDeletionResultEnvelope,
            BuyerAccountDeletionResultEnvelopeBuilder> {
  _$BuyerAccountDeletionResultEnvelope? _$v;

  BuyerAccountDeletionResultBuilder? _data;
  BuyerAccountDeletionResultBuilder get data =>
      _$this._data ??= BuyerAccountDeletionResultBuilder();
  set data(BuyerAccountDeletionResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerAccountDeletionResultEnvelopeBuilder() {
    BuyerAccountDeletionResultEnvelope._defaults(this);
  }

  BuyerAccountDeletionResultEnvelopeBuilder get _$this {
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
  void replace(BuyerAccountDeletionResultEnvelope other) {
    _$v = other as _$BuyerAccountDeletionResultEnvelope;
  }

  @override
  void update(
      void Function(BuyerAccountDeletionResultEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionResultEnvelope build() => _build();

  _$BuyerAccountDeletionResultEnvelope _build() {
    _$BuyerAccountDeletionResultEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerAccountDeletionResultEnvelope._(
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
            r'BuyerAccountDeletionResultEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
