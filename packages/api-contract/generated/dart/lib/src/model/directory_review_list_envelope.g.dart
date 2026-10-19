// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_review_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryReviewListEnvelope extends DirectoryReviewListEnvelope {
  @override
  final BuiltList<DirectoryReview> data;
  @override
  final DirectoryPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DirectoryReviewListEnvelope(
          [void Function(DirectoryReviewListEnvelopeBuilder)? updates]) =>
      (DirectoryReviewListEnvelopeBuilder()..update(updates))._build();

  _$DirectoryReviewListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DirectoryReviewListEnvelope rebuild(
          void Function(DirectoryReviewListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryReviewListEnvelopeBuilder toBuilder() =>
      DirectoryReviewListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryReviewListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DirectoryReviewListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DirectoryReviewListEnvelopeBuilder
    implements
        Builder<DirectoryReviewListEnvelope,
            DirectoryReviewListEnvelopeBuilder> {
  _$DirectoryReviewListEnvelope? _$v;

  ListBuilder<DirectoryReview>? _data;
  ListBuilder<DirectoryReview> get data =>
      _$this._data ??= ListBuilder<DirectoryReview>();
  set data(ListBuilder<DirectoryReview>? data) => _$this._data = data;

  DirectoryPageMetaBuilder? _meta;
  DirectoryPageMetaBuilder get meta =>
      _$this._meta ??= DirectoryPageMetaBuilder();
  set meta(DirectoryPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DirectoryReviewListEnvelopeBuilder() {
    DirectoryReviewListEnvelope._defaults(this);
  }

  DirectoryReviewListEnvelopeBuilder get _$this {
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
  void replace(DirectoryReviewListEnvelope other) {
    _$v = other as _$DirectoryReviewListEnvelope;
  }

  @override
  void update(void Function(DirectoryReviewListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryReviewListEnvelope build() => _build();

  _$DirectoryReviewListEnvelope _build() {
    _$DirectoryReviewListEnvelope _$result;
    try {
      _$result = _$v ??
          _$DirectoryReviewListEnvelope._(
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
            r'DirectoryReviewListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
