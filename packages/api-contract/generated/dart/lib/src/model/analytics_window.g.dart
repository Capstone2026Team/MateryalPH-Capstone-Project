// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_window.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsWindow extends AnalyticsWindow {
  @override
  final int? presetDays;
  @override
  final Date? startDate;
  @override
  final Date? endDate;
  @override
  final Date? earliestAvailableDate;
  @override
  final Date? latestAvailableDate;
  @override
  final int maxDays;
  @override
  final BuiltList<int> presets;

  factory _$AnalyticsWindow([void Function(AnalyticsWindowBuilder)? updates]) =>
      (AnalyticsWindowBuilder()..update(updates))._build();

  _$AnalyticsWindow._(
      {this.presetDays,
      this.startDate,
      this.endDate,
      this.earliestAvailableDate,
      this.latestAvailableDate,
      required this.maxDays,
      required this.presets})
      : super._();
  @override
  AnalyticsWindow rebuild(void Function(AnalyticsWindowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsWindowBuilder toBuilder() => AnalyticsWindowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsWindow &&
        presetDays == other.presetDays &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        earliestAvailableDate == other.earliestAvailableDate &&
        latestAvailableDate == other.latestAvailableDate &&
        maxDays == other.maxDays &&
        presets == other.presets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, presetDays.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, earliestAvailableDate.hashCode);
    _$hash = $jc(_$hash, latestAvailableDate.hashCode);
    _$hash = $jc(_$hash, maxDays.hashCode);
    _$hash = $jc(_$hash, presets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsWindow')
          ..add('presetDays', presetDays)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('earliestAvailableDate', earliestAvailableDate)
          ..add('latestAvailableDate', latestAvailableDate)
          ..add('maxDays', maxDays)
          ..add('presets', presets))
        .toString();
  }
}

class AnalyticsWindowBuilder
    implements Builder<AnalyticsWindow, AnalyticsWindowBuilder> {
  _$AnalyticsWindow? _$v;

  int? _presetDays;
  int? get presetDays => _$this._presetDays;
  set presetDays(int? presetDays) => _$this._presetDays = presetDays;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  Date? _earliestAvailableDate;
  Date? get earliestAvailableDate => _$this._earliestAvailableDate;
  set earliestAvailableDate(Date? earliestAvailableDate) =>
      _$this._earliestAvailableDate = earliestAvailableDate;

  Date? _latestAvailableDate;
  Date? get latestAvailableDate => _$this._latestAvailableDate;
  set latestAvailableDate(Date? latestAvailableDate) =>
      _$this._latestAvailableDate = latestAvailableDate;

  int? _maxDays;
  int? get maxDays => _$this._maxDays;
  set maxDays(int? maxDays) => _$this._maxDays = maxDays;

  ListBuilder<int>? _presets;
  ListBuilder<int> get presets => _$this._presets ??= ListBuilder<int>();
  set presets(ListBuilder<int>? presets) => _$this._presets = presets;

  AnalyticsWindowBuilder() {
    AnalyticsWindow._defaults(this);
  }

  AnalyticsWindowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _presetDays = $v.presetDays;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _earliestAvailableDate = $v.earliestAvailableDate;
      _latestAvailableDate = $v.latestAvailableDate;
      _maxDays = $v.maxDays;
      _presets = $v.presets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsWindow other) {
    _$v = other as _$AnalyticsWindow;
  }

  @override
  void update(void Function(AnalyticsWindowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsWindow build() => _build();

  _$AnalyticsWindow _build() {
    _$AnalyticsWindow _$result;
    try {
      _$result = _$v ??
          _$AnalyticsWindow._(
            presetDays: presetDays,
            startDate: startDate,
            endDate: endDate,
            earliestAvailableDate: earliestAvailableDate,
            latestAvailableDate: latestAvailableDate,
            maxDays: BuiltValueNullFieldError.checkNotNull(
                maxDays, r'AnalyticsWindow', 'maxDays'),
            presets: presets.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'presets';
        presets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AnalyticsWindow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
