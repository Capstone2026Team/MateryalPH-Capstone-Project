// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_reported_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewReportedEnvelope extends ReviewReportedEnvelope {
  @override
  final ReviewReported data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ReviewReportedEnvelope(
          [void Function(ReviewReportedEnvelopeBuilder)? updates]) =>
      (ReviewReportedEnvelopeBuilder()..update(updates))._build();

  _$ReviewReportedEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ReviewReportedEnvelope rebuild(
          void Function(ReviewReportedEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewReportedEnvelopeBuilder toBuilder() =>
      ReviewReportedEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewReportedEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ReviewReportedEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ReviewReportedEnvelopeBuilder
    implements Builder<ReviewReportedEnvelope, ReviewReportedEnvelopeBuilder> {
  _$ReviewReportedEnvelope? _$v;

  ReviewReportedBuilder? _data;
  ReviewReportedBuilder get data => _$this._data ??= ReviewReportedBuilder();
  set data(ReviewReportedBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ReviewReportedEnvelopeBuilder() {
    ReviewReportedEnvelope._defaults(this);
  }

  ReviewReportedEnvelopeBuilder get _$this {
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
  void replace(ReviewReportedEnvelope other) {
    _$v = other as _$ReviewReportedEnvelope;
  }

  @override
  void update(void Function(ReviewReportedEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewReportedEnvelope build() => _build();

  _$ReviewReportedEnvelope _build() {
    _$ReviewReportedEnvelope _$result;
    try {
      _$result = _$v ??
          _$ReviewReportedEnvelope._(
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
            r'ReviewReportedEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
