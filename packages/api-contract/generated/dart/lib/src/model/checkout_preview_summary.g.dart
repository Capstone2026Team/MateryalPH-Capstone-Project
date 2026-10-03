// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_preview_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutPreviewSummaryCreatesOrdersEnum
    _$checkoutPreviewSummaryCreatesOrdersEnum_false_ =
    const CheckoutPreviewSummaryCreatesOrdersEnum._('false_');

CheckoutPreviewSummaryCreatesOrdersEnum
    _$checkoutPreviewSummaryCreatesOrdersEnumValueOf(String name) {
  switch (name) {
    case 'false_':
      return _$checkoutPreviewSummaryCreatesOrdersEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutPreviewSummaryCreatesOrdersEnum>
    _$checkoutPreviewSummaryCreatesOrdersEnumValues = BuiltSet<
        CheckoutPreviewSummaryCreatesOrdersEnum>(const <CheckoutPreviewSummaryCreatesOrdersEnum>[
  _$checkoutPreviewSummaryCreatesOrdersEnum_false_,
]);

const CheckoutPreviewSummaryReservesStockEnum
    _$checkoutPreviewSummaryReservesStockEnum_false_ =
    const CheckoutPreviewSummaryReservesStockEnum._('false_');

CheckoutPreviewSummaryReservesStockEnum
    _$checkoutPreviewSummaryReservesStockEnumValueOf(String name) {
  switch (name) {
    case 'false_':
      return _$checkoutPreviewSummaryReservesStockEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutPreviewSummaryReservesStockEnum>
    _$checkoutPreviewSummaryReservesStockEnumValues = BuiltSet<
        CheckoutPreviewSummaryReservesStockEnum>(const <CheckoutPreviewSummaryReservesStockEnum>[
  _$checkoutPreviewSummaryReservesStockEnum_false_,
]);

Serializer<CheckoutPreviewSummaryCreatesOrdersEnum>
    _$checkoutPreviewSummaryCreatesOrdersEnumSerializer =
    _$CheckoutPreviewSummaryCreatesOrdersEnumSerializer();
Serializer<CheckoutPreviewSummaryReservesStockEnum>
    _$checkoutPreviewSummaryReservesStockEnumSerializer =
    _$CheckoutPreviewSummaryReservesStockEnumSerializer();

class _$CheckoutPreviewSummaryCreatesOrdersEnumSerializer
    implements PrimitiveSerializer<CheckoutPreviewSummaryCreatesOrdersEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutPreviewSummaryCreatesOrdersEnum
  ];
  @override
  final String wireName = 'CheckoutPreviewSummaryCreatesOrdersEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutPreviewSummaryCreatesOrdersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutPreviewSummaryCreatesOrdersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutPreviewSummaryCreatesOrdersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutPreviewSummaryReservesStockEnumSerializer
    implements PrimitiveSerializer<CheckoutPreviewSummaryReservesStockEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutPreviewSummaryReservesStockEnum
  ];
  @override
  final String wireName = 'CheckoutPreviewSummaryReservesStockEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutPreviewSummaryReservesStockEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutPreviewSummaryReservesStockEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutPreviewSummaryReservesStockEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutPreviewSummary extends CheckoutPreviewSummary {
  @override
  final int groupCount;
  @override
  final int readyGroups;
  @override
  final int actionRequiredGroups;
  @override
  final int blockedGroups;
  @override
  final bool requiresSplitConfirmation;
  @override
  final CheckoutPreviewSummaryCreatesOrdersEnum createsOrders;
  @override
  final CheckoutPreviewSummaryReservesStockEnum reservesStock;
  @override
  final String notice;

  factory _$CheckoutPreviewSummary(
          [void Function(CheckoutPreviewSummaryBuilder)? updates]) =>
      (CheckoutPreviewSummaryBuilder()..update(updates))._build();

  _$CheckoutPreviewSummary._(
      {required this.groupCount,
      required this.readyGroups,
      required this.actionRequiredGroups,
      required this.blockedGroups,
      required this.requiresSplitConfirmation,
      required this.createsOrders,
      required this.reservesStock,
      required this.notice})
      : super._();
  @override
  CheckoutPreviewSummary rebuild(
          void Function(CheckoutPreviewSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutPreviewSummaryBuilder toBuilder() =>
      CheckoutPreviewSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutPreviewSummary &&
        groupCount == other.groupCount &&
        readyGroups == other.readyGroups &&
        actionRequiredGroups == other.actionRequiredGroups &&
        blockedGroups == other.blockedGroups &&
        requiresSplitConfirmation == other.requiresSplitConfirmation &&
        createsOrders == other.createsOrders &&
        reservesStock == other.reservesStock &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupCount.hashCode);
    _$hash = $jc(_$hash, readyGroups.hashCode);
    _$hash = $jc(_$hash, actionRequiredGroups.hashCode);
    _$hash = $jc(_$hash, blockedGroups.hashCode);
    _$hash = $jc(_$hash, requiresSplitConfirmation.hashCode);
    _$hash = $jc(_$hash, createsOrders.hashCode);
    _$hash = $jc(_$hash, reservesStock.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutPreviewSummary')
          ..add('groupCount', groupCount)
          ..add('readyGroups', readyGroups)
          ..add('actionRequiredGroups', actionRequiredGroups)
          ..add('blockedGroups', blockedGroups)
          ..add('requiresSplitConfirmation', requiresSplitConfirmation)
          ..add('createsOrders', createsOrders)
          ..add('reservesStock', reservesStock)
          ..add('notice', notice))
        .toString();
  }
}

class CheckoutPreviewSummaryBuilder
    implements Builder<CheckoutPreviewSummary, CheckoutPreviewSummaryBuilder> {
  _$CheckoutPreviewSummary? _$v;

  int? _groupCount;
  int? get groupCount => _$this._groupCount;
  set groupCount(int? groupCount) => _$this._groupCount = groupCount;

  int? _readyGroups;
  int? get readyGroups => _$this._readyGroups;
  set readyGroups(int? readyGroups) => _$this._readyGroups = readyGroups;

  int? _actionRequiredGroups;
  int? get actionRequiredGroups => _$this._actionRequiredGroups;
  set actionRequiredGroups(int? actionRequiredGroups) =>
      _$this._actionRequiredGroups = actionRequiredGroups;

  int? _blockedGroups;
  int? get blockedGroups => _$this._blockedGroups;
  set blockedGroups(int? blockedGroups) =>
      _$this._blockedGroups = blockedGroups;

  bool? _requiresSplitConfirmation;
  bool? get requiresSplitConfirmation => _$this._requiresSplitConfirmation;
  set requiresSplitConfirmation(bool? requiresSplitConfirmation) =>
      _$this._requiresSplitConfirmation = requiresSplitConfirmation;

  CheckoutPreviewSummaryCreatesOrdersEnum? _createsOrders;
  CheckoutPreviewSummaryCreatesOrdersEnum? get createsOrders =>
      _$this._createsOrders;
  set createsOrders(CheckoutPreviewSummaryCreatesOrdersEnum? createsOrders) =>
      _$this._createsOrders = createsOrders;

  CheckoutPreviewSummaryReservesStockEnum? _reservesStock;
  CheckoutPreviewSummaryReservesStockEnum? get reservesStock =>
      _$this._reservesStock;
  set reservesStock(CheckoutPreviewSummaryReservesStockEnum? reservesStock) =>
      _$this._reservesStock = reservesStock;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  CheckoutPreviewSummaryBuilder() {
    CheckoutPreviewSummary._defaults(this);
  }

  CheckoutPreviewSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupCount = $v.groupCount;
      _readyGroups = $v.readyGroups;
      _actionRequiredGroups = $v.actionRequiredGroups;
      _blockedGroups = $v.blockedGroups;
      _requiresSplitConfirmation = $v.requiresSplitConfirmation;
      _createsOrders = $v.createsOrders;
      _reservesStock = $v.reservesStock;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutPreviewSummary other) {
    _$v = other as _$CheckoutPreviewSummary;
  }

  @override
  void update(void Function(CheckoutPreviewSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutPreviewSummary build() => _build();

  _$CheckoutPreviewSummary _build() {
    final _$result = _$v ??
        _$CheckoutPreviewSummary._(
          groupCount: BuiltValueNullFieldError.checkNotNull(
              groupCount, r'CheckoutPreviewSummary', 'groupCount'),
          readyGroups: BuiltValueNullFieldError.checkNotNull(
              readyGroups, r'CheckoutPreviewSummary', 'readyGroups'),
          actionRequiredGroups: BuiltValueNullFieldError.checkNotNull(
              actionRequiredGroups,
              r'CheckoutPreviewSummary',
              'actionRequiredGroups'),
          blockedGroups: BuiltValueNullFieldError.checkNotNull(
              blockedGroups, r'CheckoutPreviewSummary', 'blockedGroups'),
          requiresSplitConfirmation: BuiltValueNullFieldError.checkNotNull(
              requiresSplitConfirmation,
              r'CheckoutPreviewSummary',
              'requiresSplitConfirmation'),
          createsOrders: BuiltValueNullFieldError.checkNotNull(
              createsOrders, r'CheckoutPreviewSummary', 'createsOrders'),
          reservesStock: BuiltValueNullFieldError.checkNotNull(
              reservesStock, r'CheckoutPreviewSummary', 'reservesStock'),
          notice: BuiltValueNullFieldError.checkNotNull(
              notice, r'CheckoutPreviewSummary', 'notice'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
