// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_proof.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentProofMilestoneEnum _$fulfillmentProofMilestoneEnum_DELIVERED =
    const FulfillmentProofMilestoneEnum._('DELIVERED');
const FulfillmentProofMilestoneEnum _$fulfillmentProofMilestoneEnum_PICKED_UP =
    const FulfillmentProofMilestoneEnum._('PICKED_UP');

FulfillmentProofMilestoneEnum _$fulfillmentProofMilestoneEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERED':
      return _$fulfillmentProofMilestoneEnum_DELIVERED;
    case 'PICKED_UP':
      return _$fulfillmentProofMilestoneEnum_PICKED_UP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentProofMilestoneEnum>
    _$fulfillmentProofMilestoneEnumValues = BuiltSet<
        FulfillmentProofMilestoneEnum>(const <FulfillmentProofMilestoneEnum>[
  _$fulfillmentProofMilestoneEnum_DELIVERED,
  _$fulfillmentProofMilestoneEnum_PICKED_UP,
]);

const FulfillmentProofReceiverKindEnum
    _$fulfillmentProofReceiverKindEnum_BUYER =
    const FulfillmentProofReceiverKindEnum._('BUYER');
const FulfillmentProofReceiverKindEnum
    _$fulfillmentProofReceiverKindEnum_AUTHORIZED_RECEIVER =
    const FulfillmentProofReceiverKindEnum._('AUTHORIZED_RECEIVER');

FulfillmentProofReceiverKindEnum _$fulfillmentProofReceiverKindEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$fulfillmentProofReceiverKindEnum_BUYER;
    case 'AUTHORIZED_RECEIVER':
      return _$fulfillmentProofReceiverKindEnum_AUTHORIZED_RECEIVER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentProofReceiverKindEnum>
    _$fulfillmentProofReceiverKindEnumValues = BuiltSet<
        FulfillmentProofReceiverKindEnum>(const <FulfillmentProofReceiverKindEnum>[
  _$fulfillmentProofReceiverKindEnum_BUYER,
  _$fulfillmentProofReceiverKindEnum_AUTHORIZED_RECEIVER,
]);

Serializer<FulfillmentProofMilestoneEnum>
    _$fulfillmentProofMilestoneEnumSerializer =
    _$FulfillmentProofMilestoneEnumSerializer();
Serializer<FulfillmentProofReceiverKindEnum>
    _$fulfillmentProofReceiverKindEnumSerializer =
    _$FulfillmentProofReceiverKindEnumSerializer();

class _$FulfillmentProofMilestoneEnumSerializer
    implements PrimitiveSerializer<FulfillmentProofMilestoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentProofMilestoneEnum];
  @override
  final String wireName = 'FulfillmentProofMilestoneEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentProofMilestoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentProofMilestoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentProofMilestoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentProofReceiverKindEnumSerializer
    implements PrimitiveSerializer<FulfillmentProofReceiverKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'AUTHORIZED_RECEIVER': 'AUTHORIZED_RECEIVER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'AUTHORIZED_RECEIVER': 'AUTHORIZED_RECEIVER',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentProofReceiverKindEnum];
  @override
  final String wireName = 'FulfillmentProofReceiverKindEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentProofReceiverKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentProofReceiverKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentProofReceiverKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentProof extends FulfillmentProof {
  @override
  final FulfillmentProofMilestoneEnum milestone;
  @override
  final DateTime? recordedAt;
  @override
  final String? receiverName;
  @override
  final FulfillmentProofReceiverKindEnum? receiverKind;
  @override
  final bool handoverConfirmed;
  @override
  final String? photoPath;
  @override
  final String? signaturePath;
  @override
  final BuiltMap<String, JsonObject?>? vehicle;

  factory _$FulfillmentProof(
          [void Function(FulfillmentProofBuilder)? updates]) =>
      (FulfillmentProofBuilder()..update(updates))._build();

  _$FulfillmentProof._(
      {required this.milestone,
      this.recordedAt,
      this.receiverName,
      this.receiverKind,
      required this.handoverConfirmed,
      this.photoPath,
      this.signaturePath,
      this.vehicle})
      : super._();
  @override
  FulfillmentProof rebuild(void Function(FulfillmentProofBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentProofBuilder toBuilder() =>
      FulfillmentProofBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentProof &&
        milestone == other.milestone &&
        recordedAt == other.recordedAt &&
        receiverName == other.receiverName &&
        receiverKind == other.receiverKind &&
        handoverConfirmed == other.handoverConfirmed &&
        photoPath == other.photoPath &&
        signaturePath == other.signaturePath &&
        vehicle == other.vehicle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, milestone.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, receiverName.hashCode);
    _$hash = $jc(_$hash, receiverKind.hashCode);
    _$hash = $jc(_$hash, handoverConfirmed.hashCode);
    _$hash = $jc(_$hash, photoPath.hashCode);
    _$hash = $jc(_$hash, signaturePath.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentProof')
          ..add('milestone', milestone)
          ..add('recordedAt', recordedAt)
          ..add('receiverName', receiverName)
          ..add('receiverKind', receiverKind)
          ..add('handoverConfirmed', handoverConfirmed)
          ..add('photoPath', photoPath)
          ..add('signaturePath', signaturePath)
          ..add('vehicle', vehicle))
        .toString();
  }
}

class FulfillmentProofBuilder
    implements Builder<FulfillmentProof, FulfillmentProofBuilder> {
  _$FulfillmentProof? _$v;

  FulfillmentProofMilestoneEnum? _milestone;
  FulfillmentProofMilestoneEnum? get milestone => _$this._milestone;
  set milestone(FulfillmentProofMilestoneEnum? milestone) =>
      _$this._milestone = milestone;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  String? _receiverName;
  String? get receiverName => _$this._receiverName;
  set receiverName(String? receiverName) => _$this._receiverName = receiverName;

  FulfillmentProofReceiverKindEnum? _receiverKind;
  FulfillmentProofReceiverKindEnum? get receiverKind => _$this._receiverKind;
  set receiverKind(FulfillmentProofReceiverKindEnum? receiverKind) =>
      _$this._receiverKind = receiverKind;

  bool? _handoverConfirmed;
  bool? get handoverConfirmed => _$this._handoverConfirmed;
  set handoverConfirmed(bool? handoverConfirmed) =>
      _$this._handoverConfirmed = handoverConfirmed;

  String? _photoPath;
  String? get photoPath => _$this._photoPath;
  set photoPath(String? photoPath) => _$this._photoPath = photoPath;

  String? _signaturePath;
  String? get signaturePath => _$this._signaturePath;
  set signaturePath(String? signaturePath) =>
      _$this._signaturePath = signaturePath;

  MapBuilder<String, JsonObject?>? _vehicle;
  MapBuilder<String, JsonObject?> get vehicle =>
      _$this._vehicle ??= MapBuilder<String, JsonObject?>();
  set vehicle(MapBuilder<String, JsonObject?>? vehicle) =>
      _$this._vehicle = vehicle;

  FulfillmentProofBuilder() {
    FulfillmentProof._defaults(this);
  }

  FulfillmentProofBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _milestone = $v.milestone;
      _recordedAt = $v.recordedAt;
      _receiverName = $v.receiverName;
      _receiverKind = $v.receiverKind;
      _handoverConfirmed = $v.handoverConfirmed;
      _photoPath = $v.photoPath;
      _signaturePath = $v.signaturePath;
      _vehicle = $v.vehicle?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentProof other) {
    _$v = other as _$FulfillmentProof;
  }

  @override
  void update(void Function(FulfillmentProofBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentProof build() => _build();

  _$FulfillmentProof _build() {
    _$FulfillmentProof _$result;
    try {
      _$result = _$v ??
          _$FulfillmentProof._(
            milestone: BuiltValueNullFieldError.checkNotNull(
                milestone, r'FulfillmentProof', 'milestone'),
            recordedAt: recordedAt,
            receiverName: receiverName,
            receiverKind: receiverKind,
            handoverConfirmed: BuiltValueNullFieldError.checkNotNull(
                handoverConfirmed, r'FulfillmentProof', 'handoverConfirmed'),
            photoPath: photoPath,
            signaturePath: signaturePath,
            vehicle: _vehicle?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicle';
        _vehicle?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FulfillmentProof', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
