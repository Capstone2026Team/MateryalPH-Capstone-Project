// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_handler.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeHandler extends DisputeHandler {
  @override
  final DisputeHandlerRef? vendor;
  @override
  final bool adminAssigned;
  @override
  final bool adminIsMe;

  factory _$DisputeHandler([void Function(DisputeHandlerBuilder)? updates]) =>
      (DisputeHandlerBuilder()..update(updates))._build();

  _$DisputeHandler._(
      {this.vendor, required this.adminAssigned, required this.adminIsMe})
      : super._();
  @override
  DisputeHandler rebuild(void Function(DisputeHandlerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeHandlerBuilder toBuilder() => DisputeHandlerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeHandler &&
        vendor == other.vendor &&
        adminAssigned == other.adminAssigned &&
        adminIsMe == other.adminIsMe;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, adminAssigned.hashCode);
    _$hash = $jc(_$hash, adminIsMe.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeHandler')
          ..add('vendor', vendor)
          ..add('adminAssigned', adminAssigned)
          ..add('adminIsMe', adminIsMe))
        .toString();
  }
}

class DisputeHandlerBuilder
    implements Builder<DisputeHandler, DisputeHandlerBuilder> {
  _$DisputeHandler? _$v;

  DisputeHandlerRefBuilder? _vendor;
  DisputeHandlerRefBuilder get vendor =>
      _$this._vendor ??= DisputeHandlerRefBuilder();
  set vendor(DisputeHandlerRefBuilder? vendor) => _$this._vendor = vendor;

  bool? _adminAssigned;
  bool? get adminAssigned => _$this._adminAssigned;
  set adminAssigned(bool? adminAssigned) =>
      _$this._adminAssigned = adminAssigned;

  bool? _adminIsMe;
  bool? get adminIsMe => _$this._adminIsMe;
  set adminIsMe(bool? adminIsMe) => _$this._adminIsMe = adminIsMe;

  DisputeHandlerBuilder() {
    DisputeHandler._defaults(this);
  }

  DisputeHandlerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendor = $v.vendor?.toBuilder();
      _adminAssigned = $v.adminAssigned;
      _adminIsMe = $v.adminIsMe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeHandler other) {
    _$v = other as _$DisputeHandler;
  }

  @override
  void update(void Function(DisputeHandlerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeHandler build() => _build();

  _$DisputeHandler _build() {
    _$DisputeHandler _$result;
    try {
      _$result = _$v ??
          _$DisputeHandler._(
            vendor: _vendor?.build(),
            adminAssigned: BuiltValueNullFieldError.checkNotNull(
                adminAssigned, r'DisputeHandler', 'adminAssigned'),
            adminIsMe: BuiltValueNullFieldError.checkNotNull(
                adminIsMe, r'DisputeHandler', 'adminIsMe'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        _vendor?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeHandler', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
