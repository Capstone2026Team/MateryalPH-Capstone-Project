// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnum_DRAFT =
    const WorkPackageSummaryStatusEnum._('DRAFT');
const WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnum_ACTIVE =
    const WorkPackageSummaryStatusEnum._('ACTIVE');
const WorkPackageSummaryStatusEnum
    _$workPackageSummaryStatusEnum_QUOTATION_INQUIRY =
    const WorkPackageSummaryStatusEnum._('QUOTATION_INQUIRY');
const WorkPackageSummaryStatusEnum
    _$workPackageSummaryStatusEnum_VENDOR_SELECTED =
    const WorkPackageSummaryStatusEnum._('VENDOR_SELECTED');
const WorkPackageSummaryStatusEnum
    _$workPackageSummaryStatusEnum_AWAITING_PAYMENT =
    const WorkPackageSummaryStatusEnum._('AWAITING_PAYMENT');
const WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnum_IN_PROGRESS =
    const WorkPackageSummaryStatusEnum._('IN_PROGRESS');
const WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnum_COMPLETED =
    const WorkPackageSummaryStatusEnum._('COMPLETED');
const WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnum_CANCELLED =
    const WorkPackageSummaryStatusEnum._('CANCELLED');

WorkPackageSummaryStatusEnum _$workPackageSummaryStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$workPackageSummaryStatusEnum_DRAFT;
    case 'ACTIVE':
      return _$workPackageSummaryStatusEnum_ACTIVE;
    case 'QUOTATION_INQUIRY':
      return _$workPackageSummaryStatusEnum_QUOTATION_INQUIRY;
    case 'VENDOR_SELECTED':
      return _$workPackageSummaryStatusEnum_VENDOR_SELECTED;
    case 'AWAITING_PAYMENT':
      return _$workPackageSummaryStatusEnum_AWAITING_PAYMENT;
    case 'IN_PROGRESS':
      return _$workPackageSummaryStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$workPackageSummaryStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$workPackageSummaryStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageSummaryStatusEnum>
    _$workPackageSummaryStatusEnumValues =
    BuiltSet<WorkPackageSummaryStatusEnum>(const <WorkPackageSummaryStatusEnum>[
  _$workPackageSummaryStatusEnum_DRAFT,
  _$workPackageSummaryStatusEnum_ACTIVE,
  _$workPackageSummaryStatusEnum_QUOTATION_INQUIRY,
  _$workPackageSummaryStatusEnum_VENDOR_SELECTED,
  _$workPackageSummaryStatusEnum_AWAITING_PAYMENT,
  _$workPackageSummaryStatusEnum_IN_PROGRESS,
  _$workPackageSummaryStatusEnum_COMPLETED,
  _$workPackageSummaryStatusEnum_CANCELLED,
]);

Serializer<WorkPackageSummaryStatusEnum>
    _$workPackageSummaryStatusEnumSerializer =
    _$WorkPackageSummaryStatusEnumSerializer();

class _$WorkPackageSummaryStatusEnumSerializer
    implements PrimitiveSerializer<WorkPackageSummaryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'QUOTATION_INQUIRY': 'QUOTATION_INQUIRY',
    'VENDOR_SELECTED': 'VENDOR_SELECTED',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'QUOTATION_INQUIRY': 'QUOTATION_INQUIRY',
    'VENDOR_SELECTED': 'VENDOR_SELECTED',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkPackageSummaryStatusEnum];
  @override
  final String wireName = 'WorkPackageSummaryStatusEnum';

  @override
  Object serialize(Serializers serializers, WorkPackageSummaryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageSummaryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageSummaryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageSummary extends WorkPackageSummary {
  @override
  final String id;
  @override
  final String projectId;
  @override
  final String name;
  @override
  final WorkPackageSummaryStatusEnum status;
  @override
  final int budgetCentavos;
  @override
  final int lockVersion;
  @override
  final String? currentVersionId;
  @override
  final String? selectedVendorId;
  @override
  final String? orderId;

  factory _$WorkPackageSummary(
          [void Function(WorkPackageSummaryBuilder)? updates]) =>
      (WorkPackageSummaryBuilder()..update(updates))._build();

  _$WorkPackageSummary._(
      {required this.id,
      required this.projectId,
      required this.name,
      required this.status,
      required this.budgetCentavos,
      required this.lockVersion,
      this.currentVersionId,
      this.selectedVendorId,
      this.orderId})
      : super._();
  @override
  WorkPackageSummary rebuild(
          void Function(WorkPackageSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageSummaryBuilder toBuilder() =>
      WorkPackageSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageSummary &&
        id == other.id &&
        projectId == other.projectId &&
        name == other.name &&
        status == other.status &&
        budgetCentavos == other.budgetCentavos &&
        lockVersion == other.lockVersion &&
        currentVersionId == other.currentVersionId &&
        selectedVendorId == other.selectedVendorId &&
        orderId == other.orderId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, projectId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, currentVersionId.hashCode);
    _$hash = $jc(_$hash, selectedVendorId.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageSummary')
          ..add('id', id)
          ..add('projectId', projectId)
          ..add('name', name)
          ..add('status', status)
          ..add('budgetCentavos', budgetCentavos)
          ..add('lockVersion', lockVersion)
          ..add('currentVersionId', currentVersionId)
          ..add('selectedVendorId', selectedVendorId)
          ..add('orderId', orderId))
        .toString();
  }
}

class WorkPackageSummaryBuilder
    implements Builder<WorkPackageSummary, WorkPackageSummaryBuilder> {
  _$WorkPackageSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _projectId;
  String? get projectId => _$this._projectId;
  set projectId(String? projectId) => _$this._projectId = projectId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  WorkPackageSummaryStatusEnum? _status;
  WorkPackageSummaryStatusEnum? get status => _$this._status;
  set status(WorkPackageSummaryStatusEnum? status) => _$this._status = status;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _currentVersionId;
  String? get currentVersionId => _$this._currentVersionId;
  set currentVersionId(String? currentVersionId) =>
      _$this._currentVersionId = currentVersionId;

  String? _selectedVendorId;
  String? get selectedVendorId => _$this._selectedVendorId;
  set selectedVendorId(String? selectedVendorId) =>
      _$this._selectedVendorId = selectedVendorId;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  WorkPackageSummaryBuilder() {
    WorkPackageSummary._defaults(this);
  }

  WorkPackageSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _projectId = $v.projectId;
      _name = $v.name;
      _status = $v.status;
      _budgetCentavos = $v.budgetCentavos;
      _lockVersion = $v.lockVersion;
      _currentVersionId = $v.currentVersionId;
      _selectedVendorId = $v.selectedVendorId;
      _orderId = $v.orderId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageSummary other) {
    _$v = other as _$WorkPackageSummary;
  }

  @override
  void update(void Function(WorkPackageSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageSummary build() => _build();

  _$WorkPackageSummary _build() {
    final _$result = _$v ??
        _$WorkPackageSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'WorkPackageSummary', 'id'),
          projectId: BuiltValueNullFieldError.checkNotNull(
              projectId, r'WorkPackageSummary', 'projectId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'WorkPackageSummary', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'WorkPackageSummary', 'status'),
          budgetCentavos: BuiltValueNullFieldError.checkNotNull(
              budgetCentavos, r'WorkPackageSummary', 'budgetCentavos'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'WorkPackageSummary', 'lockVersion'),
          currentVersionId: currentVersionId,
          selectedVendorId: selectedVendorId,
          orderId: orderId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
