// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_eligibility_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeEligibilityMethod extends DisputeEligibilityMethod {
  @override
  final String label;
  @override
  final String? channel;
  @override
  final bool physical;

  factory _$DisputeEligibilityMethod(
          [void Function(DisputeEligibilityMethodBuilder)? updates]) =>
      (DisputeEligibilityMethodBuilder()..update(updates))._build();

  _$DisputeEligibilityMethod._(
      {required this.label, this.channel, required this.physical})
      : super._();
  @override
  DisputeEligibilityMethod rebuild(
          void Function(DisputeEligibilityMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeEligibilityMethodBuilder toBuilder() =>
      DisputeEligibilityMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeEligibilityMethod &&
        label == other.label &&
        channel == other.channel &&
        physical == other.physical;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, physical.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeEligibilityMethod')
          ..add('label', label)
          ..add('channel', channel)
          ..add('physical', physical))
        .toString();
  }
}

class DisputeEligibilityMethodBuilder
    implements
        Builder<DisputeEligibilityMethod, DisputeEligibilityMethodBuilder> {
  _$DisputeEligibilityMethod? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  bool? _physical;
  bool? get physical => _$this._physical;
  set physical(bool? physical) => _$this._physical = physical;

  DisputeEligibilityMethodBuilder() {
    DisputeEligibilityMethod._defaults(this);
  }

  DisputeEligibilityMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _channel = $v.channel;
      _physical = $v.physical;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeEligibilityMethod other) {
    _$v = other as _$DisputeEligibilityMethod;
  }

  @override
  void update(void Function(DisputeEligibilityMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeEligibilityMethod build() => _build();

  _$DisputeEligibilityMethod _build() {
    final _$result = _$v ??
        _$DisputeEligibilityMethod._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DisputeEligibilityMethod', 'label'),
          channel: channel,
          physical: BuiltValueNullFieldError.checkNotNull(
              physical, r'DisputeEligibilityMethod', 'physical'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
