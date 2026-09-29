// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Cart extends Cart {
  @override
  final String id;
  @override
  final int lockVersion;
  @override
  final DateTime currentAsOf;
  @override
  final CartDestination destination;
  @override
  final BuiltList<CartVendorGroup> groups;
  @override
  final BuiltList<CartLine> savedForLater;
  @override
  final CartSummary summary;

  factory _$Cart([void Function(CartBuilder)? updates]) =>
      (CartBuilder()..update(updates))._build();

  _$Cart._(
      {required this.id,
      required this.lockVersion,
      required this.currentAsOf,
      required this.destination,
      required this.groups,
      required this.savedForLater,
      required this.summary})
      : super._();
  @override
  Cart rebuild(void Function(CartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartBuilder toBuilder() => CartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cart &&
        id == other.id &&
        lockVersion == other.lockVersion &&
        currentAsOf == other.currentAsOf &&
        destination == other.destination &&
        groups == other.groups &&
        savedForLater == other.savedForLater &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, savedForLater.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Cart')
          ..add('id', id)
          ..add('lockVersion', lockVersion)
          ..add('currentAsOf', currentAsOf)
          ..add('destination', destination)
          ..add('groups', groups)
          ..add('savedForLater', savedForLater)
          ..add('summary', summary))
        .toString();
  }
}

class CartBuilder implements Builder<Cart, CartBuilder> {
  _$Cart? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  CartDestinationBuilder? _destination;
  CartDestinationBuilder get destination =>
      _$this._destination ??= CartDestinationBuilder();
  set destination(CartDestinationBuilder? destination) =>
      _$this._destination = destination;

  ListBuilder<CartVendorGroup>? _groups;
  ListBuilder<CartVendorGroup> get groups =>
      _$this._groups ??= ListBuilder<CartVendorGroup>();
  set groups(ListBuilder<CartVendorGroup>? groups) => _$this._groups = groups;

  ListBuilder<CartLine>? _savedForLater;
  ListBuilder<CartLine> get savedForLater =>
      _$this._savedForLater ??= ListBuilder<CartLine>();
  set savedForLater(ListBuilder<CartLine>? savedForLater) =>
      _$this._savedForLater = savedForLater;

  CartSummaryBuilder? _summary;
  CartSummaryBuilder get summary => _$this._summary ??= CartSummaryBuilder();
  set summary(CartSummaryBuilder? summary) => _$this._summary = summary;

  CartBuilder() {
    Cart._defaults(this);
  }

  CartBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _lockVersion = $v.lockVersion;
      _currentAsOf = $v.currentAsOf;
      _destination = $v.destination.toBuilder();
      _groups = $v.groups.toBuilder();
      _savedForLater = $v.savedForLater.toBuilder();
      _summary = $v.summary.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Cart other) {
    _$v = other as _$Cart;
  }

  @override
  void update(void Function(CartBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Cart build() => _build();

  _$Cart _build() {
    _$Cart _$result;
    try {
      _$result = _$v ??
          _$Cart._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Cart', 'id'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'Cart', 'lockVersion'),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'Cart', 'currentAsOf'),
            destination: destination.build(),
            groups: groups.build(),
            savedForLater: savedForLater.build(),
            summary: summary.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'destination';
        destination.build();
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'savedForLater';
        savedForLater.build();
        _$failedField = 'summary';
        summary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Cart', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
