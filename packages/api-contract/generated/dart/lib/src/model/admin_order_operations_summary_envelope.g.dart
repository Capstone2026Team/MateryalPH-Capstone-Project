// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_operations_summary_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderOperationsSummaryEnvelope
    extends AdminOrderOperationsSummaryEnvelope {
  @override
  final AdminOrderOperationsSummary data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminOrderOperationsSummaryEnvelope(
          [void Function(AdminOrderOperationsSummaryEnvelopeBuilder)?
              updates]) =>
      (AdminOrderOperationsSummaryEnvelopeBuilder()..update(updates))._build();

  _$AdminOrderOperationsSummaryEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminOrderOperationsSummaryEnvelope rebuild(
          void Function(AdminOrderOperationsSummaryEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOrderOperationsSummaryEnvelopeBuilder toBuilder() =>
      AdminOrderOperationsSummaryEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderOperationsSummaryEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderOperationsSummaryEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminOrderOperationsSummaryEnvelopeBuilder
    implements
        Builder<AdminOrderOperationsSummaryEnvelope,
            AdminOrderOperationsSummaryEnvelopeBuilder> {
  _$AdminOrderOperationsSummaryEnvelope? _$v;

  AdminOrderOperationsSummaryBuilder? _data;
  AdminOrderOperationsSummaryBuilder get data =>
      _$this._data ??= AdminOrderOperationsSummaryBuilder();
  set data(AdminOrderOperationsSummaryBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminOrderOperationsSummaryEnvelopeBuilder() {
    AdminOrderOperationsSummaryEnvelope._defaults(this);
  }

  AdminOrderOperationsSummaryEnvelopeBuilder get _$this {
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
  void replace(AdminOrderOperationsSummaryEnvelope other) {
    _$v = other as _$AdminOrderOperationsSummaryEnvelope;
  }

  @override
  void update(
      void Function(AdminOrderOperationsSummaryEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderOperationsSummaryEnvelope build() => _build();

  _$AdminOrderOperationsSummaryEnvelope _build() {
    _$AdminOrderOperationsSummaryEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminOrderOperationsSummaryEnvelope._(
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
        throw BuiltValueNestedFieldError(r'AdminOrderOperationsSummaryEnvelope',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
