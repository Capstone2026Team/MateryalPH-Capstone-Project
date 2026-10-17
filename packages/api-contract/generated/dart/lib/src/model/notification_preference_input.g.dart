// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationPreferenceInput extends NotificationPreferenceInput {
  @override
  final String category;
  @override
  final bool inApp;
  @override
  final bool email;
  @override
  final bool push;

  factory _$NotificationPreferenceInput(
          [void Function(NotificationPreferenceInputBuilder)? updates]) =>
      (NotificationPreferenceInputBuilder()..update(updates))._build();

  _$NotificationPreferenceInput._(
      {required this.category,
      required this.inApp,
      required this.email,
      required this.push})
      : super._();
  @override
  NotificationPreferenceInput rebuild(
          void Function(NotificationPreferenceInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationPreferenceInputBuilder toBuilder() =>
      NotificationPreferenceInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationPreferenceInput &&
        category == other.category &&
        inApp == other.inApp &&
        email == other.email &&
        push == other.push;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, inApp.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, push.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationPreferenceInput')
          ..add('category', category)
          ..add('inApp', inApp)
          ..add('email', email)
          ..add('push', push))
        .toString();
  }
}

class NotificationPreferenceInputBuilder
    implements
        Builder<NotificationPreferenceInput,
            NotificationPreferenceInputBuilder> {
  _$NotificationPreferenceInput? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  bool? _inApp;
  bool? get inApp => _$this._inApp;
  set inApp(bool? inApp) => _$this._inApp = inApp;

  bool? _email;
  bool? get email => _$this._email;
  set email(bool? email) => _$this._email = email;

  bool? _push;
  bool? get push => _$this._push;
  set push(bool? push) => _$this._push = push;

  NotificationPreferenceInputBuilder() {
    NotificationPreferenceInput._defaults(this);
  }

  NotificationPreferenceInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _inApp = $v.inApp;
      _email = $v.email;
      _push = $v.push;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationPreferenceInput other) {
    _$v = other as _$NotificationPreferenceInput;
  }

  @override
  void update(void Function(NotificationPreferenceInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationPreferenceInput build() => _build();

  _$NotificationPreferenceInput _build() {
    final _$result = _$v ??
        _$NotificationPreferenceInput._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'NotificationPreferenceInput', 'category'),
          inApp: BuiltValueNullFieldError.checkNotNull(
              inApp, r'NotificationPreferenceInput', 'inApp'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'NotificationPreferenceInput', 'email'),
          push: BuiltValueNullFieldError.checkNotNull(
              push, r'NotificationPreferenceInput', 'push'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
