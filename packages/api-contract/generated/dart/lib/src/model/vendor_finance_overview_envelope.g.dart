// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_overview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceOverviewEnvelope extends VendorFinanceOverviewEnvelope {
  @override
  final VendorFinanceOverview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorFinanceOverviewEnvelope(
          [void Function(VendorFinanceOverviewEnvelopeBuilder)? updates]) =>
      (VendorFinanceOverviewEnvelopeBuilder()..update(updates))._build();

  _$VendorFinanceOverviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorFinanceOverviewEnvelope rebuild(
          void Function(VendorFinanceOverviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceOverviewEnvelopeBuilder toBuilder() =>
      VendorFinanceOverviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceOverviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorFinanceOverviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorFinanceOverviewEnvelopeBuilder
    implements
        Builder<VendorFinanceOverviewEnvelope,
            VendorFinanceOverviewEnvelopeBuilder> {
  _$VendorFinanceOverviewEnvelope? _$v;

  VendorFinanceOverviewBuilder? _data;
  VendorFinanceOverviewBuilder get data =>
      _$this._data ??= VendorFinanceOverviewBuilder();
  set data(VendorFinanceOverviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorFinanceOverviewEnvelopeBuilder() {
    VendorFinanceOverviewEnvelope._defaults(this);
  }

  VendorFinanceOverviewEnvelopeBuilder get _$this {
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
  void replace(VendorFinanceOverviewEnvelope other) {
    _$v = other as _$VendorFinanceOverviewEnvelope;
  }

  @override
  void update(void Function(VendorFinanceOverviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceOverviewEnvelope build() => _build();

  _$VendorFinanceOverviewEnvelope _build() {
    _$VendorFinanceOverviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorFinanceOverviewEnvelope._(
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
            r'VendorFinanceOverviewEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
