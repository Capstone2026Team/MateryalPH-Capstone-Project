// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_conversation_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderConversationRef extends OrderConversationRef {
  @override
  final String id;
  @override
  final bool readOnly;
  @override
  final int unreadCount;

  factory _$OrderConversationRef(
          [void Function(OrderConversationRefBuilder)? updates]) =>
      (OrderConversationRefBuilder()..update(updates))._build();

  _$OrderConversationRef._(
      {required this.id, required this.readOnly, required this.unreadCount})
      : super._();
  @override
  OrderConversationRef rebuild(
          void Function(OrderConversationRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderConversationRefBuilder toBuilder() =>
      OrderConversationRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderConversationRef &&
        id == other.id &&
        readOnly == other.readOnly &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, readOnly.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderConversationRef')
          ..add('id', id)
          ..add('readOnly', readOnly)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class OrderConversationRefBuilder
    implements Builder<OrderConversationRef, OrderConversationRefBuilder> {
  _$OrderConversationRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _readOnly;
  bool? get readOnly => _$this._readOnly;
  set readOnly(bool? readOnly) => _$this._readOnly = readOnly;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  OrderConversationRefBuilder() {
    OrderConversationRef._defaults(this);
  }

  OrderConversationRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _readOnly = $v.readOnly;
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderConversationRef other) {
    _$v = other as _$OrderConversationRef;
  }

  @override
  void update(void Function(OrderConversationRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderConversationRef build() => _build();

  _$OrderConversationRef _build() {
    final _$result = _$v ??
        _$OrderConversationRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'OrderConversationRef', 'id'),
          readOnly: BuiltValueNullFieldError.checkNotNull(
              readOnly, r'OrderConversationRef', 'readOnly'),
          unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount, r'OrderConversationRef', 'unreadCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
