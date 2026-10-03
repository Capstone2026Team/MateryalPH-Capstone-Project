// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_fee_version_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelFeeVersionListEnvelope extends ChannelFeeVersionListEnvelope {
  @override
  final BuiltList<ChannelFeeVersion> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ChannelFeeVersionListEnvelope(
          [void Function(ChannelFeeVersionListEnvelopeBuilder)? updates]) =>
      (ChannelFeeVersionListEnvelopeBuilder()..update(updates))._build();

  _$ChannelFeeVersionListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ChannelFeeVersionListEnvelope rebuild(
          void Function(ChannelFeeVersionListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelFeeVersionListEnvelopeBuilder toBuilder() =>
      ChannelFeeVersionListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelFeeVersionListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ChannelFeeVersionListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ChannelFeeVersionListEnvelopeBuilder
    implements
        Builder<ChannelFeeVersionListEnvelope,
            ChannelFeeVersionListEnvelopeBuilder> {
  _$ChannelFeeVersionListEnvelope? _$v;

  ListBuilder<ChannelFeeVersion>? _data;
  ListBuilder<ChannelFeeVersion> get data =>
      _$this._data ??= ListBuilder<ChannelFeeVersion>();
  set data(ListBuilder<ChannelFeeVersion>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ChannelFeeVersionListEnvelopeBuilder() {
    ChannelFeeVersionListEnvelope._defaults(this);
  }

  ChannelFeeVersionListEnvelopeBuilder get _$this {
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
  void replace(ChannelFeeVersionListEnvelope other) {
    _$v = other as _$ChannelFeeVersionListEnvelope;
  }

  @override
  void update(void Function(ChannelFeeVersionListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelFeeVersionListEnvelope build() => _build();

  _$ChannelFeeVersionListEnvelope _build() {
    _$ChannelFeeVersionListEnvelope _$result;
    try {
      _$result = _$v ??
          _$ChannelFeeVersionListEnvelope._(
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
            r'ChannelFeeVersionListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
