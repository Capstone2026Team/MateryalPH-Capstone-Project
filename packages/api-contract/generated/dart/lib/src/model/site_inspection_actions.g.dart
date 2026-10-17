// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_actions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionActions extends SiteInspectionActions {
  @override
  final bool cancel;
  @override
  final bool schedule;
  @override
  final bool decline;
  @override
  final bool complete;

  factory _$SiteInspectionActions(
          [void Function(SiteInspectionActionsBuilder)? updates]) =>
      (SiteInspectionActionsBuilder()..update(updates))._build();

  _$SiteInspectionActions._(
      {required this.cancel,
      required this.schedule,
      required this.decline,
      required this.complete})
      : super._();
  @override
  SiteInspectionActions rebuild(
          void Function(SiteInspectionActionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionActionsBuilder toBuilder() =>
      SiteInspectionActionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionActions &&
        cancel == other.cancel &&
        schedule == other.schedule &&
        decline == other.decline &&
        complete == other.complete;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cancel.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, decline.hashCode);
    _$hash = $jc(_$hash, complete.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionActions')
          ..add('cancel', cancel)
          ..add('schedule', schedule)
          ..add('decline', decline)
          ..add('complete', complete))
        .toString();
  }
}

class SiteInspectionActionsBuilder
    implements Builder<SiteInspectionActions, SiteInspectionActionsBuilder> {
  _$SiteInspectionActions? _$v;

  bool? _cancel;
  bool? get cancel => _$this._cancel;
  set cancel(bool? cancel) => _$this._cancel = cancel;

  bool? _schedule;
  bool? get schedule => _$this._schedule;
  set schedule(bool? schedule) => _$this._schedule = schedule;

  bool? _decline;
  bool? get decline => _$this._decline;
  set decline(bool? decline) => _$this._decline = decline;

  bool? _complete;
  bool? get complete => _$this._complete;
  set complete(bool? complete) => _$this._complete = complete;

  SiteInspectionActionsBuilder() {
    SiteInspectionActions._defaults(this);
  }

  SiteInspectionActionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cancel = $v.cancel;
      _schedule = $v.schedule;
      _decline = $v.decline;
      _complete = $v.complete;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionActions other) {
    _$v = other as _$SiteInspectionActions;
  }

  @override
  void update(void Function(SiteInspectionActionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionActions build() => _build();

  _$SiteInspectionActions _build() {
    final _$result = _$v ??
        _$SiteInspectionActions._(
          cancel: BuiltValueNullFieldError.checkNotNull(
              cancel, r'SiteInspectionActions', 'cancel'),
          schedule: BuiltValueNullFieldError.checkNotNull(
              schedule, r'SiteInspectionActions', 'schedule'),
          decline: BuiltValueNullFieldError.checkNotNull(
              decline, r'SiteInspectionActions', 'decline'),
          complete: BuiltValueNullFieldError.checkNotNull(
              complete, r'SiteInspectionActions', 'complete'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
