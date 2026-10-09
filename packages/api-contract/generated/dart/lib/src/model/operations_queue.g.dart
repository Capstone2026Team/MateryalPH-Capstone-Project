// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operations_queue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperationsQueue extends OperationsQueue {
  @override
  final String key;
  @override
  final String label;
  @override
  final String group;
  @override
  final int count;
  @override
  final String href;
  @override
  final String description;
  @override
  final DateTime? oldestAt;

  factory _$OperationsQueue([void Function(OperationsQueueBuilder)? updates]) =>
      (OperationsQueueBuilder()..update(updates))._build();

  _$OperationsQueue._(
      {required this.key,
      required this.label,
      required this.group,
      required this.count,
      required this.href,
      required this.description,
      this.oldestAt})
      : super._();
  @override
  OperationsQueue rebuild(void Function(OperationsQueueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationsQueueBuilder toBuilder() => OperationsQueueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationsQueue &&
        key == other.key &&
        label == other.label &&
        group == other.group &&
        count == other.count &&
        href == other.href &&
        description == other.description &&
        oldestAt == other.oldestAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, href.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, oldestAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperationsQueue')
          ..add('key', key)
          ..add('label', label)
          ..add('group', group)
          ..add('count', count)
          ..add('href', href)
          ..add('description', description)
          ..add('oldestAt', oldestAt))
        .toString();
  }
}

class OperationsQueueBuilder
    implements Builder<OperationsQueue, OperationsQueueBuilder> {
  _$OperationsQueue? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _href;
  String? get href => _$this._href;
  set href(String? href) => _$this._href = href;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _oldestAt;
  DateTime? get oldestAt => _$this._oldestAt;
  set oldestAt(DateTime? oldestAt) => _$this._oldestAt = oldestAt;

  OperationsQueueBuilder() {
    OperationsQueue._defaults(this);
  }

  OperationsQueueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _group = $v.group;
      _count = $v.count;
      _href = $v.href;
      _description = $v.description;
      _oldestAt = $v.oldestAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperationsQueue other) {
    _$v = other as _$OperationsQueue;
  }

  @override
  void update(void Function(OperationsQueueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationsQueue build() => _build();

  _$OperationsQueue _build() {
    final _$result = _$v ??
        _$OperationsQueue._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'OperationsQueue', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OperationsQueue', 'label'),
          group: BuiltValueNullFieldError.checkNotNull(
              group, r'OperationsQueue', 'group'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'OperationsQueue', 'count'),
          href: BuiltValueNullFieldError.checkNotNull(
              href, r'OperationsQueue', 'href'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'OperationsQueue', 'description'),
          oldestAt: oldestAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
