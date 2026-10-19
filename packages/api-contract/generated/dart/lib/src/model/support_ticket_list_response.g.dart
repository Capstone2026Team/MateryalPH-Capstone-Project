// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportTicketListResponse extends SupportTicketListResponse {
  @override
  final BuiltList<SupportTicket> data;
  @override
  final SupportPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportTicketListResponse(
          [void Function(SupportTicketListResponseBuilder)? updates]) =>
      (SupportTicketListResponseBuilder()..update(updates))._build();

  _$SupportTicketListResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportTicketListResponse rebuild(
          void Function(SupportTicketListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportTicketListResponseBuilder toBuilder() =>
      SupportTicketListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportTicketListResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportTicketListResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportTicketListResponseBuilder
    implements
        Builder<SupportTicketListResponse, SupportTicketListResponseBuilder> {
  _$SupportTicketListResponse? _$v;

  ListBuilder<SupportTicket>? _data;
  ListBuilder<SupportTicket> get data =>
      _$this._data ??= ListBuilder<SupportTicket>();
  set data(ListBuilder<SupportTicket>? data) => _$this._data = data;

  SupportPageMetaBuilder? _meta;
  SupportPageMetaBuilder get meta => _$this._meta ??= SupportPageMetaBuilder();
  set meta(SupportPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportTicketListResponseBuilder() {
    SupportTicketListResponse._defaults(this);
  }

  SupportTicketListResponseBuilder get _$this {
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
  void replace(SupportTicketListResponse other) {
    _$v = other as _$SupportTicketListResponse;
  }

  @override
  void update(void Function(SupportTicketListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportTicketListResponse build() => _build();

  _$SupportTicketListResponse _build() {
    _$SupportTicketListResponse _$result;
    try {
      _$result = _$v ??
          _$SupportTicketListResponse._(
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
            r'SupportTicketListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
