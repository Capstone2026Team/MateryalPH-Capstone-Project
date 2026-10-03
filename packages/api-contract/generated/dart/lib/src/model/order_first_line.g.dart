// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_first_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderFirstLine extends OrderFirstLine {
  @override
  final String displayName;
  @override
  final ListingImage? image;

  factory _$OrderFirstLine([void Function(OrderFirstLineBuilder)? updates]) =>
      (OrderFirstLineBuilder()..update(updates))._build();

  _$OrderFirstLine._({required this.displayName, this.image}) : super._();
  @override
  OrderFirstLine rebuild(void Function(OrderFirstLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderFirstLineBuilder toBuilder() => OrderFirstLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderFirstLine &&
        displayName == other.displayName &&
        image == other.image;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderFirstLine')
          ..add('displayName', displayName)
          ..add('image', image))
        .toString();
  }
}

class OrderFirstLineBuilder
    implements Builder<OrderFirstLine, OrderFirstLineBuilder> {
  _$OrderFirstLine? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  OrderFirstLineBuilder() {
    OrderFirstLine._defaults(this);
  }

  OrderFirstLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _image = $v.image?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderFirstLine other) {
    _$v = other as _$OrderFirstLine;
  }

  @override
  void update(void Function(OrderFirstLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderFirstLine build() => _build();

  _$OrderFirstLine _build() {
    _$OrderFirstLine _$result;
    try {
      _$result = _$v ??
          _$OrderFirstLine._(
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'OrderFirstLine', 'displayName'),
            image: _image?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderFirstLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
