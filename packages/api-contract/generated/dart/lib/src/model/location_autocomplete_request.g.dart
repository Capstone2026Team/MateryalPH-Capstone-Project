// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_autocomplete_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationAutocompleteRequest extends LocationAutocompleteRequest {
  @override
  final String query;
  @override
  final String sessionToken;

  factory _$LocationAutocompleteRequest(
          [void Function(LocationAutocompleteRequestBuilder)? updates]) =>
      (LocationAutocompleteRequestBuilder()..update(updates))._build();

  _$LocationAutocompleteRequest._(
      {required this.query, required this.sessionToken})
      : super._();
  @override
  LocationAutocompleteRequest rebuild(
          void Function(LocationAutocompleteRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationAutocompleteRequestBuilder toBuilder() =>
      LocationAutocompleteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationAutocompleteRequest &&
        query == other.query &&
        sessionToken == other.sessionToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, sessionToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationAutocompleteRequest')
          ..add('query', query)
          ..add('sessionToken', sessionToken))
        .toString();
  }
}

class LocationAutocompleteRequestBuilder
    implements
        Builder<LocationAutocompleteRequest,
            LocationAutocompleteRequestBuilder> {
  _$LocationAutocompleteRequest? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  String? _sessionToken;
  String? get sessionToken => _$this._sessionToken;
  set sessionToken(String? sessionToken) => _$this._sessionToken = sessionToken;

  LocationAutocompleteRequestBuilder() {
    LocationAutocompleteRequest._defaults(this);
  }

  LocationAutocompleteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _sessionToken = $v.sessionToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationAutocompleteRequest other) {
    _$v = other as _$LocationAutocompleteRequest;
  }

  @override
  void update(void Function(LocationAutocompleteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationAutocompleteRequest build() => _build();

  _$LocationAutocompleteRequest _build() {
    final _$result = _$v ??
        _$LocationAutocompleteRequest._(
          query: BuiltValueNullFieldError.checkNotNull(
              query, r'LocationAutocompleteRequest', 'query'),
          sessionToken: BuiltValueNullFieldError.checkNotNull(
              sessionToken, r'LocationAutocompleteRequest', 'sessionToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
