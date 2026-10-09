// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_read_filter.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationReadFilter extends NotificationReadFilter {
  @override
  final String throughId;
  @override
  final String? category;
  @override
  final String? title;

  factory _$NotificationReadFilter(
          [void Function(NotificationReadFilterBuilder)? updates]) =>
      (NotificationReadFilterBuilder()..update(updates))._build();

  _$NotificationReadFilter._(
      {required this.throughId, this.category, this.title})
      : super._();
  @override
  NotificationReadFilter rebuild(
          void Function(NotificationReadFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationReadFilterBuilder toBuilder() =>
      NotificationReadFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationReadFilter &&
        throughId == other.throughId &&
        category == other.category &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, throughId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationReadFilter')
          ..add('throughId', throughId)
          ..add('category', category)
          ..add('title', title))
        .toString();
  }
}

class NotificationReadFilterBuilder
    implements Builder<NotificationReadFilter, NotificationReadFilterBuilder> {
  _$NotificationReadFilter? _$v;

  String? _throughId;
  String? get throughId => _$this._throughId;
  set throughId(String? throughId) => _$this._throughId = throughId;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  NotificationReadFilterBuilder() {
    NotificationReadFilter._defaults(this);
  }

  NotificationReadFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _throughId = $v.throughId;
      _category = $v.category;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationReadFilter other) {
    _$v = other as _$NotificationReadFilter;
  }

  @override
  void update(void Function(NotificationReadFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationReadFilter build() => _build();

  _$NotificationReadFilter _build() {
    final _$result = _$v ??
        _$NotificationReadFilter._(
          throughId: BuiltValueNullFieldError.checkNotNull(
              throughId, r'NotificationReadFilter', 'throughId'),
          category: category,
          title: title,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
