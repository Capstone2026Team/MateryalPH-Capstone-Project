// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_action_result_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderActionResultEnvelope extends AdminOrderActionResultEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminOrderActionResultEnvelope(
          [void Function(AdminOrderActionResultEnvelopeBuilder)? updates]) =>
      (AdminOrderActionResultEnvelopeBuilder()..update(updates))._build();

  _$AdminOrderActionResultEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminOrderActionResultEnvelope rebuild(
          void Function(AdminOrderActionResultEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOrderActionResultEnvelopeBuilder toBuilder() =>
      AdminOrderActionResultEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderActionResultEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderActionResultEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminOrderActionResultEnvelopeBuilder
    implements
        Builder<AdminOrderActionResultEnvelope,
            AdminOrderActionResultEnvelopeBuilder> {
  _$AdminOrderActionResultEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminOrderActionResultEnvelopeBuilder() {
    AdminOrderActionResultEnvelope._defaults(this);
  }

  AdminOrderActionResultEnvelopeBuilder get _$this {
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
  void replace(AdminOrderActionResultEnvelope other) {
    _$v = other as _$AdminOrderActionResultEnvelope;
  }

  @override
  void update(void Function(AdminOrderActionResultEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderActionResultEnvelope build() => _build();

  _$AdminOrderActionResultEnvelope _build() {
    _$AdminOrderActionResultEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminOrderActionResultEnvelope._(
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
            r'AdminOrderActionResultEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
