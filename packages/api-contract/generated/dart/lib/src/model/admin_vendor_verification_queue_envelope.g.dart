// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vendor_verification_queue_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVendorVerificationQueueEnvelope
    extends AdminVendorVerificationQueueEnvelope {
  @override
  final BuiltList<AdminVendorVerificationQueueItem> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AdminVendorVerificationQueueEnvelope(
          [void Function(AdminVendorVerificationQueueEnvelopeBuilder)?
              updates]) =>
      (AdminVendorVerificationQueueEnvelopeBuilder()..update(updates))._build();

  _$AdminVendorVerificationQueueEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminVendorVerificationQueueEnvelope rebuild(
          void Function(AdminVendorVerificationQueueEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVendorVerificationQueueEnvelopeBuilder toBuilder() =>
      AdminVendorVerificationQueueEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVendorVerificationQueueEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminVendorVerificationQueueEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminVendorVerificationQueueEnvelopeBuilder
    implements
        Builder<AdminVendorVerificationQueueEnvelope,
            AdminVendorVerificationQueueEnvelopeBuilder> {
  _$AdminVendorVerificationQueueEnvelope? _$v;

  ListBuilder<AdminVendorVerificationQueueItem>? _data;
  ListBuilder<AdminVendorVerificationQueueItem> get data =>
      _$this._data ??= ListBuilder<AdminVendorVerificationQueueItem>();
  set data(ListBuilder<AdminVendorVerificationQueueItem>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AdminVendorVerificationQueueEnvelopeBuilder() {
    AdminVendorVerificationQueueEnvelope._defaults(this);
  }

  AdminVendorVerificationQueueEnvelopeBuilder get _$this {
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
  void replace(AdminVendorVerificationQueueEnvelope other) {
    _$v = other as _$AdminVendorVerificationQueueEnvelope;
  }

  @override
  void update(
      void Function(AdminVendorVerificationQueueEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVendorVerificationQueueEnvelope build() => _build();

  _$AdminVendorVerificationQueueEnvelope _build() {
    _$AdminVendorVerificationQueueEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminVendorVerificationQueueEnvelope._(
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
            r'AdminVendorVerificationQueueEnvelope',
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
