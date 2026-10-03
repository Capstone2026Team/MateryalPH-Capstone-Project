// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentStepStatusEnum _$fulfillmentStepStatusEnum_COMPLETE =
    const FulfillmentStepStatusEnum._('COMPLETE');
const FulfillmentStepStatusEnum _$fulfillmentStepStatusEnum_CURRENT =
    const FulfillmentStepStatusEnum._('CURRENT');
const FulfillmentStepStatusEnum _$fulfillmentStepStatusEnum_UPCOMING =
    const FulfillmentStepStatusEnum._('UPCOMING');

FulfillmentStepStatusEnum _$fulfillmentStepStatusEnumValueOf(String name) {
  switch (name) {
    case 'COMPLETE':
      return _$fulfillmentStepStatusEnum_COMPLETE;
    case 'CURRENT':
      return _$fulfillmentStepStatusEnum_CURRENT;
    case 'UPCOMING':
      return _$fulfillmentStepStatusEnum_UPCOMING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentStepStatusEnum> _$fulfillmentStepStatusEnumValues =
    BuiltSet<FulfillmentStepStatusEnum>(const <FulfillmentStepStatusEnum>[
  _$fulfillmentStepStatusEnum_COMPLETE,
  _$fulfillmentStepStatusEnum_CURRENT,
  _$fulfillmentStepStatusEnum_UPCOMING,
]);

const FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnum_DELIVERY_PHOTO =
    const FulfillmentStepProofRequirementsEnum._('DELIVERY_PHOTO');
const FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnum_RECEIVER_NAME =
    const FulfillmentStepProofRequirementsEnum._('RECEIVER_NAME');
const FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnum_SIGNATURE_OPTIONAL =
    const FulfillmentStepProofRequirementsEnum._('SIGNATURE_OPTIONAL');
const FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnum_HANDOVER_CONFIRMATION =
    const FulfillmentStepProofRequirementsEnum._('HANDOVER_CONFIRMATION');
const FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnum_RECEIVER_TYPE =
    const FulfillmentStepProofRequirementsEnum._('RECEIVER_TYPE');

FulfillmentStepProofRequirementsEnum
    _$fulfillmentStepProofRequirementsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY_PHOTO':
      return _$fulfillmentStepProofRequirementsEnum_DELIVERY_PHOTO;
    case 'RECEIVER_NAME':
      return _$fulfillmentStepProofRequirementsEnum_RECEIVER_NAME;
    case 'SIGNATURE_OPTIONAL':
      return _$fulfillmentStepProofRequirementsEnum_SIGNATURE_OPTIONAL;
    case 'HANDOVER_CONFIRMATION':
      return _$fulfillmentStepProofRequirementsEnum_HANDOVER_CONFIRMATION;
    case 'RECEIVER_TYPE':
      return _$fulfillmentStepProofRequirementsEnum_RECEIVER_TYPE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentStepProofRequirementsEnum>
    _$fulfillmentStepProofRequirementsEnumValues = BuiltSet<
        FulfillmentStepProofRequirementsEnum>(const <FulfillmentStepProofRequirementsEnum>[
  _$fulfillmentStepProofRequirementsEnum_DELIVERY_PHOTO,
  _$fulfillmentStepProofRequirementsEnum_RECEIVER_NAME,
  _$fulfillmentStepProofRequirementsEnum_SIGNATURE_OPTIONAL,
  _$fulfillmentStepProofRequirementsEnum_HANDOVER_CONFIRMATION,
  _$fulfillmentStepProofRequirementsEnum_RECEIVER_TYPE,
]);

Serializer<FulfillmentStepStatusEnum> _$fulfillmentStepStatusEnumSerializer =
    _$FulfillmentStepStatusEnumSerializer();
Serializer<FulfillmentStepProofRequirementsEnum>
    _$fulfillmentStepProofRequirementsEnumSerializer =
    _$FulfillmentStepProofRequirementsEnumSerializer();

class _$FulfillmentStepStatusEnumSerializer
    implements PrimitiveSerializer<FulfillmentStepStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETE': 'COMPLETE',
    'CURRENT': 'CURRENT',
    'UPCOMING': 'UPCOMING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETE': 'COMPLETE',
    'CURRENT': 'CURRENT',
    'UPCOMING': 'UPCOMING',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentStepStatusEnum];
  @override
  final String wireName = 'FulfillmentStepStatusEnum';

  @override
  Object serialize(Serializers serializers, FulfillmentStepStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentStepStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentStepStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentStepProofRequirementsEnumSerializer
    implements PrimitiveSerializer<FulfillmentStepProofRequirementsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY_PHOTO': 'DELIVERY_PHOTO',
    'RECEIVER_NAME': 'RECEIVER_NAME',
    'SIGNATURE_OPTIONAL': 'SIGNATURE_OPTIONAL',
    'HANDOVER_CONFIRMATION': 'HANDOVER_CONFIRMATION',
    'RECEIVER_TYPE': 'RECEIVER_TYPE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY_PHOTO': 'DELIVERY_PHOTO',
    'RECEIVER_NAME': 'RECEIVER_NAME',
    'SIGNATURE_OPTIONAL': 'SIGNATURE_OPTIONAL',
    'HANDOVER_CONFIRMATION': 'HANDOVER_CONFIRMATION',
    'RECEIVER_TYPE': 'RECEIVER_TYPE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentStepProofRequirementsEnum
  ];
  @override
  final String wireName = 'FulfillmentStepProofRequirementsEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentStepProofRequirementsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentStepProofRequirementsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentStepProofRequirementsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentStep extends FulfillmentStep {
  @override
  final String key;
  @override
  final String label;
  @override
  final FulfillmentStepStatusEnum status;
  @override
  final DateTime? at;
  @override
  final String? actorRole;
  @override
  final bool proofRequired;
  @override
  final FulfillmentProof? proof;
  @override
  final BuiltList<FulfillmentStepProofRequirementsEnum> proofRequirements;

  factory _$FulfillmentStep([void Function(FulfillmentStepBuilder)? updates]) =>
      (FulfillmentStepBuilder()..update(updates))._build();

  _$FulfillmentStep._(
      {required this.key,
      required this.label,
      required this.status,
      this.at,
      this.actorRole,
      required this.proofRequired,
      this.proof,
      required this.proofRequirements})
      : super._();
  @override
  FulfillmentStep rebuild(void Function(FulfillmentStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentStepBuilder toBuilder() => FulfillmentStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentStep &&
        key == other.key &&
        label == other.label &&
        status == other.status &&
        at == other.at &&
        actorRole == other.actorRole &&
        proofRequired == other.proofRequired &&
        proof == other.proof &&
        proofRequirements == other.proofRequirements;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, proofRequired.hashCode);
    _$hash = $jc(_$hash, proof.hashCode);
    _$hash = $jc(_$hash, proofRequirements.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentStep')
          ..add('key', key)
          ..add('label', label)
          ..add('status', status)
          ..add('at', at)
          ..add('actorRole', actorRole)
          ..add('proofRequired', proofRequired)
          ..add('proof', proof)
          ..add('proofRequirements', proofRequirements))
        .toString();
  }
}

class FulfillmentStepBuilder
    implements Builder<FulfillmentStep, FulfillmentStepBuilder> {
  _$FulfillmentStep? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  FulfillmentStepStatusEnum? _status;
  FulfillmentStepStatusEnum? get status => _$this._status;
  set status(FulfillmentStepStatusEnum? status) => _$this._status = status;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  bool? _proofRequired;
  bool? get proofRequired => _$this._proofRequired;
  set proofRequired(bool? proofRequired) =>
      _$this._proofRequired = proofRequired;

  FulfillmentProofBuilder? _proof;
  FulfillmentProofBuilder get proof =>
      _$this._proof ??= FulfillmentProofBuilder();
  set proof(FulfillmentProofBuilder? proof) => _$this._proof = proof;

  ListBuilder<FulfillmentStepProofRequirementsEnum>? _proofRequirements;
  ListBuilder<FulfillmentStepProofRequirementsEnum> get proofRequirements =>
      _$this._proofRequirements ??=
          ListBuilder<FulfillmentStepProofRequirementsEnum>();
  set proofRequirements(
          ListBuilder<FulfillmentStepProofRequirementsEnum>?
              proofRequirements) =>
      _$this._proofRequirements = proofRequirements;

  FulfillmentStepBuilder() {
    FulfillmentStep._defaults(this);
  }

  FulfillmentStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _status = $v.status;
      _at = $v.at;
      _actorRole = $v.actorRole;
      _proofRequired = $v.proofRequired;
      _proof = $v.proof?.toBuilder();
      _proofRequirements = $v.proofRequirements.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentStep other) {
    _$v = other as _$FulfillmentStep;
  }

  @override
  void update(void Function(FulfillmentStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentStep build() => _build();

  _$FulfillmentStep _build() {
    _$FulfillmentStep _$result;
    try {
      _$result = _$v ??
          _$FulfillmentStep._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'FulfillmentStep', 'key'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'FulfillmentStep', 'label'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'FulfillmentStep', 'status'),
            at: at,
            actorRole: actorRole,
            proofRequired: BuiltValueNullFieldError.checkNotNull(
                proofRequired, r'FulfillmentStep', 'proofRequired'),
            proof: _proof?.build(),
            proofRequirements: proofRequirements.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'proof';
        _proof?.build();
        _$failedField = 'proofRequirements';
        proofRequirements.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FulfillmentStep', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
