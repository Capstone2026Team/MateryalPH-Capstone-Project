// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationItem extends NotificationItem {
  @override
  final String id;
  @override
  final String category;
  @override
  final String title;
  @override
  final String body;
  @override
  final bool mandatory;
  @override
  final String? readAt;
  @override
  final String createdAt;

  factory _$NotificationItem(
          [void Function(NotificationItemBuilder)? updates]) =>
      (NotificationItemBuilder()..update(updates))._build();

  _$NotificationItem._(
      {required this.id,
      required this.category,
      required this.title,
      required this.body,
      required this.mandatory,
      this.readAt,
      required this.createdAt})
      : super._();
  @override
  NotificationItem rebuild(void Function(NotificationItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationItemBuilder toBuilder() =>
      NotificationItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationItem &&
        id == other.id &&
        category == other.category &&
        title == other.title &&
        body == other.body &&
        mandatory == other.mandatory &&
        readAt == other.readAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, mandatory.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationItem')
          ..add('id', id)
          ..add('category', category)
          ..add('title', title)
          ..add('body', body)
          ..add('mandatory', mandatory)
          ..add('readAt', readAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NotificationItemBuilder
    implements Builder<NotificationItem, NotificationItemBuilder> {
  _$NotificationItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  bool? _mandatory;
  bool? get mandatory => _$this._mandatory;
  set mandatory(bool? mandatory) => _$this._mandatory = mandatory;

  String? _readAt;
  String? get readAt => _$this._readAt;
  set readAt(String? readAt) => _$this._readAt = readAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  NotificationItemBuilder() {
    NotificationItem._defaults(this);
  }

  NotificationItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _category = $v.category;
      _title = $v.title;
      _body = $v.body;
      _mandatory = $v.mandatory;
      _readAt = $v.readAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationItem other) {
    _$v = other as _$NotificationItem;
  }

  @override
  void update(void Function(NotificationItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationItem build() => _build();

  _$NotificationItem _build() {
    final _$result = _$v ??
        _$NotificationItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NotificationItem', 'id'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'NotificationItem', 'category'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NotificationItem', 'title'),
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'NotificationItem', 'body'),
          mandatory: BuiltValueNullFieldError.checkNotNull(
              mandatory, r'NotificationItem', 'mandatory'),
          readAt: readAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NotificationItem', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
