// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationChange extends ChatQuotationChange {
  @override
  final String path;
  @override
  final String label;
  @override
  final JsonObject? before;
  @override
  final JsonObject? after;

  factory _$ChatQuotationChange(
          [void Function(ChatQuotationChangeBuilder)? updates]) =>
      (ChatQuotationChangeBuilder()..update(updates))._build();

  _$ChatQuotationChange._(
      {required this.path, required this.label, this.before, this.after})
      : super._();
  @override
  ChatQuotationChange rebuild(
          void Function(ChatQuotationChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationChangeBuilder toBuilder() =>
      ChatQuotationChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationChange &&
        path == other.path &&
        label == other.label &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationChange')
          ..add('path', path)
          ..add('label', label)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class ChatQuotationChangeBuilder
    implements Builder<ChatQuotationChange, ChatQuotationChangeBuilder> {
  _$ChatQuotationChange? _$v;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  JsonObject? _before;
  JsonObject? get before => _$this._before;
  set before(JsonObject? before) => _$this._before = before;

  JsonObject? _after;
  JsonObject? get after => _$this._after;
  set after(JsonObject? after) => _$this._after = after;

  ChatQuotationChangeBuilder() {
    ChatQuotationChange._defaults(this);
  }

  ChatQuotationChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _path = $v.path;
      _label = $v.label;
      _before = $v.before;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationChange other) {
    _$v = other as _$ChatQuotationChange;
  }

  @override
  void update(void Function(ChatQuotationChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationChange build() => _build();

  _$ChatQuotationChange _build() {
    final _$result = _$v ??
        _$ChatQuotationChange._(
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'ChatQuotationChange', 'path'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ChatQuotationChange', 'label'),
          before: before,
          after: after,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
