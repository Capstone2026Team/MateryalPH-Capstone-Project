// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_confirmation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockConfirmationRequest extends StockConfirmationRequest {
  @override
  final BuiltList<StockConfirmationItem> items;

  factory _$StockConfirmationRequest(
          [void Function(StockConfirmationRequestBuilder)? updates]) =>
      (StockConfirmationRequestBuilder()..update(updates))._build();

  _$StockConfirmationRequest._({required this.items}) : super._();
  @override
  StockConfirmationRequest rebuild(
          void Function(StockConfirmationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockConfirmationRequestBuilder toBuilder() =>
      StockConfirmationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockConfirmationRequest && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StockConfirmationRequest')
          ..add('items', items))
        .toString();
  }
}

class StockConfirmationRequestBuilder
    implements
        Builder<StockConfirmationRequest, StockConfirmationRequestBuilder> {
  _$StockConfirmationRequest? _$v;

  ListBuilder<StockConfirmationItem>? _items;
  ListBuilder<StockConfirmationItem> get items =>
      _$this._items ??= ListBuilder<StockConfirmationItem>();
  set items(ListBuilder<StockConfirmationItem>? items) => _$this._items = items;

  StockConfirmationRequestBuilder() {
    StockConfirmationRequest._defaults(this);
  }

  StockConfirmationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockConfirmationRequest other) {
    _$v = other as _$StockConfirmationRequest;
  }

  @override
  void update(void Function(StockConfirmationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StockConfirmationRequest build() => _build();

  _$StockConfirmationRequest _build() {
    _$StockConfirmationRequest _$result;
    try {
      _$result = _$v ??
          _$StockConfirmationRequest._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StockConfirmationRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
