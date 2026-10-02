// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPaymentListEnvelope extends AdminPaymentListEnvelope {
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminPaymentListEnvelope(
          [void Function(AdminPaymentListEnvelopeBuilder)? updates]) =>
      (AdminPaymentListEnvelopeBuilder()..update(updates))._build();

  _$AdminPaymentListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminPaymentListEnvelope rebuild(
          void Function(AdminPaymentListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentListEnvelopeBuilder toBuilder() =>
      AdminPaymentListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminPaymentListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminPaymentListEnvelopeBuilder
    implements
        Builder<AdminPaymentListEnvelope, AdminPaymentListEnvelopeBuilder> {
  _$AdminPaymentListEnvelope? _$v;

  ListBuilder<BuiltMap<String, JsonObject?>>? _data;
  ListBuilder<BuiltMap<String, JsonObject?>> get data =>
      _$this._data ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set data(ListBuilder<BuiltMap<String, JsonObject?>>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminPaymentListEnvelopeBuilder() {
    AdminPaymentListEnvelope._defaults(this);
  }

  AdminPaymentListEnvelopeBuilder get _$this {
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
  void replace(AdminPaymentListEnvelope other) {
    _$v = other as _$AdminPaymentListEnvelope;
  }

  @override
  void update(void Function(AdminPaymentListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentListEnvelope build() => _build();

  _$AdminPaymentListEnvelope _build() {
    _$AdminPaymentListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminPaymentListEnvelope._(
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
            r'AdminPaymentListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
