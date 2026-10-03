// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_refund_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRefundListEnvelope extends AdminRefundListEnvelope {
  @override
  final BuiltList<AdminRefundRow> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminRefundListEnvelope(
          [void Function(AdminRefundListEnvelopeBuilder)? updates]) =>
      (AdminRefundListEnvelopeBuilder()..update(updates))._build();

  _$AdminRefundListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminRefundListEnvelope rebuild(
          void Function(AdminRefundListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRefundListEnvelopeBuilder toBuilder() =>
      AdminRefundListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRefundListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminRefundListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminRefundListEnvelopeBuilder
    implements
        Builder<AdminRefundListEnvelope, AdminRefundListEnvelopeBuilder> {
  _$AdminRefundListEnvelope? _$v;

  ListBuilder<AdminRefundRow>? _data;
  ListBuilder<AdminRefundRow> get data =>
      _$this._data ??= ListBuilder<AdminRefundRow>();
  set data(ListBuilder<AdminRefundRow>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminRefundListEnvelopeBuilder() {
    AdminRefundListEnvelope._defaults(this);
  }

  AdminRefundListEnvelopeBuilder get _$this {
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
  void replace(AdminRefundListEnvelope other) {
    _$v = other as _$AdminRefundListEnvelope;
  }

  @override
  void update(void Function(AdminRefundListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRefundListEnvelope build() => _build();

  _$AdminRefundListEnvelope _build() {
    _$AdminRefundListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminRefundListEnvelope._(
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
            r'AdminRefundListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
