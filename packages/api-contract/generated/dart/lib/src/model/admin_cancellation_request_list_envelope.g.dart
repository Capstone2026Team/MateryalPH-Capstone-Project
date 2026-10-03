// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancellation_request_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancellationRequestListEnvelope
    extends AdminCancellationRequestListEnvelope {
  @override
  final BuiltList<AdminCancellationRequestRow> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminCancellationRequestListEnvelope(
          [void Function(AdminCancellationRequestListEnvelopeBuilder)?
              updates]) =>
      (AdminCancellationRequestListEnvelopeBuilder()..update(updates))._build();

  _$AdminCancellationRequestListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminCancellationRequestListEnvelope rebuild(
          void Function(AdminCancellationRequestListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCancellationRequestListEnvelopeBuilder toBuilder() =>
      AdminCancellationRequestListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancellationRequestListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminCancellationRequestListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminCancellationRequestListEnvelopeBuilder
    implements
        Builder<AdminCancellationRequestListEnvelope,
            AdminCancellationRequestListEnvelopeBuilder> {
  _$AdminCancellationRequestListEnvelope? _$v;

  ListBuilder<AdminCancellationRequestRow>? _data;
  ListBuilder<AdminCancellationRequestRow> get data =>
      _$this._data ??= ListBuilder<AdminCancellationRequestRow>();
  set data(ListBuilder<AdminCancellationRequestRow>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminCancellationRequestListEnvelopeBuilder() {
    AdminCancellationRequestListEnvelope._defaults(this);
  }

  AdminCancellationRequestListEnvelopeBuilder get _$this {
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
  void replace(AdminCancellationRequestListEnvelope other) {
    _$v = other as _$AdminCancellationRequestListEnvelope;
  }

  @override
  void update(
      void Function(AdminCancellationRequestListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancellationRequestListEnvelope build() => _build();

  _$AdminCancellationRequestListEnvelope _build() {
    _$AdminCancellationRequestListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminCancellationRequestListEnvelope._(
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
            r'AdminCancellationRequestListEnvelope',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
