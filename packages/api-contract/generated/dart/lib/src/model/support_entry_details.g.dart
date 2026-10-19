// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_entry_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportEntryDetails extends SupportEntryDetails {
  @override
  final String? fromStatus;
  @override
  final String? toStatus;
  @override
  final String? previousHandler;
  @override
  final String? newHandler;

  factory _$SupportEntryDetails(
          [void Function(SupportEntryDetailsBuilder)? updates]) =>
      (SupportEntryDetailsBuilder()..update(updates))._build();

  _$SupportEntryDetails._(
      {this.fromStatus, this.toStatus, this.previousHandler, this.newHandler})
      : super._();
  @override
  SupportEntryDetails rebuild(
          void Function(SupportEntryDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportEntryDetailsBuilder toBuilder() =>
      SupportEntryDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportEntryDetails &&
        fromStatus == other.fromStatus &&
        toStatus == other.toStatus &&
        previousHandler == other.previousHandler &&
        newHandler == other.newHandler;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fromStatus.hashCode);
    _$hash = $jc(_$hash, toStatus.hashCode);
    _$hash = $jc(_$hash, previousHandler.hashCode);
    _$hash = $jc(_$hash, newHandler.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportEntryDetails')
          ..add('fromStatus', fromStatus)
          ..add('toStatus', toStatus)
          ..add('previousHandler', previousHandler)
          ..add('newHandler', newHandler))
        .toString();
  }
}

class SupportEntryDetailsBuilder
    implements Builder<SupportEntryDetails, SupportEntryDetailsBuilder> {
  _$SupportEntryDetails? _$v;

  String? _fromStatus;
  String? get fromStatus => _$this._fromStatus;
  set fromStatus(String? fromStatus) => _$this._fromStatus = fromStatus;

  String? _toStatus;
  String? get toStatus => _$this._toStatus;
  set toStatus(String? toStatus) => _$this._toStatus = toStatus;

  String? _previousHandler;
  String? get previousHandler => _$this._previousHandler;
  set previousHandler(String? previousHandler) =>
      _$this._previousHandler = previousHandler;

  String? _newHandler;
  String? get newHandler => _$this._newHandler;
  set newHandler(String? newHandler) => _$this._newHandler = newHandler;

  SupportEntryDetailsBuilder() {
    SupportEntryDetails._defaults(this);
  }

  SupportEntryDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromStatus = $v.fromStatus;
      _toStatus = $v.toStatus;
      _previousHandler = $v.previousHandler;
      _newHandler = $v.newHandler;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportEntryDetails other) {
    _$v = other as _$SupportEntryDetails;
  }

  @override
  void update(void Function(SupportEntryDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportEntryDetails build() => _build();

  _$SupportEntryDetails _build() {
    final _$result = _$v ??
        _$SupportEntryDetails._(
          fromStatus: fromStatus,
          toStatus: toStatus,
          previousHandler: previousHandler,
          newHandler: newHandler,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
