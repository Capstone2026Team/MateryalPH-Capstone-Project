// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_vendor_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CartVendorRef extends CartVendorRef {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool vacationMode;

  factory _$CartVendorRef([void Function(CartVendorRefBuilder)? updates]) =>
      (CartVendorRefBuilder()..update(updates))._build();

  _$CartVendorRef._(
      {required this.id, required this.name, required this.vacationMode})
      : super._();
  @override
  CartVendorRef rebuild(void Function(CartVendorRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartVendorRefBuilder toBuilder() => CartVendorRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartVendorRef &&
        id == other.id &&
        name == other.name &&
        vacationMode == other.vacationMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartVendorRef')
          ..add('id', id)
          ..add('name', name)
          ..add('vacationMode', vacationMode))
        .toString();
  }
}

class CartVendorRefBuilder
    implements Builder<CartVendorRef, CartVendorRefBuilder> {
  _$CartVendorRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  CartVendorRefBuilder() {
    CartVendorRef._defaults(this);
  }

  CartVendorRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _vacationMode = $v.vacationMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartVendorRef other) {
    _$v = other as _$CartVendorRef;
  }

  @override
  void update(void Function(CartVendorRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartVendorRef build() => _build();

  _$CartVendorRef _build() {
    final _$result = _$v ??
        _$CartVendorRef._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CartVendorRef', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CartVendorRef', 'name'),
          vacationMode: BuiltValueNullFieldError.checkNotNull(
              vacationMode, r'CartVendorRef', 'vacationMode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
