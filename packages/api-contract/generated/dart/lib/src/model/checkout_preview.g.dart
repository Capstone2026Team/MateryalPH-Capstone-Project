// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutPreview extends CheckoutPreview {
  @override
  final String? requestVersion;
  @override
  final int cartLockVersion;
  @override
  final DateTime currentAsOf;
  @override
  final String calculationVersion;
  @override
  final CartDestination destination;
  @override
  final BuiltList<CheckoutGroupPreview> groups;
  @override
  final CheckoutPreviewSummary summary;

  factory _$CheckoutPreview([void Function(CheckoutPreviewBuilder)? updates]) =>
      (CheckoutPreviewBuilder()..update(updates))._build();

  _$CheckoutPreview._(
      {this.requestVersion,
      required this.cartLockVersion,
      required this.currentAsOf,
      required this.calculationVersion,
      required this.destination,
      required this.groups,
      required this.summary})
      : super._();
  @override
  CheckoutPreview rebuild(void Function(CheckoutPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutPreviewBuilder toBuilder() => CheckoutPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutPreview &&
        requestVersion == other.requestVersion &&
        cartLockVersion == other.cartLockVersion &&
        currentAsOf == other.currentAsOf &&
        calculationVersion == other.calculationVersion &&
        destination == other.destination &&
        groups == other.groups &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestVersion.hashCode);
    _$hash = $jc(_$hash, cartLockVersion.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutPreview')
          ..add('requestVersion', requestVersion)
          ..add('cartLockVersion', cartLockVersion)
          ..add('currentAsOf', currentAsOf)
          ..add('calculationVersion', calculationVersion)
          ..add('destination', destination)
          ..add('groups', groups)
          ..add('summary', summary))
        .toString();
  }
}

class CheckoutPreviewBuilder
    implements Builder<CheckoutPreview, CheckoutPreviewBuilder> {
  _$CheckoutPreview? _$v;

  String? _requestVersion;
  String? get requestVersion => _$this._requestVersion;
  set requestVersion(String? requestVersion) =>
      _$this._requestVersion = requestVersion;

  int? _cartLockVersion;
  int? get cartLockVersion => _$this._cartLockVersion;
  set cartLockVersion(int? cartLockVersion) =>
      _$this._cartLockVersion = cartLockVersion;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  CartDestinationBuilder? _destination;
  CartDestinationBuilder get destination =>
      _$this._destination ??= CartDestinationBuilder();
  set destination(CartDestinationBuilder? destination) =>
      _$this._destination = destination;

  ListBuilder<CheckoutGroupPreview>? _groups;
  ListBuilder<CheckoutGroupPreview> get groups =>
      _$this._groups ??= ListBuilder<CheckoutGroupPreview>();
  set groups(ListBuilder<CheckoutGroupPreview>? groups) =>
      _$this._groups = groups;

  CheckoutPreviewSummaryBuilder? _summary;
  CheckoutPreviewSummaryBuilder get summary =>
      _$this._summary ??= CheckoutPreviewSummaryBuilder();
  set summary(CheckoutPreviewSummaryBuilder? summary) =>
      _$this._summary = summary;

  CheckoutPreviewBuilder() {
    CheckoutPreview._defaults(this);
  }

  CheckoutPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestVersion = $v.requestVersion;
      _cartLockVersion = $v.cartLockVersion;
      _currentAsOf = $v.currentAsOf;
      _calculationVersion = $v.calculationVersion;
      _destination = $v.destination.toBuilder();
      _groups = $v.groups.toBuilder();
      _summary = $v.summary.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutPreview other) {
    _$v = other as _$CheckoutPreview;
  }

  @override
  void update(void Function(CheckoutPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutPreview build() => _build();

  _$CheckoutPreview _build() {
    _$CheckoutPreview _$result;
    try {
      _$result = _$v ??
          _$CheckoutPreview._(
            requestVersion: requestVersion,
            cartLockVersion: BuiltValueNullFieldError.checkNotNull(
                cartLockVersion, r'CheckoutPreview', 'cartLockVersion'),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'CheckoutPreview', 'currentAsOf'),
            calculationVersion: BuiltValueNullFieldError.checkNotNull(
                calculationVersion, r'CheckoutPreview', 'calculationVersion'),
            destination: destination.build(),
            groups: groups.build(),
            summary: summary.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'destination';
        destination.build();
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'summary';
        summary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
