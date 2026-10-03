// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartLineStatusEnum _$cartLineStatusEnum_READY =
    const CartLineStatusEnum._('READY');
const CartLineStatusEnum _$cartLineStatusEnum_ACTION_REQUIRED =
    const CartLineStatusEnum._('ACTION_REQUIRED');
const CartLineStatusEnum _$cartLineStatusEnum_BLOCKED =
    const CartLineStatusEnum._('BLOCKED');

CartLineStatusEnum _$cartLineStatusEnumValueOf(String name) {
  switch (name) {
    case 'READY':
      return _$cartLineStatusEnum_READY;
    case 'ACTION_REQUIRED':
      return _$cartLineStatusEnum_ACTION_REQUIRED;
    case 'BLOCKED':
      return _$cartLineStatusEnum_BLOCKED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartLineStatusEnum> _$cartLineStatusEnumValues =
    BuiltSet<CartLineStatusEnum>(const <CartLineStatusEnum>[
  _$cartLineStatusEnum_READY,
  _$cartLineStatusEnum_ACTION_REQUIRED,
  _$cartLineStatusEnum_BLOCKED,
]);

Serializer<CartLineStatusEnum> _$cartLineStatusEnumSerializer =
    _$CartLineStatusEnumSerializer();

class _$CartLineStatusEnumSerializer
    implements PrimitiveSerializer<CartLineStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };

  @override
  final Iterable<Type> types = const <Type>[CartLineStatusEnum];
  @override
  final String wireName = 'CartLineStatusEnum';

  @override
  Object serialize(Serializers serializers, CartLineStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartLineStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartLineStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartLine extends CartLine {
  @override
  final String id;
  @override
  final int lockVersion;
  @override
  final String listingId;
  @override
  final String variantId;
  @override
  final String vendorId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final ListingImage? image;
  @override
  final String unitCode;
  @override
  final String unitName;
  @override
  final String quantity;
  @override
  final String quantityStep;
  @override
  final bool savedForLater;
  @override
  final CartLineSnapshot snapshot;
  @override
  final CartLineCurrent? current;
  @override
  final int? lineTotalCentavos;
  @override
  final BuiltList<CartIssue> issues;
  @override
  final CartLineStatusEnum status;

  factory _$CartLine([void Function(CartLineBuilder)? updates]) =>
      (CartLineBuilder()..update(updates))._build();

  _$CartLine._(
      {required this.id,
      required this.lockVersion,
      required this.listingId,
      required this.variantId,
      required this.vendorId,
      required this.displayName,
      this.variantLabel,
      this.image,
      required this.unitCode,
      required this.unitName,
      required this.quantity,
      required this.quantityStep,
      required this.savedForLater,
      required this.snapshot,
      this.current,
      this.lineTotalCentavos,
      required this.issues,
      required this.status})
      : super._();
  @override
  CartLine rebuild(void Function(CartLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartLineBuilder toBuilder() => CartLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartLine &&
        id == other.id &&
        lockVersion == other.lockVersion &&
        listingId == other.listingId &&
        variantId == other.variantId &&
        vendorId == other.vendorId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        image == other.image &&
        unitCode == other.unitCode &&
        unitName == other.unitName &&
        quantity == other.quantity &&
        quantityStep == other.quantityStep &&
        savedForLater == other.savedForLater &&
        snapshot == other.snapshot &&
        current == other.current &&
        lineTotalCentavos == other.lineTotalCentavos &&
        issues == other.issues &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitName.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, quantityStep.hashCode);
    _$hash = $jc(_$hash, savedForLater.hashCode);
    _$hash = $jc(_$hash, snapshot.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, lineTotalCentavos.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartLine')
          ..add('id', id)
          ..add('lockVersion', lockVersion)
          ..add('listingId', listingId)
          ..add('variantId', variantId)
          ..add('vendorId', vendorId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('image', image)
          ..add('unitCode', unitCode)
          ..add('unitName', unitName)
          ..add('quantity', quantity)
          ..add('quantityStep', quantityStep)
          ..add('savedForLater', savedForLater)
          ..add('snapshot', snapshot)
          ..add('current', current)
          ..add('lineTotalCentavos', lineTotalCentavos)
          ..add('issues', issues)
          ..add('status', status))
        .toString();
  }
}

class CartLineBuilder implements Builder<CartLine, CartLineBuilder> {
  _$CartLine? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _unitName;
  String? get unitName => _$this._unitName;
  set unitName(String? unitName) => _$this._unitName = unitName;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  String? _quantityStep;
  String? get quantityStep => _$this._quantityStep;
  set quantityStep(String? quantityStep) => _$this._quantityStep = quantityStep;

  bool? _savedForLater;
  bool? get savedForLater => _$this._savedForLater;
  set savedForLater(bool? savedForLater) =>
      _$this._savedForLater = savedForLater;

  CartLineSnapshotBuilder? _snapshot;
  CartLineSnapshotBuilder get snapshot =>
      _$this._snapshot ??= CartLineSnapshotBuilder();
  set snapshot(CartLineSnapshotBuilder? snapshot) =>
      _$this._snapshot = snapshot;

  CartLineCurrentBuilder? _current;
  CartLineCurrentBuilder get current =>
      _$this._current ??= CartLineCurrentBuilder();
  set current(CartLineCurrentBuilder? current) => _$this._current = current;

  int? _lineTotalCentavos;
  int? get lineTotalCentavos => _$this._lineTotalCentavos;
  set lineTotalCentavos(int? lineTotalCentavos) =>
      _$this._lineTotalCentavos = lineTotalCentavos;

  ListBuilder<CartIssue>? _issues;
  ListBuilder<CartIssue> get issues =>
      _$this._issues ??= ListBuilder<CartIssue>();
  set issues(ListBuilder<CartIssue>? issues) => _$this._issues = issues;

  CartLineStatusEnum? _status;
  CartLineStatusEnum? get status => _$this._status;
  set status(CartLineStatusEnum? status) => _$this._status = status;

  CartLineBuilder() {
    CartLine._defaults(this);
  }

  CartLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _lockVersion = $v.lockVersion;
      _listingId = $v.listingId;
      _variantId = $v.variantId;
      _vendorId = $v.vendorId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _image = $v.image?.toBuilder();
      _unitCode = $v.unitCode;
      _unitName = $v.unitName;
      _quantity = $v.quantity;
      _quantityStep = $v.quantityStep;
      _savedForLater = $v.savedForLater;
      _snapshot = $v.snapshot.toBuilder();
      _current = $v.current?.toBuilder();
      _lineTotalCentavos = $v.lineTotalCentavos;
      _issues = $v.issues.toBuilder();
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartLine other) {
    _$v = other as _$CartLine;
  }

  @override
  void update(void Function(CartLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartLine build() => _build();

  _$CartLine _build() {
    _$CartLine _$result;
    try {
      _$result = _$v ??
          _$CartLine._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'CartLine', 'id'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'CartLine', 'lockVersion'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'CartLine', 'listingId'),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'CartLine', 'variantId'),
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'CartLine', 'vendorId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'CartLine', 'displayName'),
            variantLabel: variantLabel,
            image: _image?.build(),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'CartLine', 'unitCode'),
            unitName: BuiltValueNullFieldError.checkNotNull(
                unitName, r'CartLine', 'unitName'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'CartLine', 'quantity'),
            quantityStep: BuiltValueNullFieldError.checkNotNull(
                quantityStep, r'CartLine', 'quantityStep'),
            savedForLater: BuiltValueNullFieldError.checkNotNull(
                savedForLater, r'CartLine', 'savedForLater'),
            snapshot: snapshot.build(),
            current: _current?.build(),
            lineTotalCentavos: lineTotalCentavos,
            issues: issues.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CartLine', 'status'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();

        _$failedField = 'snapshot';
        snapshot.build();
        _$failedField = 'current';
        _current?.build();

        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CartLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
