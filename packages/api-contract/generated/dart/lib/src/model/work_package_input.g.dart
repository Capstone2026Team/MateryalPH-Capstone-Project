// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number5 =
    const WorkPackageInputRadiusKmEnum._('number5');
const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number10 =
    const WorkPackageInputRadiusKmEnum._('number10');
const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number20 =
    const WorkPackageInputRadiusKmEnum._('number20');
const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number30 =
    const WorkPackageInputRadiusKmEnum._('number30');
const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number40 =
    const WorkPackageInputRadiusKmEnum._('number40');
const WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnum_number50 =
    const WorkPackageInputRadiusKmEnum._('number50');

WorkPackageInputRadiusKmEnum _$workPackageInputRadiusKmEnumValueOf(
    String name) {
  switch (name) {
    case 'number5':
      return _$workPackageInputRadiusKmEnum_number5;
    case 'number10':
      return _$workPackageInputRadiusKmEnum_number10;
    case 'number20':
      return _$workPackageInputRadiusKmEnum_number20;
    case 'number30':
      return _$workPackageInputRadiusKmEnum_number30;
    case 'number40':
      return _$workPackageInputRadiusKmEnum_number40;
    case 'number50':
      return _$workPackageInputRadiusKmEnum_number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageInputRadiusKmEnum>
    _$workPackageInputRadiusKmEnumValues =
    BuiltSet<WorkPackageInputRadiusKmEnum>(const <WorkPackageInputRadiusKmEnum>[
  _$workPackageInputRadiusKmEnum_number5,
  _$workPackageInputRadiusKmEnum_number10,
  _$workPackageInputRadiusKmEnum_number20,
  _$workPackageInputRadiusKmEnum_number30,
  _$workPackageInputRadiusKmEnum_number40,
  _$workPackageInputRadiusKmEnum_number50,
]);

const WorkPackageInputFulfillmentMethodEnum
    _$workPackageInputFulfillmentMethodEnum_PICKUP =
    const WorkPackageInputFulfillmentMethodEnum._('PICKUP');
const WorkPackageInputFulfillmentMethodEnum
    _$workPackageInputFulfillmentMethodEnum_DELIVERY =
    const WorkPackageInputFulfillmentMethodEnum._('DELIVERY');

WorkPackageInputFulfillmentMethodEnum
    _$workPackageInputFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$workPackageInputFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$workPackageInputFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageInputFulfillmentMethodEnum>
    _$workPackageInputFulfillmentMethodEnumValues = BuiltSet<
        WorkPackageInputFulfillmentMethodEnum>(const <WorkPackageInputFulfillmentMethodEnum>[
  _$workPackageInputFulfillmentMethodEnum_PICKUP,
  _$workPackageInputFulfillmentMethodEnum_DELIVERY,
]);

const WorkPackageInputPaymentMethodEnum
    _$workPackageInputPaymentMethodEnum_ONLINE =
    const WorkPackageInputPaymentMethodEnum._('ONLINE');

WorkPackageInputPaymentMethodEnum _$workPackageInputPaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$workPackageInputPaymentMethodEnum_ONLINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageInputPaymentMethodEnum>
    _$workPackageInputPaymentMethodEnumValues = BuiltSet<
        WorkPackageInputPaymentMethodEnum>(const <WorkPackageInputPaymentMethodEnum>[
  _$workPackageInputPaymentMethodEnum_ONLINE,
]);

const WorkPackageInputHeavyVehicleRestrictionEnum
    _$workPackageInputHeavyVehicleRestrictionEnum_YES =
    const WorkPackageInputHeavyVehicleRestrictionEnum._('YES');
const WorkPackageInputHeavyVehicleRestrictionEnum
    _$workPackageInputHeavyVehicleRestrictionEnum_NO =
    const WorkPackageInputHeavyVehicleRestrictionEnum._('NO');

WorkPackageInputHeavyVehicleRestrictionEnum
    _$workPackageInputHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'YES':
      return _$workPackageInputHeavyVehicleRestrictionEnum_YES;
    case 'NO':
      return _$workPackageInputHeavyVehicleRestrictionEnum_NO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageInputHeavyVehicleRestrictionEnum>
    _$workPackageInputHeavyVehicleRestrictionEnumValues = BuiltSet<
        WorkPackageInputHeavyVehicleRestrictionEnum>(const <WorkPackageInputHeavyVehicleRestrictionEnum>[
  _$workPackageInputHeavyVehicleRestrictionEnum_YES,
  _$workPackageInputHeavyVehicleRestrictionEnum_NO,
]);

Serializer<WorkPackageInputRadiusKmEnum>
    _$workPackageInputRadiusKmEnumSerializer =
    _$WorkPackageInputRadiusKmEnumSerializer();
Serializer<WorkPackageInputFulfillmentMethodEnum>
    _$workPackageInputFulfillmentMethodEnumSerializer =
    _$WorkPackageInputFulfillmentMethodEnumSerializer();
Serializer<WorkPackageInputPaymentMethodEnum>
    _$workPackageInputPaymentMethodEnumSerializer =
    _$WorkPackageInputPaymentMethodEnumSerializer();
Serializer<WorkPackageInputHeavyVehicleRestrictionEnum>
    _$workPackageInputHeavyVehicleRestrictionEnumSerializer =
    _$WorkPackageInputHeavyVehicleRestrictionEnumSerializer();

class _$WorkPackageInputRadiusKmEnumSerializer
    implements PrimitiveSerializer<WorkPackageInputRadiusKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number5': 5,
    'number10': 10,
    'number20': 20,
    'number30': 30,
    'number40': 40,
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    5: 'number5',
    10: 'number10',
    20: 'number20',
    30: 'number30',
    40: 'number40',
    50: 'number50',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkPackageInputRadiusKmEnum];
  @override
  final String wireName = 'WorkPackageInputRadiusKmEnum';

  @override
  Object serialize(Serializers serializers, WorkPackageInputRadiusKmEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageInputRadiusKmEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageInputRadiusKmEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageInputFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<WorkPackageInputFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageInputFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'WorkPackageInputFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageInputFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageInputFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageInputFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageInputPaymentMethodEnumSerializer
    implements PrimitiveSerializer<WorkPackageInputPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkPackageInputPaymentMethodEnum];
  @override
  final String wireName = 'WorkPackageInputPaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageInputPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageInputPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageInputPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageInputHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageInputHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'YES': 'YES',
    'NO': 'NO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'YES': 'YES',
    'NO': 'NO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageInputHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'WorkPackageInputHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageInputHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageInputHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageInputHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageInput extends WorkPackageInput {
  @override
  final int? lockVersion;
  @override
  final String name;
  @override
  final String? description;
  @override
  final int budgetCentavos;
  @override
  final String siteId;
  @override
  final WorkPackageInputRadiusKmEnum radiusKm;
  @override
  final WorkPackageInputFulfillmentMethodEnum fulfillmentMethod;
  @override
  final WorkPackageInputPaymentMethodEnum paymentMethod;
  @override
  final String? siteContact;
  @override
  final WorkPackageInputHeavyVehicleRestrictionEnum? heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String? accessInstructions;
  @override
  final BuiltList<WorkPackageLineInput> lines;

  factory _$WorkPackageInput(
          [void Function(WorkPackageInputBuilder)? updates]) =>
      (WorkPackageInputBuilder()..update(updates))._build();

  _$WorkPackageInput._(
      {this.lockVersion,
      required this.name,
      this.description,
      required this.budgetCentavos,
      required this.siteId,
      required this.radiusKm,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      this.siteContact,
      this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      this.accessInstructions,
      required this.lines})
      : super._();
  @override
  WorkPackageInput rebuild(void Function(WorkPackageInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageInputBuilder toBuilder() =>
      WorkPackageInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageInput &&
        lockVersion == other.lockVersion &&
        name == other.name &&
        description == other.description &&
        budgetCentavos == other.budgetCentavos &&
        siteId == other.siteId &&
        radiusKm == other.radiusKm &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        siteContact == other.siteContact &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        accessInstructions == other.accessInstructions &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, siteId.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, siteContact.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageInput')
          ..add('lockVersion', lockVersion)
          ..add('name', name)
          ..add('description', description)
          ..add('budgetCentavos', budgetCentavos)
          ..add('siteId', siteId)
          ..add('radiusKm', radiusKm)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('siteContact', siteContact)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('accessInstructions', accessInstructions)
          ..add('lines', lines))
        .toString();
  }
}

class WorkPackageInputBuilder
    implements Builder<WorkPackageInput, WorkPackageInputBuilder> {
  _$WorkPackageInput? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  String? _siteId;
  String? get siteId => _$this._siteId;
  set siteId(String? siteId) => _$this._siteId = siteId;

  WorkPackageInputRadiusKmEnum? _radiusKm;
  WorkPackageInputRadiusKmEnum? get radiusKm => _$this._radiusKm;
  set radiusKm(WorkPackageInputRadiusKmEnum? radiusKm) =>
      _$this._radiusKm = radiusKm;

  WorkPackageInputFulfillmentMethodEnum? _fulfillmentMethod;
  WorkPackageInputFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          WorkPackageInputFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  WorkPackageInputPaymentMethodEnum? _paymentMethod;
  WorkPackageInputPaymentMethodEnum? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(WorkPackageInputPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _siteContact;
  String? get siteContact => _$this._siteContact;
  set siteContact(String? siteContact) => _$this._siteContact = siteContact;

  WorkPackageInputHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  WorkPackageInputHeavyVehicleRestrictionEnum? get heavyVehicleRestriction =>
      _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          WorkPackageInputHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _alternateDropOffLocationId;
  String? get alternateDropOffLocationId => _$this._alternateDropOffLocationId;
  set alternateDropOffLocationId(String? alternateDropOffLocationId) =>
      _$this._alternateDropOffLocationId = alternateDropOffLocationId;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  ListBuilder<WorkPackageLineInput>? _lines;
  ListBuilder<WorkPackageLineInput> get lines =>
      _$this._lines ??= ListBuilder<WorkPackageLineInput>();
  set lines(ListBuilder<WorkPackageLineInput>? lines) => _$this._lines = lines;

  WorkPackageInputBuilder() {
    WorkPackageInput._defaults(this);
  }

  WorkPackageInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _name = $v.name;
      _description = $v.description;
      _budgetCentavos = $v.budgetCentavos;
      _siteId = $v.siteId;
      _radiusKm = $v.radiusKm;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _siteContact = $v.siteContact;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _accessInstructions = $v.accessInstructions;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageInput other) {
    _$v = other as _$WorkPackageInput;
  }

  @override
  void update(void Function(WorkPackageInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageInput build() => _build();

  _$WorkPackageInput _build() {
    _$WorkPackageInput _$result;
    try {
      _$result = _$v ??
          _$WorkPackageInput._(
            lockVersion: lockVersion,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'WorkPackageInput', 'name'),
            description: description,
            budgetCentavos: BuiltValueNullFieldError.checkNotNull(
                budgetCentavos, r'WorkPackageInput', 'budgetCentavos'),
            siteId: BuiltValueNullFieldError.checkNotNull(
                siteId, r'WorkPackageInput', 'siteId'),
            radiusKm: BuiltValueNullFieldError.checkNotNull(
                radiusKm, r'WorkPackageInput', 'radiusKm'),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'WorkPackageInput', 'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'WorkPackageInput', 'paymentMethod'),
            siteContact: siteContact,
            heavyVehicleRestriction: heavyVehicleRestriction,
            alternateDropOffLocationId: alternateDropOffLocationId,
            accessInstructions: accessInstructions,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
