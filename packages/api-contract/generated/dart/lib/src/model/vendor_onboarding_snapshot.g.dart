// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOnboardingSnapshot extends VendorOnboardingSnapshot {
  @override
  final BuiltMap<String, JsonObject?> organization;
  @override
  final BuiltMap<String, VendorOnboardingSection> sections;
  @override
  final BuiltMap<String, JsonObject?> verification;
  @override
  final BuiltMap<String, JsonObject?> setup;
  @override
  final BuiltMap<String, JsonObject?> activation;
  @override
  final bool welcomeRequired;
  @override
  final BuiltList<String> permissions;

  factory _$VendorOnboardingSnapshot(
          [void Function(VendorOnboardingSnapshotBuilder)? updates]) =>
      (VendorOnboardingSnapshotBuilder()..update(updates))._build();

  _$VendorOnboardingSnapshot._(
      {required this.organization,
      required this.sections,
      required this.verification,
      required this.setup,
      required this.activation,
      required this.welcomeRequired,
      required this.permissions})
      : super._();
  @override
  VendorOnboardingSnapshot rebuild(
          void Function(VendorOnboardingSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingSnapshotBuilder toBuilder() =>
      VendorOnboardingSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingSnapshot &&
        organization == other.organization &&
        sections == other.sections &&
        verification == other.verification &&
        setup == other.setup &&
        activation == other.activation &&
        welcomeRequired == other.welcomeRequired &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, organization.hashCode);
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jc(_$hash, verification.hashCode);
    _$hash = $jc(_$hash, setup.hashCode);
    _$hash = $jc(_$hash, activation.hashCode);
    _$hash = $jc(_$hash, welcomeRequired.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOnboardingSnapshot')
          ..add('organization', organization)
          ..add('sections', sections)
          ..add('verification', verification)
          ..add('setup', setup)
          ..add('activation', activation)
          ..add('welcomeRequired', welcomeRequired)
          ..add('permissions', permissions))
        .toString();
  }
}

class VendorOnboardingSnapshotBuilder
    implements
        Builder<VendorOnboardingSnapshot, VendorOnboardingSnapshotBuilder> {
  _$VendorOnboardingSnapshot? _$v;

  MapBuilder<String, JsonObject?>? _organization;
  MapBuilder<String, JsonObject?> get organization =>
      _$this._organization ??= MapBuilder<String, JsonObject?>();
  set organization(MapBuilder<String, JsonObject?>? organization) =>
      _$this._organization = organization;

  MapBuilder<String, VendorOnboardingSection>? _sections;
  MapBuilder<String, VendorOnboardingSection> get sections =>
      _$this._sections ??= MapBuilder<String, VendorOnboardingSection>();
  set sections(MapBuilder<String, VendorOnboardingSection>? sections) =>
      _$this._sections = sections;

  MapBuilder<String, JsonObject?>? _verification;
  MapBuilder<String, JsonObject?> get verification =>
      _$this._verification ??= MapBuilder<String, JsonObject?>();
  set verification(MapBuilder<String, JsonObject?>? verification) =>
      _$this._verification = verification;

  MapBuilder<String, JsonObject?>? _setup;
  MapBuilder<String, JsonObject?> get setup =>
      _$this._setup ??= MapBuilder<String, JsonObject?>();
  set setup(MapBuilder<String, JsonObject?>? setup) => _$this._setup = setup;

  MapBuilder<String, JsonObject?>? _activation;
  MapBuilder<String, JsonObject?> get activation =>
      _$this._activation ??= MapBuilder<String, JsonObject?>();
  set activation(MapBuilder<String, JsonObject?>? activation) =>
      _$this._activation = activation;

  bool? _welcomeRequired;
  bool? get welcomeRequired => _$this._welcomeRequired;
  set welcomeRequired(bool? welcomeRequired) =>
      _$this._welcomeRequired = welcomeRequired;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  VendorOnboardingSnapshotBuilder() {
    VendorOnboardingSnapshot._defaults(this);
  }

  VendorOnboardingSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _organization = $v.organization.toBuilder();
      _sections = $v.sections.toBuilder();
      _verification = $v.verification.toBuilder();
      _setup = $v.setup.toBuilder();
      _activation = $v.activation.toBuilder();
      _welcomeRequired = $v.welcomeRequired;
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOnboardingSnapshot other) {
    _$v = other as _$VendorOnboardingSnapshot;
  }

  @override
  void update(void Function(VendorOnboardingSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingSnapshot build() => _build();

  _$VendorOnboardingSnapshot _build() {
    _$VendorOnboardingSnapshot _$result;
    try {
      _$result = _$v ??
          _$VendorOnboardingSnapshot._(
            organization: organization.build(),
            sections: sections.build(),
            verification: verification.build(),
            setup: setup.build(),
            activation: activation.build(),
            welcomeRequired: BuiltValueNullFieldError.checkNotNull(
                welcomeRequired,
                r'VendorOnboardingSnapshot',
                'welcomeRequired'),
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'organization';
        organization.build();
        _$failedField = 'sections';
        sections.build();
        _$failedField = 'verification';
        verification.build();
        _$failedField = 'setup';
        setup.build();
        _$failedField = 'activation';
        activation.build();

        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOnboardingSnapshot', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
