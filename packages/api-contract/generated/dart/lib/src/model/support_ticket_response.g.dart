// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportTicketResponse extends SupportTicketResponse {
  @override
  final SupportTicket data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportTicketResponse(
          [void Function(SupportTicketResponseBuilder)? updates]) =>
      (SupportTicketResponseBuilder()..update(updates))._build();

  _$SupportTicketResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportTicketResponse rebuild(
          void Function(SupportTicketResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportTicketResponseBuilder toBuilder() =>
      SupportTicketResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportTicketResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportTicketResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportTicketResponseBuilder
    implements Builder<SupportTicketResponse, SupportTicketResponseBuilder> {
  _$SupportTicketResponse? _$v;

  SupportTicketBuilder? _data;
  SupportTicketBuilder get data => _$this._data ??= SupportTicketBuilder();
  set data(SupportTicketBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportTicketResponseBuilder() {
    SupportTicketResponse._defaults(this);
  }

  SupportTicketResponseBuilder get _$this {
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
  void replace(SupportTicketResponse other) {
    _$v = other as _$SupportTicketResponse;
  }

  @override
  void update(void Function(SupportTicketResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportTicketResponse build() => _build();

  _$SupportTicketResponse _build() {
    _$SupportTicketResponse _$result;
    try {
      _$result = _$v ??
          _$SupportTicketResponse._(
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
            r'SupportTicketResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
