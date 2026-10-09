// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_filter_applicability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoFilterApplicability extends GeoFilterApplicability {
  @override
  final String filter;
  @override
  final BuiltList<String> appliesTo;
  @override
  final BuiltList<String> notApplicableTo;
  @override
  final String note;

  factory _$GeoFilterApplicability(
          [void Function(GeoFilterApplicabilityBuilder)? updates]) =>
      (GeoFilterApplicabilityBuilder()..update(updates))._build();

  _$GeoFilterApplicability._(
      {required this.filter,
      required this.appliesTo,
      required this.notApplicableTo,
      required this.note})
      : super._();
  @override
  GeoFilterApplicability rebuild(
          void Function(GeoFilterApplicabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoFilterApplicabilityBuilder toBuilder() =>
      GeoFilterApplicabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoFilterApplicability &&
        filter == other.filter &&
        appliesTo == other.appliesTo &&
        notApplicableTo == other.notApplicableTo &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, appliesTo.hashCode);
    _$hash = $jc(_$hash, notApplicableTo.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoFilterApplicability')
          ..add('filter', filter)
          ..add('appliesTo', appliesTo)
          ..add('notApplicableTo', notApplicableTo)
          ..add('note', note))
        .toString();
  }
}

class GeoFilterApplicabilityBuilder
    implements Builder<GeoFilterApplicability, GeoFilterApplicabilityBuilder> {
  _$GeoFilterApplicability? _$v;

  String? _filter;
  String? get filter => _$this._filter;
  set filter(String? filter) => _$this._filter = filter;

  ListBuilder<String>? _appliesTo;
  ListBuilder<String> get appliesTo =>
      _$this._appliesTo ??= ListBuilder<String>();
  set appliesTo(ListBuilder<String>? appliesTo) =>
      _$this._appliesTo = appliesTo;

  ListBuilder<String>? _notApplicableTo;
  ListBuilder<String> get notApplicableTo =>
      _$this._notApplicableTo ??= ListBuilder<String>();
  set notApplicableTo(ListBuilder<String>? notApplicableTo) =>
      _$this._notApplicableTo = notApplicableTo;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  GeoFilterApplicabilityBuilder() {
    GeoFilterApplicability._defaults(this);
  }

  GeoFilterApplicabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filter = $v.filter;
      _appliesTo = $v.appliesTo.toBuilder();
      _notApplicableTo = $v.notApplicableTo.toBuilder();
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoFilterApplicability other) {
    _$v = other as _$GeoFilterApplicability;
  }

  @override
  void update(void Function(GeoFilterApplicabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoFilterApplicability build() => _build();

  _$GeoFilterApplicability _build() {
    _$GeoFilterApplicability _$result;
    try {
      _$result = _$v ??
          _$GeoFilterApplicability._(
            filter: BuiltValueNullFieldError.checkNotNull(
                filter, r'GeoFilterApplicability', 'filter'),
            appliesTo: appliesTo.build(),
            notApplicableTo: notApplicableTo.build(),
            note: BuiltValueNullFieldError.checkNotNull(
                note, r'GeoFilterApplicability', 'note'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'appliesTo';
        appliesTo.build();
        _$failedField = 'notApplicableTo';
        notApplicableTo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoFilterApplicability', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
