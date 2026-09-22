// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_draft_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OnboardingDraftVersionWorkstreamEnum
    _$onboardingDraftVersionWorkstreamEnum_STORE_VERIFICATION =
    const OnboardingDraftVersionWorkstreamEnum._('STORE_VERIFICATION');
const OnboardingDraftVersionWorkstreamEnum
    _$onboardingDraftVersionWorkstreamEnum_STORE_SETUP =
    const OnboardingDraftVersionWorkstreamEnum._('STORE_SETUP');

OnboardingDraftVersionWorkstreamEnum
    _$onboardingDraftVersionWorkstreamEnumValueOf(String name) {
  switch (name) {
    case 'STORE_VERIFICATION':
      return _$onboardingDraftVersionWorkstreamEnum_STORE_VERIFICATION;
    case 'STORE_SETUP':
      return _$onboardingDraftVersionWorkstreamEnum_STORE_SETUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OnboardingDraftVersionWorkstreamEnum>
    _$onboardingDraftVersionWorkstreamEnumValues = BuiltSet<
        OnboardingDraftVersionWorkstreamEnum>(const <OnboardingDraftVersionWorkstreamEnum>[
  _$onboardingDraftVersionWorkstreamEnum_STORE_VERIFICATION,
  _$onboardingDraftVersionWorkstreamEnum_STORE_SETUP,
]);

Serializer<OnboardingDraftVersionWorkstreamEnum>
    _$onboardingDraftVersionWorkstreamEnumSerializer =
    _$OnboardingDraftVersionWorkstreamEnumSerializer();

class _$OnboardingDraftVersionWorkstreamEnumSerializer
    implements PrimitiveSerializer<OnboardingDraftVersionWorkstreamEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OnboardingDraftVersionWorkstreamEnum
  ];
  @override
  final String wireName = 'OnboardingDraftVersionWorkstreamEnum';

  @override
  Object serialize(
          Serializers serializers, OnboardingDraftVersionWorkstreamEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OnboardingDraftVersionWorkstreamEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OnboardingDraftVersionWorkstreamEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OnboardingDraftVersion extends OnboardingDraftVersion {
  @override
  final OnboardingDraftVersionWorkstreamEnum workstream;
  @override
  final int lockVersion;

  factory _$OnboardingDraftVersion(
          [void Function(OnboardingDraftVersionBuilder)? updates]) =>
      (OnboardingDraftVersionBuilder()..update(updates))._build();

  _$OnboardingDraftVersion._(
      {required this.workstream, required this.lockVersion})
      : super._();
  @override
  OnboardingDraftVersion rebuild(
          void Function(OnboardingDraftVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OnboardingDraftVersionBuilder toBuilder() =>
      OnboardingDraftVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OnboardingDraftVersion &&
        workstream == other.workstream &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, workstream.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OnboardingDraftVersion')
          ..add('workstream', workstream)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class OnboardingDraftVersionBuilder
    implements Builder<OnboardingDraftVersion, OnboardingDraftVersionBuilder> {
  _$OnboardingDraftVersion? _$v;

  OnboardingDraftVersionWorkstreamEnum? _workstream;
  OnboardingDraftVersionWorkstreamEnum? get workstream => _$this._workstream;
  set workstream(OnboardingDraftVersionWorkstreamEnum? workstream) =>
      _$this._workstream = workstream;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  OnboardingDraftVersionBuilder() {
    OnboardingDraftVersion._defaults(this);
  }

  OnboardingDraftVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workstream = $v.workstream;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OnboardingDraftVersion other) {
    _$v = other as _$OnboardingDraftVersion;
  }

  @override
  void update(void Function(OnboardingDraftVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OnboardingDraftVersion build() => _build();

  _$OnboardingDraftVersion _build() {
    final _$result = _$v ??
        _$OnboardingDraftVersion._(
          workstream: BuiltValueNullFieldError.checkNotNull(
              workstream, r'OnboardingDraftVersion', 'workstream'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'OnboardingDraftVersion', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
