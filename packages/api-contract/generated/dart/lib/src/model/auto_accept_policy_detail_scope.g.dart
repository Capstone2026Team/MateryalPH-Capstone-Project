// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_detail_scope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutoAcceptPolicyDetailScopeItemBasedOnlyEnum
    _$autoAcceptPolicyDetailScopeItemBasedOnlyEnum_true_ =
    const AutoAcceptPolicyDetailScopeItemBasedOnlyEnum._('true_');

AutoAcceptPolicyDetailScopeItemBasedOnlyEnum
    _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$autoAcceptPolicyDetailScopeItemBasedOnlyEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptPolicyDetailScopeItemBasedOnlyEnum>
    _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumValues = BuiltSet<
        AutoAcceptPolicyDetailScopeItemBasedOnlyEnum>(const <AutoAcceptPolicyDetailScopeItemBasedOnlyEnum>[
  _$autoAcceptPolicyDetailScopeItemBasedOnlyEnum_true_,
]);

const AutoAcceptPolicyDetailScopeNrpcExcludedEnum
    _$autoAcceptPolicyDetailScopeNrpcExcludedEnum_true_ =
    const AutoAcceptPolicyDetailScopeNrpcExcludedEnum._('true_');

AutoAcceptPolicyDetailScopeNrpcExcludedEnum
    _$autoAcceptPolicyDetailScopeNrpcExcludedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$autoAcceptPolicyDetailScopeNrpcExcludedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptPolicyDetailScopeNrpcExcludedEnum>
    _$autoAcceptPolicyDetailScopeNrpcExcludedEnumValues = BuiltSet<
        AutoAcceptPolicyDetailScopeNrpcExcludedEnum>(const <AutoAcceptPolicyDetailScopeNrpcExcludedEnum>[
  _$autoAcceptPolicyDetailScopeNrpcExcludedEnum_true_,
]);

const AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum
    _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnum_true_ =
    const AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum._('true_');

AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum
    _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum>
    _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumValues = BuiltSet<
        AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum>(const <AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum>[
  _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnum_true_,
]);

Serializer<AutoAcceptPolicyDetailScopeItemBasedOnlyEnum>
    _$autoAcceptPolicyDetailScopeItemBasedOnlyEnumSerializer =
    _$AutoAcceptPolicyDetailScopeItemBasedOnlyEnumSerializer();
Serializer<AutoAcceptPolicyDetailScopeNrpcExcludedEnum>
    _$autoAcceptPolicyDetailScopeNrpcExcludedEnumSerializer =
    _$AutoAcceptPolicyDetailScopeNrpcExcludedEnumSerializer();
Serializer<AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum>
    _$autoAcceptPolicyDetailScopeProjectBasedExcludedEnumSerializer =
    _$AutoAcceptPolicyDetailScopeProjectBasedExcludedEnumSerializer();

class _$AutoAcceptPolicyDetailScopeItemBasedOnlyEnumSerializer
    implements
        PrimitiveSerializer<AutoAcceptPolicyDetailScopeItemBasedOnlyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AutoAcceptPolicyDetailScopeItemBasedOnlyEnum
  ];
  @override
  final String wireName = 'AutoAcceptPolicyDetailScopeItemBasedOnlyEnum';

  @override
  Object serialize(Serializers serializers,
          AutoAcceptPolicyDetailScopeItemBasedOnlyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptPolicyDetailScopeItemBasedOnlyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptPolicyDetailScopeItemBasedOnlyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptPolicyDetailScopeNrpcExcludedEnumSerializer
    implements
        PrimitiveSerializer<AutoAcceptPolicyDetailScopeNrpcExcludedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AutoAcceptPolicyDetailScopeNrpcExcludedEnum
  ];
  @override
  final String wireName = 'AutoAcceptPolicyDetailScopeNrpcExcludedEnum';

  @override
  Object serialize(Serializers serializers,
          AutoAcceptPolicyDetailScopeNrpcExcludedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptPolicyDetailScopeNrpcExcludedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptPolicyDetailScopeNrpcExcludedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptPolicyDetailScopeProjectBasedExcludedEnumSerializer
    implements
        PrimitiveSerializer<
            AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum
  ];
  @override
  final String wireName = 'AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum';

  @override
  Object serialize(Serializers serializers,
          AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptPolicyDetailScope extends AutoAcceptPolicyDetailScope {
  @override
  final AutoAcceptPolicyDetailScopeItemBasedOnlyEnum itemBasedOnly;
  @override
  final AutoAcceptPolicyDetailScopeNrpcExcludedEnum nrpcExcluded;
  @override
  final AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum
      projectBasedExcluded;
  @override
  final String ruleVersion;

  factory _$AutoAcceptPolicyDetailScope(
          [void Function(AutoAcceptPolicyDetailScopeBuilder)? updates]) =>
      (AutoAcceptPolicyDetailScopeBuilder()..update(updates))._build();

  _$AutoAcceptPolicyDetailScope._(
      {required this.itemBasedOnly,
      required this.nrpcExcluded,
      required this.projectBasedExcluded,
      required this.ruleVersion})
      : super._();
  @override
  AutoAcceptPolicyDetailScope rebuild(
          void Function(AutoAcceptPolicyDetailScopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyDetailScopeBuilder toBuilder() =>
      AutoAcceptPolicyDetailScopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyDetailScope &&
        itemBasedOnly == other.itemBasedOnly &&
        nrpcExcluded == other.nrpcExcluded &&
        projectBasedExcluded == other.projectBasedExcluded &&
        ruleVersion == other.ruleVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemBasedOnly.hashCode);
    _$hash = $jc(_$hash, nrpcExcluded.hashCode);
    _$hash = $jc(_$hash, projectBasedExcluded.hashCode);
    _$hash = $jc(_$hash, ruleVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyDetailScope')
          ..add('itemBasedOnly', itemBasedOnly)
          ..add('nrpcExcluded', nrpcExcluded)
          ..add('projectBasedExcluded', projectBasedExcluded)
          ..add('ruleVersion', ruleVersion))
        .toString();
  }
}

class AutoAcceptPolicyDetailScopeBuilder
    implements
        Builder<AutoAcceptPolicyDetailScope,
            AutoAcceptPolicyDetailScopeBuilder> {
  _$AutoAcceptPolicyDetailScope? _$v;

  AutoAcceptPolicyDetailScopeItemBasedOnlyEnum? _itemBasedOnly;
  AutoAcceptPolicyDetailScopeItemBasedOnlyEnum? get itemBasedOnly =>
      _$this._itemBasedOnly;
  set itemBasedOnly(
          AutoAcceptPolicyDetailScopeItemBasedOnlyEnum? itemBasedOnly) =>
      _$this._itemBasedOnly = itemBasedOnly;

  AutoAcceptPolicyDetailScopeNrpcExcludedEnum? _nrpcExcluded;
  AutoAcceptPolicyDetailScopeNrpcExcludedEnum? get nrpcExcluded =>
      _$this._nrpcExcluded;
  set nrpcExcluded(AutoAcceptPolicyDetailScopeNrpcExcludedEnum? nrpcExcluded) =>
      _$this._nrpcExcluded = nrpcExcluded;

  AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum? _projectBasedExcluded;
  AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum?
      get projectBasedExcluded => _$this._projectBasedExcluded;
  set projectBasedExcluded(
          AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum?
              projectBasedExcluded) =>
      _$this._projectBasedExcluded = projectBasedExcluded;

  String? _ruleVersion;
  String? get ruleVersion => _$this._ruleVersion;
  set ruleVersion(String? ruleVersion) => _$this._ruleVersion = ruleVersion;

  AutoAcceptPolicyDetailScopeBuilder() {
    AutoAcceptPolicyDetailScope._defaults(this);
  }

  AutoAcceptPolicyDetailScopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemBasedOnly = $v.itemBasedOnly;
      _nrpcExcluded = $v.nrpcExcluded;
      _projectBasedExcluded = $v.projectBasedExcluded;
      _ruleVersion = $v.ruleVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyDetailScope other) {
    _$v = other as _$AutoAcceptPolicyDetailScope;
  }

  @override
  void update(void Function(AutoAcceptPolicyDetailScopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyDetailScope build() => _build();

  _$AutoAcceptPolicyDetailScope _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicyDetailScope._(
          itemBasedOnly: BuiltValueNullFieldError.checkNotNull(
              itemBasedOnly, r'AutoAcceptPolicyDetailScope', 'itemBasedOnly'),
          nrpcExcluded: BuiltValueNullFieldError.checkNotNull(
              nrpcExcluded, r'AutoAcceptPolicyDetailScope', 'nrpcExcluded'),
          projectBasedExcluded: BuiltValueNullFieldError.checkNotNull(
              projectBasedExcluded,
              r'AutoAcceptPolicyDetailScope',
              'projectBasedExcluded'),
          ruleVersion: BuiltValueNullFieldError.checkNotNull(
              ruleVersion, r'AutoAcceptPolicyDetailScope', 'ruleVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
