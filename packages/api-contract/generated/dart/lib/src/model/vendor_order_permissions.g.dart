// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOrderPermissions extends VendorOrderPermissions {
  @override
  final bool canConfirm;
  @override
  final bool canRevise;
  @override
  final bool canSetNrpc;
  @override
  final bool canConfirmDelivery;
  @override
  final bool canDecline;
  @override
  final bool canViewInventory;
  @override
  final bool? canRecordPhysicalPayment;
  @override
  final bool? canApproveOnlineBalance;
  @override
  final bool? canRecordMilestone;
  @override
  final bool? canAssignFulfillment;
  @override
  final bool? canCancel;
  @override
  final bool? canFinalizeCancellation;
  @override
  final bool? canReportVehicleIssue;
  @override
  final bool? canRetryRefund;
  @override
  final bool? canRespondProblem;

  factory _$VendorOrderPermissions(
          [void Function(VendorOrderPermissionsBuilder)? updates]) =>
      (VendorOrderPermissionsBuilder()..update(updates))._build();

  _$VendorOrderPermissions._(
      {required this.canConfirm,
      required this.canRevise,
      required this.canSetNrpc,
      required this.canConfirmDelivery,
      required this.canDecline,
      required this.canViewInventory,
      this.canRecordPhysicalPayment,
      this.canApproveOnlineBalance,
      this.canRecordMilestone,
      this.canAssignFulfillment,
      this.canCancel,
      this.canFinalizeCancellation,
      this.canReportVehicleIssue,
      this.canRetryRefund,
      this.canRespondProblem})
      : super._();
  @override
  VendorOrderPermissions rebuild(
          void Function(VendorOrderPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderPermissionsBuilder toBuilder() =>
      VendorOrderPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderPermissions &&
        canConfirm == other.canConfirm &&
        canRevise == other.canRevise &&
        canSetNrpc == other.canSetNrpc &&
        canConfirmDelivery == other.canConfirmDelivery &&
        canDecline == other.canDecline &&
        canViewInventory == other.canViewInventory &&
        canRecordPhysicalPayment == other.canRecordPhysicalPayment &&
        canApproveOnlineBalance == other.canApproveOnlineBalance &&
        canRecordMilestone == other.canRecordMilestone &&
        canAssignFulfillment == other.canAssignFulfillment &&
        canCancel == other.canCancel &&
        canFinalizeCancellation == other.canFinalizeCancellation &&
        canReportVehicleIssue == other.canReportVehicleIssue &&
        canRetryRefund == other.canRetryRefund &&
        canRespondProblem == other.canRespondProblem;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canConfirm.hashCode);
    _$hash = $jc(_$hash, canRevise.hashCode);
    _$hash = $jc(_$hash, canSetNrpc.hashCode);
    _$hash = $jc(_$hash, canConfirmDelivery.hashCode);
    _$hash = $jc(_$hash, canDecline.hashCode);
    _$hash = $jc(_$hash, canViewInventory.hashCode);
    _$hash = $jc(_$hash, canRecordPhysicalPayment.hashCode);
    _$hash = $jc(_$hash, canApproveOnlineBalance.hashCode);
    _$hash = $jc(_$hash, canRecordMilestone.hashCode);
    _$hash = $jc(_$hash, canAssignFulfillment.hashCode);
    _$hash = $jc(_$hash, canCancel.hashCode);
    _$hash = $jc(_$hash, canFinalizeCancellation.hashCode);
    _$hash = $jc(_$hash, canReportVehicleIssue.hashCode);
    _$hash = $jc(_$hash, canRetryRefund.hashCode);
    _$hash = $jc(_$hash, canRespondProblem.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderPermissions')
          ..add('canConfirm', canConfirm)
          ..add('canRevise', canRevise)
          ..add('canSetNrpc', canSetNrpc)
          ..add('canConfirmDelivery', canConfirmDelivery)
          ..add('canDecline', canDecline)
          ..add('canViewInventory', canViewInventory)
          ..add('canRecordPhysicalPayment', canRecordPhysicalPayment)
          ..add('canApproveOnlineBalance', canApproveOnlineBalance)
          ..add('canRecordMilestone', canRecordMilestone)
          ..add('canAssignFulfillment', canAssignFulfillment)
          ..add('canCancel', canCancel)
          ..add('canFinalizeCancellation', canFinalizeCancellation)
          ..add('canReportVehicleIssue', canReportVehicleIssue)
          ..add('canRetryRefund', canRetryRefund)
          ..add('canRespondProblem', canRespondProblem))
        .toString();
  }
}

class VendorOrderPermissionsBuilder
    implements Builder<VendorOrderPermissions, VendorOrderPermissionsBuilder> {
  _$VendorOrderPermissions? _$v;

  bool? _canConfirm;
  bool? get canConfirm => _$this._canConfirm;
  set canConfirm(bool? canConfirm) => _$this._canConfirm = canConfirm;

  bool? _canRevise;
  bool? get canRevise => _$this._canRevise;
  set canRevise(bool? canRevise) => _$this._canRevise = canRevise;

  bool? _canSetNrpc;
  bool? get canSetNrpc => _$this._canSetNrpc;
  set canSetNrpc(bool? canSetNrpc) => _$this._canSetNrpc = canSetNrpc;

  bool? _canConfirmDelivery;
  bool? get canConfirmDelivery => _$this._canConfirmDelivery;
  set canConfirmDelivery(bool? canConfirmDelivery) =>
      _$this._canConfirmDelivery = canConfirmDelivery;

  bool? _canDecline;
  bool? get canDecline => _$this._canDecline;
  set canDecline(bool? canDecline) => _$this._canDecline = canDecline;

  bool? _canViewInventory;
  bool? get canViewInventory => _$this._canViewInventory;
  set canViewInventory(bool? canViewInventory) =>
      _$this._canViewInventory = canViewInventory;

  bool? _canRecordPhysicalPayment;
  bool? get canRecordPhysicalPayment => _$this._canRecordPhysicalPayment;
  set canRecordPhysicalPayment(bool? canRecordPhysicalPayment) =>
      _$this._canRecordPhysicalPayment = canRecordPhysicalPayment;

  bool? _canApproveOnlineBalance;
  bool? get canApproveOnlineBalance => _$this._canApproveOnlineBalance;
  set canApproveOnlineBalance(bool? canApproveOnlineBalance) =>
      _$this._canApproveOnlineBalance = canApproveOnlineBalance;

  bool? _canRecordMilestone;
  bool? get canRecordMilestone => _$this._canRecordMilestone;
  set canRecordMilestone(bool? canRecordMilestone) =>
      _$this._canRecordMilestone = canRecordMilestone;

  bool? _canAssignFulfillment;
  bool? get canAssignFulfillment => _$this._canAssignFulfillment;
  set canAssignFulfillment(bool? canAssignFulfillment) =>
      _$this._canAssignFulfillment = canAssignFulfillment;

  bool? _canCancel;
  bool? get canCancel => _$this._canCancel;
  set canCancel(bool? canCancel) => _$this._canCancel = canCancel;

  bool? _canFinalizeCancellation;
  bool? get canFinalizeCancellation => _$this._canFinalizeCancellation;
  set canFinalizeCancellation(bool? canFinalizeCancellation) =>
      _$this._canFinalizeCancellation = canFinalizeCancellation;

  bool? _canReportVehicleIssue;
  bool? get canReportVehicleIssue => _$this._canReportVehicleIssue;
  set canReportVehicleIssue(bool? canReportVehicleIssue) =>
      _$this._canReportVehicleIssue = canReportVehicleIssue;

  bool? _canRetryRefund;
  bool? get canRetryRefund => _$this._canRetryRefund;
  set canRetryRefund(bool? canRetryRefund) =>
      _$this._canRetryRefund = canRetryRefund;

  bool? _canRespondProblem;
  bool? get canRespondProblem => _$this._canRespondProblem;
  set canRespondProblem(bool? canRespondProblem) =>
      _$this._canRespondProblem = canRespondProblem;

  VendorOrderPermissionsBuilder() {
    VendorOrderPermissions._defaults(this);
  }

  VendorOrderPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canConfirm = $v.canConfirm;
      _canRevise = $v.canRevise;
      _canSetNrpc = $v.canSetNrpc;
      _canConfirmDelivery = $v.canConfirmDelivery;
      _canDecline = $v.canDecline;
      _canViewInventory = $v.canViewInventory;
      _canRecordPhysicalPayment = $v.canRecordPhysicalPayment;
      _canApproveOnlineBalance = $v.canApproveOnlineBalance;
      _canRecordMilestone = $v.canRecordMilestone;
      _canAssignFulfillment = $v.canAssignFulfillment;
      _canCancel = $v.canCancel;
      _canFinalizeCancellation = $v.canFinalizeCancellation;
      _canReportVehicleIssue = $v.canReportVehicleIssue;
      _canRetryRefund = $v.canRetryRefund;
      _canRespondProblem = $v.canRespondProblem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderPermissions other) {
    _$v = other as _$VendorOrderPermissions;
  }

  @override
  void update(void Function(VendorOrderPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderPermissions build() => _build();

  _$VendorOrderPermissions _build() {
    final _$result = _$v ??
        _$VendorOrderPermissions._(
          canConfirm: BuiltValueNullFieldError.checkNotNull(
              canConfirm, r'VendorOrderPermissions', 'canConfirm'),
          canRevise: BuiltValueNullFieldError.checkNotNull(
              canRevise, r'VendorOrderPermissions', 'canRevise'),
          canSetNrpc: BuiltValueNullFieldError.checkNotNull(
              canSetNrpc, r'VendorOrderPermissions', 'canSetNrpc'),
          canConfirmDelivery: BuiltValueNullFieldError.checkNotNull(
              canConfirmDelivery,
              r'VendorOrderPermissions',
              'canConfirmDelivery'),
          canDecline: BuiltValueNullFieldError.checkNotNull(
              canDecline, r'VendorOrderPermissions', 'canDecline'),
          canViewInventory: BuiltValueNullFieldError.checkNotNull(
              canViewInventory, r'VendorOrderPermissions', 'canViewInventory'),
          canRecordPhysicalPayment: canRecordPhysicalPayment,
          canApproveOnlineBalance: canApproveOnlineBalance,
          canRecordMilestone: canRecordMilestone,
          canAssignFulfillment: canAssignFulfillment,
          canCancel: canCancel,
          canFinalizeCancellation: canFinalizeCancellation,
          canReportVehicleIssue: canReportVehicleIssue,
          canRetryRefund: canRetryRefund,
          canRespondProblem: canRespondProblem,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
