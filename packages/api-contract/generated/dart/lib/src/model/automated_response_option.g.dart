// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automated_response_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutomatedResponseOption extends AutomatedResponseOption {
  @override
  final String label;
  @override
  final String response;

  factory _$AutomatedResponseOption(
          [void Function(AutomatedResponseOptionBuilder)? updates]) =>
      (AutomatedResponseOptionBuilder()..update(updates))._build();

  _$AutomatedResponseOption._({required this.label, required this.response})
      : super._();
  @override
  AutomatedResponseOption rebuild(
          void Function(AutomatedResponseOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutomatedResponseOptionBuilder toBuilder() =>
      AutomatedResponseOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutomatedResponseOption &&
        label == other.label &&
        response == other.response;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, response.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutomatedResponseOption')
          ..add('label', label)
          ..add('response', response))
        .toString();
  }
}

class AutomatedResponseOptionBuilder
    implements
        Builder<AutomatedResponseOption, AutomatedResponseOptionBuilder> {
  _$AutomatedResponseOption? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _response;
  String? get response => _$this._response;
  set response(String? response) => _$this._response = response;

  AutomatedResponseOptionBuilder() {
    AutomatedResponseOption._defaults(this);
  }

  AutomatedResponseOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _response = $v.response;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutomatedResponseOption other) {
    _$v = other as _$AutomatedResponseOption;
  }

  @override
  void update(void Function(AutomatedResponseOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutomatedResponseOption build() => _build();

  _$AutomatedResponseOption _build() {
    final _$result = _$v ??
        _$AutomatedResponseOption._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AutomatedResponseOption', 'label'),
          response: BuiltValueNullFieldError.checkNotNull(
              response, r'AutomatedResponseOption', 'response'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
