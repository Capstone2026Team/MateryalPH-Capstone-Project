// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_receipt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentReceiptConfirmationSourceEnum
    _$fulfillmentReceiptConfirmationSourceEnum_BUYER =
    const FulfillmentReceiptConfirmationSourceEnum._('BUYER');
const FulfillmentReceiptConfirmationSourceEnum
    _$fulfillmentReceiptConfirmationSourceEnum_AUTO_CONFIRMATION =
    const FulfillmentReceiptConfirmationSourceEnum._('AUTO_CONFIRMATION');

FulfillmentReceiptConfirmationSourceEnum
    _$fulfillmentReceiptConfirmationSourceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$fulfillmentReceiptConfirmationSourceEnum_BUYER;
    case 'AUTO_CONFIRMATION':
      return _$fulfillmentReceiptConfirmationSourceEnum_AUTO_CONFIRMATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentReceiptConfirmationSourceEnum>
    _$fulfillmentReceiptConfirmationSourceEnumValues = BuiltSet<
        FulfillmentReceiptConfirmationSourceEnum>(const <FulfillmentReceiptConfirmationSourceEnum>[
  _$fulfillmentReceiptConfirmationSourceEnum_BUYER,
  _$fulfillmentReceiptConfirmationSourceEnum_AUTO_CONFIRMATION,
]);

Serializer<FulfillmentReceiptConfirmationSourceEnum>
    _$fulfillmentReceiptConfirmationSourceEnumSerializer =
    _$FulfillmentReceiptConfirmationSourceEnumSerializer();

class _$FulfillmentReceiptConfirmationSourceEnumSerializer
    implements PrimitiveSerializer<FulfillmentReceiptConfirmationSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'AUTO_CONFIRMATION': 'AUTO_CONFIRMATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'AUTO_CONFIRMATION': 'AUTO_CONFIRMATION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentReceiptConfirmationSourceEnum
  ];
  @override
  final String wireName = 'FulfillmentReceiptConfirmationSourceEnum';

  @override
  Object serialize(Serializers serializers,
          FulfillmentReceiptConfirmationSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentReceiptConfirmationSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentReceiptConfirmationSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentReceipt extends FulfillmentReceipt {
  @override
  final DateTime? dueAt;
  @override
  final bool paused;
  @override
  final int? remainingSeconds;
  @override
  final DateTime? confirmedAt;
  @override
  final FulfillmentReceiptConfirmationSourceEnum? confirmationSource;
  @override
  final int windowHours;

  factory _$FulfillmentReceipt(
          [void Function(FulfillmentReceiptBuilder)? updates]) =>
      (FulfillmentReceiptBuilder()..update(updates))._build();

  _$FulfillmentReceipt._(
      {this.dueAt,
      required this.paused,
      this.remainingSeconds,
      this.confirmedAt,
      this.confirmationSource,
      required this.windowHours})
      : super._();
  @override
  FulfillmentReceipt rebuild(
          void Function(FulfillmentReceiptBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentReceiptBuilder toBuilder() =>
      FulfillmentReceiptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentReceipt &&
        dueAt == other.dueAt &&
        paused == other.paused &&
        remainingSeconds == other.remainingSeconds &&
        confirmedAt == other.confirmedAt &&
        confirmationSource == other.confirmationSource &&
        windowHours == other.windowHours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, paused.hashCode);
    _$hash = $jc(_$hash, remainingSeconds.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jc(_$hash, confirmationSource.hashCode);
    _$hash = $jc(_$hash, windowHours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentReceipt')
          ..add('dueAt', dueAt)
          ..add('paused', paused)
          ..add('remainingSeconds', remainingSeconds)
          ..add('confirmedAt', confirmedAt)
          ..add('confirmationSource', confirmationSource)
          ..add('windowHours', windowHours))
        .toString();
  }
}

class FulfillmentReceiptBuilder
    implements Builder<FulfillmentReceipt, FulfillmentReceiptBuilder> {
  _$FulfillmentReceipt? _$v;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  bool? _paused;
  bool? get paused => _$this._paused;
  set paused(bool? paused) => _$this._paused = paused;

  int? _remainingSeconds;
  int? get remainingSeconds => _$this._remainingSeconds;
  set remainingSeconds(int? remainingSeconds) =>
      _$this._remainingSeconds = remainingSeconds;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  FulfillmentReceiptConfirmationSourceEnum? _confirmationSource;
  FulfillmentReceiptConfirmationSourceEnum? get confirmationSource =>
      _$this._confirmationSource;
  set confirmationSource(
          FulfillmentReceiptConfirmationSourceEnum? confirmationSource) =>
      _$this._confirmationSource = confirmationSource;

  int? _windowHours;
  int? get windowHours => _$this._windowHours;
  set windowHours(int? windowHours) => _$this._windowHours = windowHours;

  FulfillmentReceiptBuilder() {
    FulfillmentReceipt._defaults(this);
  }

  FulfillmentReceiptBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dueAt = $v.dueAt;
      _paused = $v.paused;
      _remainingSeconds = $v.remainingSeconds;
      _confirmedAt = $v.confirmedAt;
      _confirmationSource = $v.confirmationSource;
      _windowHours = $v.windowHours;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentReceipt other) {
    _$v = other as _$FulfillmentReceipt;
  }

  @override
  void update(void Function(FulfillmentReceiptBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentReceipt build() => _build();

  _$FulfillmentReceipt _build() {
    final _$result = _$v ??
        _$FulfillmentReceipt._(
          dueAt: dueAt,
          paused: BuiltValueNullFieldError.checkNotNull(
              paused, r'FulfillmentReceipt', 'paused'),
          remainingSeconds: remainingSeconds,
          confirmedAt: confirmedAt,
          confirmationSource: confirmationSource,
          windowHours: BuiltValueNullFieldError.checkNotNull(
              windowHours, r'FulfillmentReceipt', 'windowHours'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
