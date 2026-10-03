// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_assignee_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentAssigneeListEnvelope
    extends FulfillmentAssigneeListEnvelope {
  @override
  final BuiltList<FulfillmentAssignee> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$FulfillmentAssigneeListEnvelope(
          [void Function(FulfillmentAssigneeListEnvelopeBuilder)? updates]) =>
      (FulfillmentAssigneeListEnvelopeBuilder()..update(updates))._build();

  _$FulfillmentAssigneeListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FulfillmentAssigneeListEnvelope rebuild(
          void Function(FulfillmentAssigneeListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentAssigneeListEnvelopeBuilder toBuilder() =>
      FulfillmentAssigneeListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentAssigneeListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FulfillmentAssigneeListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FulfillmentAssigneeListEnvelopeBuilder
    implements
        Builder<FulfillmentAssigneeListEnvelope,
            FulfillmentAssigneeListEnvelopeBuilder> {
  _$FulfillmentAssigneeListEnvelope? _$v;

  ListBuilder<FulfillmentAssignee>? _data;
  ListBuilder<FulfillmentAssignee> get data =>
      _$this._data ??= ListBuilder<FulfillmentAssignee>();
  set data(ListBuilder<FulfillmentAssignee>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  FulfillmentAssigneeListEnvelopeBuilder() {
    FulfillmentAssigneeListEnvelope._defaults(this);
  }

  FulfillmentAssigneeListEnvelopeBuilder get _$this {
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
  void replace(FulfillmentAssigneeListEnvelope other) {
    _$v = other as _$FulfillmentAssigneeListEnvelope;
  }

  @override
  void update(void Function(FulfillmentAssigneeListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentAssigneeListEnvelope build() => _build();

  _$FulfillmentAssigneeListEnvelope _build() {
    _$FulfillmentAssigneeListEnvelope _$result;
    try {
      _$result = _$v ??
          _$FulfillmentAssigneeListEnvelope._(
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
            r'FulfillmentAssigneeListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
