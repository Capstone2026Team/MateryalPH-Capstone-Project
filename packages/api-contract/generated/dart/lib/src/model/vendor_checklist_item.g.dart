// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_checklist_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorChecklistItemSectionEnum
    _$vendorChecklistItemSectionEnum_STORE_VERIFICATION =
    const VendorChecklistItemSectionEnum._('STORE_VERIFICATION');
const VendorChecklistItemSectionEnum
    _$vendorChecklistItemSectionEnum_STORE_SETUP =
    const VendorChecklistItemSectionEnum._('STORE_SETUP');

VendorChecklistItemSectionEnum _$vendorChecklistItemSectionEnumValueOf(
    String name) {
  switch (name) {
    case 'STORE_VERIFICATION':
      return _$vendorChecklistItemSectionEnum_STORE_VERIFICATION;
    case 'STORE_SETUP':
      return _$vendorChecklistItemSectionEnum_STORE_SETUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorChecklistItemSectionEnum>
    _$vendorChecklistItemSectionEnumValues = BuiltSet<
        VendorChecklistItemSectionEnum>(const <VendorChecklistItemSectionEnum>[
  _$vendorChecklistItemSectionEnum_STORE_VERIFICATION,
  _$vendorChecklistItemSectionEnum_STORE_SETUP,
]);

const VendorChecklistItemRequirementLevelEnum
    _$vendorChecklistItemRequirementLevelEnum_REQUIRED =
    const VendorChecklistItemRequirementLevelEnum._('REQUIRED');
const VendorChecklistItemRequirementLevelEnum
    _$vendorChecklistItemRequirementLevelEnum_OPTIONAL =
    const VendorChecklistItemRequirementLevelEnum._('OPTIONAL');
const VendorChecklistItemRequirementLevelEnum
    _$vendorChecklistItemRequirementLevelEnum_CONDITIONALLY_REQUIRED =
    const VendorChecklistItemRequirementLevelEnum._('CONDITIONALLY_REQUIRED');

VendorChecklistItemRequirementLevelEnum
    _$vendorChecklistItemRequirementLevelEnumValueOf(String name) {
  switch (name) {
    case 'REQUIRED':
      return _$vendorChecklistItemRequirementLevelEnum_REQUIRED;
    case 'OPTIONAL':
      return _$vendorChecklistItemRequirementLevelEnum_OPTIONAL;
    case 'CONDITIONALLY_REQUIRED':
      return _$vendorChecklistItemRequirementLevelEnum_CONDITIONALLY_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorChecklistItemRequirementLevelEnum>
    _$vendorChecklistItemRequirementLevelEnumValues = BuiltSet<
        VendorChecklistItemRequirementLevelEnum>(const <VendorChecklistItemRequirementLevelEnum>[
  _$vendorChecklistItemRequirementLevelEnum_REQUIRED,
  _$vendorChecklistItemRequirementLevelEnum_OPTIONAL,
  _$vendorChecklistItemRequirementLevelEnum_CONDITIONALLY_REQUIRED,
]);

const VendorChecklistItemStatusEnum
    _$vendorChecklistItemStatusEnum_NOT_STARTED =
    const VendorChecklistItemStatusEnum._('NOT_STARTED');
const VendorChecklistItemStatusEnum
    _$vendorChecklistItemStatusEnum_IN_PROGRESS =
    const VendorChecklistItemStatusEnum._('IN_PROGRESS');
const VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnum_SUBMITTED =
    const VendorChecklistItemStatusEnum._('SUBMITTED');
const VendorChecklistItemStatusEnum
    _$vendorChecklistItemStatusEnum_PENDING_VERIFICATION =
    const VendorChecklistItemStatusEnum._('PENDING_VERIFICATION');
const VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnum_APPROVED =
    const VendorChecklistItemStatusEnum._('APPROVED');
const VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnum_COMPLETED =
    const VendorChecklistItemStatusEnum._('COMPLETED');
const VendorChecklistItemStatusEnum
    _$vendorChecklistItemStatusEnum_CHANGES_REQUIRED =
    const VendorChecklistItemStatusEnum._('CHANGES_REQUIRED');
const VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnum_REJECTED =
    const VendorChecklistItemStatusEnum._('REJECTED');
const VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnum_EXPIRED =
    const VendorChecklistItemStatusEnum._('EXPIRED');
const VendorChecklistItemStatusEnum
    _$vendorChecklistItemStatusEnum_NOT_APPLICABLE =
    const VendorChecklistItemStatusEnum._('NOT_APPLICABLE');

VendorChecklistItemStatusEnum _$vendorChecklistItemStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_STARTED':
      return _$vendorChecklistItemStatusEnum_NOT_STARTED;
    case 'IN_PROGRESS':
      return _$vendorChecklistItemStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$vendorChecklistItemStatusEnum_SUBMITTED;
    case 'PENDING_VERIFICATION':
      return _$vendorChecklistItemStatusEnum_PENDING_VERIFICATION;
    case 'APPROVED':
      return _$vendorChecklistItemStatusEnum_APPROVED;
    case 'COMPLETED':
      return _$vendorChecklistItemStatusEnum_COMPLETED;
    case 'CHANGES_REQUIRED':
      return _$vendorChecklistItemStatusEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$vendorChecklistItemStatusEnum_REJECTED;
    case 'EXPIRED':
      return _$vendorChecklistItemStatusEnum_EXPIRED;
    case 'NOT_APPLICABLE':
      return _$vendorChecklistItemStatusEnum_NOT_APPLICABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorChecklistItemStatusEnum>
    _$vendorChecklistItemStatusEnumValues = BuiltSet<
        VendorChecklistItemStatusEnum>(const <VendorChecklistItemStatusEnum>[
  _$vendorChecklistItemStatusEnum_NOT_STARTED,
  _$vendorChecklistItemStatusEnum_IN_PROGRESS,
  _$vendorChecklistItemStatusEnum_SUBMITTED,
  _$vendorChecklistItemStatusEnum_PENDING_VERIFICATION,
  _$vendorChecklistItemStatusEnum_APPROVED,
  _$vendorChecklistItemStatusEnum_COMPLETED,
  _$vendorChecklistItemStatusEnum_CHANGES_REQUIRED,
  _$vendorChecklistItemStatusEnum_REJECTED,
  _$vendorChecklistItemStatusEnum_EXPIRED,
  _$vendorChecklistItemStatusEnum_NOT_APPLICABLE,
]);

Serializer<VendorChecklistItemSectionEnum>
    _$vendorChecklistItemSectionEnumSerializer =
    _$VendorChecklistItemSectionEnumSerializer();
Serializer<VendorChecklistItemRequirementLevelEnum>
    _$vendorChecklistItemRequirementLevelEnumSerializer =
    _$VendorChecklistItemRequirementLevelEnumSerializer();
Serializer<VendorChecklistItemStatusEnum>
    _$vendorChecklistItemStatusEnumSerializer =
    _$VendorChecklistItemStatusEnumSerializer();

class _$VendorChecklistItemSectionEnumSerializer
    implements PrimitiveSerializer<VendorChecklistItemSectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorChecklistItemSectionEnum];
  @override
  final String wireName = 'VendorChecklistItemSectionEnum';

  @override
  Object serialize(
          Serializers serializers, VendorChecklistItemSectionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorChecklistItemSectionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorChecklistItemSectionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorChecklistItemRequirementLevelEnumSerializer
    implements PrimitiveSerializer<VendorChecklistItemRequirementLevelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUIRED': 'REQUIRED',
    'OPTIONAL': 'OPTIONAL',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUIRED': 'REQUIRED',
    'OPTIONAL': 'OPTIONAL',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorChecklistItemRequirementLevelEnum
  ];
  @override
  final String wireName = 'VendorChecklistItemRequirementLevelEnum';

  @override
  Object serialize(Serializers serializers,
          VendorChecklistItemRequirementLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorChecklistItemRequirementLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorChecklistItemRequirementLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorChecklistItemStatusEnumSerializer
    implements PrimitiveSerializer<VendorChecklistItemStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'COMPLETED': 'COMPLETED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'COMPLETED': 'COMPLETED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorChecklistItemStatusEnum];
  @override
  final String wireName = 'VendorChecklistItemStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorChecklistItemStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorChecklistItemStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorChecklistItemStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorChecklistItem extends VendorChecklistItem {
  @override
  final String id;
  @override
  final VendorChecklistItemSectionEnum section;
  @override
  final String label;
  @override
  final VendorChecklistItemRequirementLevelEnum requirementLevel;
  @override
  final VendorChecklistItemStatusEnum status;
  @override
  final bool blocking;
  @override
  final String? reason;
  @override
  final String nextAction;
  @override
  final String? versionId;
  @override
  final String updatedAt;
  @override
  final bool recentAuthenticationRequired;

  factory _$VendorChecklistItem(
          [void Function(VendorChecklistItemBuilder)? updates]) =>
      (VendorChecklistItemBuilder()..update(updates))._build();

  _$VendorChecklistItem._(
      {required this.id,
      required this.section,
      required this.label,
      required this.requirementLevel,
      required this.status,
      required this.blocking,
      this.reason,
      required this.nextAction,
      this.versionId,
      required this.updatedAt,
      required this.recentAuthenticationRequired})
      : super._();
  @override
  VendorChecklistItem rebuild(
          void Function(VendorChecklistItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorChecklistItemBuilder toBuilder() =>
      VendorChecklistItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorChecklistItem &&
        id == other.id &&
        section == other.section &&
        label == other.label &&
        requirementLevel == other.requirementLevel &&
        status == other.status &&
        blocking == other.blocking &&
        reason == other.reason &&
        nextAction == other.nextAction &&
        versionId == other.versionId &&
        updatedAt == other.updatedAt &&
        recentAuthenticationRequired == other.recentAuthenticationRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, requirementLevel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, blocking.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, nextAction.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, recentAuthenticationRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorChecklistItem')
          ..add('id', id)
          ..add('section', section)
          ..add('label', label)
          ..add('requirementLevel', requirementLevel)
          ..add('status', status)
          ..add('blocking', blocking)
          ..add('reason', reason)
          ..add('nextAction', nextAction)
          ..add('versionId', versionId)
          ..add('updatedAt', updatedAt)
          ..add('recentAuthenticationRequired', recentAuthenticationRequired))
        .toString();
  }
}

class VendorChecklistItemBuilder
    implements Builder<VendorChecklistItem, VendorChecklistItemBuilder> {
  _$VendorChecklistItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  VendorChecklistItemSectionEnum? _section;
  VendorChecklistItemSectionEnum? get section => _$this._section;
  set section(VendorChecklistItemSectionEnum? section) =>
      _$this._section = section;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  VendorChecklistItemRequirementLevelEnum? _requirementLevel;
  VendorChecklistItemRequirementLevelEnum? get requirementLevel =>
      _$this._requirementLevel;
  set requirementLevel(
          VendorChecklistItemRequirementLevelEnum? requirementLevel) =>
      _$this._requirementLevel = requirementLevel;

  VendorChecklistItemStatusEnum? _status;
  VendorChecklistItemStatusEnum? get status => _$this._status;
  set status(VendorChecklistItemStatusEnum? status) => _$this._status = status;

  bool? _blocking;
  bool? get blocking => _$this._blocking;
  set blocking(bool? blocking) => _$this._blocking = blocking;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _nextAction;
  String? get nextAction => _$this._nextAction;
  set nextAction(String? nextAction) => _$this._nextAction = nextAction;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _recentAuthenticationRequired;
  bool? get recentAuthenticationRequired =>
      _$this._recentAuthenticationRequired;
  set recentAuthenticationRequired(bool? recentAuthenticationRequired) =>
      _$this._recentAuthenticationRequired = recentAuthenticationRequired;

  VendorChecklistItemBuilder() {
    VendorChecklistItem._defaults(this);
  }

  VendorChecklistItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _section = $v.section;
      _label = $v.label;
      _requirementLevel = $v.requirementLevel;
      _status = $v.status;
      _blocking = $v.blocking;
      _reason = $v.reason;
      _nextAction = $v.nextAction;
      _versionId = $v.versionId;
      _updatedAt = $v.updatedAt;
      _recentAuthenticationRequired = $v.recentAuthenticationRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorChecklistItem other) {
    _$v = other as _$VendorChecklistItem;
  }

  @override
  void update(void Function(VendorChecklistItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorChecklistItem build() => _build();

  _$VendorChecklistItem _build() {
    final _$result = _$v ??
        _$VendorChecklistItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorChecklistItem', 'id'),
          section: BuiltValueNullFieldError.checkNotNull(
              section, r'VendorChecklistItem', 'section'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'VendorChecklistItem', 'label'),
          requirementLevel: BuiltValueNullFieldError.checkNotNull(
              requirementLevel, r'VendorChecklistItem', 'requirementLevel'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorChecklistItem', 'status'),
          blocking: BuiltValueNullFieldError.checkNotNull(
              blocking, r'VendorChecklistItem', 'blocking'),
          reason: reason,
          nextAction: BuiltValueNullFieldError.checkNotNull(
              nextAction, r'VendorChecklistItem', 'nextAction'),
          versionId: versionId,
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'VendorChecklistItem', 'updatedAt'),
          recentAuthenticationRequired: BuiltValueNullFieldError.checkNotNull(
              recentAuthenticationRequired,
              r'VendorChecklistItem',
              'recentAuthenticationRequired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
