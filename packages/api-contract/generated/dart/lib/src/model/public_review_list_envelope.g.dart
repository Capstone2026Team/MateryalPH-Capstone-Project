// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_review_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicReviewListEnvelope extends PublicReviewListEnvelope {
  @override
  final BuiltList<PublicReview> data;
  @override
  final ReviewListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PublicReviewListEnvelope(
          [void Function(PublicReviewListEnvelopeBuilder)? updates]) =>
      (PublicReviewListEnvelopeBuilder()..update(updates))._build();

  _$PublicReviewListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PublicReviewListEnvelope rebuild(
          void Function(PublicReviewListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicReviewListEnvelopeBuilder toBuilder() =>
      PublicReviewListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicReviewListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PublicReviewListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PublicReviewListEnvelopeBuilder
    implements
        Builder<PublicReviewListEnvelope, PublicReviewListEnvelopeBuilder> {
  _$PublicReviewListEnvelope? _$v;

  ListBuilder<PublicReview>? _data;
  ListBuilder<PublicReview> get data =>
      _$this._data ??= ListBuilder<PublicReview>();
  set data(ListBuilder<PublicReview>? data) => _$this._data = data;

  ReviewListMetaBuilder? _meta;
  ReviewListMetaBuilder get meta => _$this._meta ??= ReviewListMetaBuilder();
  set meta(ReviewListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PublicReviewListEnvelopeBuilder() {
    PublicReviewListEnvelope._defaults(this);
  }

  PublicReviewListEnvelopeBuilder get _$this {
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
  void replace(PublicReviewListEnvelope other) {
    _$v = other as _$PublicReviewListEnvelope;
  }

  @override
  void update(void Function(PublicReviewListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicReviewListEnvelope build() => _build();

  _$PublicReviewListEnvelope _build() {
    _$PublicReviewListEnvelope _$result;
    try {
      _$result = _$v ??
          _$PublicReviewListEnvelope._(
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
            r'PublicReviewListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
