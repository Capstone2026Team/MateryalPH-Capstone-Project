// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_submission_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutSubmissionEnvelope extends CheckoutSubmissionEnvelope {
  @override
  final CheckoutSubmission data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CheckoutSubmissionEnvelope(
          [void Function(CheckoutSubmissionEnvelopeBuilder)? updates]) =>
      (CheckoutSubmissionEnvelopeBuilder()..update(updates))._build();

  _$CheckoutSubmissionEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CheckoutSubmissionEnvelope rebuild(
          void Function(CheckoutSubmissionEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSubmissionEnvelopeBuilder toBuilder() =>
      CheckoutSubmissionEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSubmissionEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CheckoutSubmissionEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CheckoutSubmissionEnvelopeBuilder
    implements
        Builder<CheckoutSubmissionEnvelope, CheckoutSubmissionEnvelopeBuilder> {
  _$CheckoutSubmissionEnvelope? _$v;

  CheckoutSubmissionBuilder? _data;
  CheckoutSubmissionBuilder get data =>
      _$this._data ??= CheckoutSubmissionBuilder();
  set data(CheckoutSubmissionBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CheckoutSubmissionEnvelopeBuilder() {
    CheckoutSubmissionEnvelope._defaults(this);
  }

  CheckoutSubmissionEnvelopeBuilder get _$this {
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
  void replace(CheckoutSubmissionEnvelope other) {
    _$v = other as _$CheckoutSubmissionEnvelope;
  }

  @override
  void update(void Function(CheckoutSubmissionEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSubmissionEnvelope build() => _build();

  _$CheckoutSubmissionEnvelope _build() {
    _$CheckoutSubmissionEnvelope _$result;
    try {
      _$result = _$v ??
          _$CheckoutSubmissionEnvelope._(
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
            r'CheckoutSubmissionEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
