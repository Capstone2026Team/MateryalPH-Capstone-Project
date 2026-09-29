// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationSuggestion extends LocationSuggestion {
  @override
  final String placeId;
  @override
  final String title;
  @override
  final String? subtitle;

  factory _$LocationSuggestion(
          [void Function(LocationSuggestionBuilder)? updates]) =>
      (LocationSuggestionBuilder()..update(updates))._build();

  _$LocationSuggestion._(
      {required this.placeId, required this.title, this.subtitle})
      : super._();
  @override
  LocationSuggestion rebuild(
          void Function(LocationSuggestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationSuggestionBuilder toBuilder() =>
      LocationSuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationSuggestion &&
        placeId == other.placeId &&
        title == other.title &&
        subtitle == other.subtitle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, placeId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, subtitle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationSuggestion')
          ..add('placeId', placeId)
          ..add('title', title)
          ..add('subtitle', subtitle))
        .toString();
  }
}

class LocationSuggestionBuilder
    implements Builder<LocationSuggestion, LocationSuggestionBuilder> {
  _$LocationSuggestion? _$v;

  String? _placeId;
  String? get placeId => _$this._placeId;
  set placeId(String? placeId) => _$this._placeId = placeId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _subtitle;
  String? get subtitle => _$this._subtitle;
  set subtitle(String? subtitle) => _$this._subtitle = subtitle;

  LocationSuggestionBuilder() {
    LocationSuggestion._defaults(this);
  }

  LocationSuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _placeId = $v.placeId;
      _title = $v.title;
      _subtitle = $v.subtitle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationSuggestion other) {
    _$v = other as _$LocationSuggestion;
  }

  @override
  void update(void Function(LocationSuggestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationSuggestion build() => _build();

  _$LocationSuggestion _build() {
    final _$result = _$v ??
        _$LocationSuggestion._(
          placeId: BuiltValueNullFieldError.checkNotNull(
              placeId, r'LocationSuggestion', 'placeId'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'LocationSuggestion', 'title'),
          subtitle: subtitle,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
