// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PickupConfirmation extends PickupConfirmation {
  @override
  final Date readyDate;

  factory _$PickupConfirmation(
          [void Function(PickupConfirmationBuilder)? updates]) =>
      (PickupConfirmationBuilder()..update(updates))._build();

  _$PickupConfirmation._({required this.readyDate}) : super._();
  @override
  PickupConfirmation rebuild(
          void Function(PickupConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PickupConfirmationBuilder toBuilder() =>
      PickupConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PickupConfirmation && readyDate == other.readyDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, readyDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PickupConfirmation')
          ..add('readyDate', readyDate))
        .toString();
  }
}

class PickupConfirmationBuilder
    implements Builder<PickupConfirmation, PickupConfirmationBuilder> {
  _$PickupConfirmation? _$v;

  Date? _readyDate;
  Date? get readyDate => _$this._readyDate;
  set readyDate(Date? readyDate) => _$this._readyDate = readyDate;

  PickupConfirmationBuilder() {
    PickupConfirmation._defaults(this);
  }

  PickupConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _readyDate = $v.readyDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PickupConfirmation other) {
    _$v = other as _$PickupConfirmation;
  }

  @override
  void update(void Function(PickupConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PickupConfirmation build() => _build();

  _$PickupConfirmation _build() {
    final _$result = _$v ??
        _$PickupConfirmation._(
          readyDate: BuiltValueNullFieldError.checkNotNull(
              readyDate, r'PickupConfirmation', 'readyDate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
