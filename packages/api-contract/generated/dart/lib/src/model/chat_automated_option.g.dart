// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_automated_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatAutomatedOption extends ChatAutomatedOption {
  @override
  final int index;
  @override
  final String label;
  @override
  final bool available;

  factory _$ChatAutomatedOption(
          [void Function(ChatAutomatedOptionBuilder)? updates]) =>
      (ChatAutomatedOptionBuilder()..update(updates))._build();

  _$ChatAutomatedOption._(
      {required this.index, required this.label, required this.available})
      : super._();
  @override
  ChatAutomatedOption rebuild(
          void Function(ChatAutomatedOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatAutomatedOptionBuilder toBuilder() =>
      ChatAutomatedOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatAutomatedOption &&
        index == other.index &&
        label == other.label &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, index.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatAutomatedOption')
          ..add('index', index)
          ..add('label', label)
          ..add('available', available))
        .toString();
  }
}

class ChatAutomatedOptionBuilder
    implements Builder<ChatAutomatedOption, ChatAutomatedOptionBuilder> {
  _$ChatAutomatedOption? _$v;

  int? _index;
  int? get index => _$this._index;
  set index(int? index) => _$this._index = index;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  ChatAutomatedOptionBuilder() {
    ChatAutomatedOption._defaults(this);
  }

  ChatAutomatedOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _index = $v.index;
      _label = $v.label;
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatAutomatedOption other) {
    _$v = other as _$ChatAutomatedOption;
  }

  @override
  void update(void Function(ChatAutomatedOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatAutomatedOption build() => _build();

  _$ChatAutomatedOption _build() {
    final _$result = _$v ??
        _$ChatAutomatedOption._(
          index: BuiltValueNullFieldError.checkNotNull(
              index, r'ChatAutomatedOption', 'index'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ChatAutomatedOption', 'label'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'ChatAutomatedOption', 'available'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
