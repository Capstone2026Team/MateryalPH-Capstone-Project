// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_score_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminScoreListEnvelope extends AdminScoreListEnvelope {
  @override
  final BuiltList<AdminScoreRow> data;
  @override
  final ReviewListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminScoreListEnvelope(
          [void Function(AdminScoreListEnvelopeBuilder)? updates]) =>
      (AdminScoreListEnvelopeBuilder()..update(updates))._build();

  _$AdminScoreListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminScoreListEnvelope rebuild(
          void Function(AdminScoreListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminScoreListEnvelopeBuilder toBuilder() =>
      AdminScoreListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminScoreListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminScoreListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminScoreListEnvelopeBuilder
    implements Builder<AdminScoreListEnvelope, AdminScoreListEnvelopeBuilder> {
  _$AdminScoreListEnvelope? _$v;

  ListBuilder<AdminScoreRow>? _data;
  ListBuilder<AdminScoreRow> get data =>
      _$this._data ??= ListBuilder<AdminScoreRow>();
  set data(ListBuilder<AdminScoreRow>? data) => _$this._data = data;

  ReviewListMetaBuilder? _meta;
  ReviewListMetaBuilder get meta => _$this._meta ??= ReviewListMetaBuilder();
  set meta(ReviewListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminScoreListEnvelopeBuilder() {
    AdminScoreListEnvelope._defaults(this);
  }

  AdminScoreListEnvelopeBuilder get _$this {
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
  void replace(AdminScoreListEnvelope other) {
    _$v = other as _$AdminScoreListEnvelope;
  }

  @override
  void update(void Function(AdminScoreListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminScoreListEnvelope build() => _build();

  _$AdminScoreListEnvelope _build() {
    _$AdminScoreListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminScoreListEnvelope._(
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
            r'AdminScoreListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
