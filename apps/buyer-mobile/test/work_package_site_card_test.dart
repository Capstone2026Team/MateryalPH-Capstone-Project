import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/setting_switch_row.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/work_package_editor.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const _projectId = '01995000-0000-7000-8000-000000000001';
const _siteId = '01995000-0000-7000-8000-000000000002';
const _unit = '01995000-0000-7000-8000-000000000003';
const _material = '01995000-0000-7000-8000-0000000000a1';
const _address =
    '629 J Nepomuceno Street, Quiapo, Manila, Metro Manila, Philippines 1001, near the Quiapo Church plaza';

Map<String, Object?> _profile(String? phone) => {
  'id': 'buyer-fixture',
  'full_name': 'Buyer fixture',
  'email': 'b***@example.test',
  'account_type': 'BUYER',
  'account_status': 'ACTIVE',
  'lock_version': 2,
  'created_at': '2026-10-01T00:00:00Z',
  'buyer_type': 'INDIVIDUAL',
  'company_name': null,
  'organization_name': null,
  'role': 'BUYER',
  'organization_id': null,
  'membership_id': null,
  'can_manage_staff': false,
  'permissions': <String>[],
  'mobile_e164': phone,
};

/// Answers the profile lookup (optionally after [gate]) and records every
/// Work Package save body in [saves].
ProjectsRepository _repository({
  String? phone,
  Completer<void>? gate,
  List<Map<String, Object?>>? saves,
}) {
  final client = api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          Object? data = <String, Object?>{};
          if (options.path.endsWith('/account/profile')) {
            await gate?.future;
            data = _profile(phone);
          } else if (options.data != null) {
            final body = options.data;
            saves?.add(
              Map<String, Object?>.from(
                (body is String ? jsonDecode(body) : body) as Map,
              ),
            );
          }
          handler.resolve(
            Response<Object?>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': data,
                'meta': <String, Object?>{},
                'errors': <Object?>[],
              },
            ),
          );
        },
      ),
    ],
  );
  return ProjectsRepository(
    client: client,
    onSessionExpired: () async => fail('A form must not end the session'),
  );
}

Widget _editor(
  ProjectsRepository repository, {
  String fulfillment = 'PICKUP',
  String contact = '',
  String heavy = 'NO',
  String siteName = '629 J Nepomuceno St',
}) => MaterialApp(
  theme: BuyerTheme.light,
  home: WorkPackageEditor(
    repository: repository,
    project: {
      'id': _projectId,
      'budget_centavos': 100000000,
      'budget': {'unallocated_centavos': 100000000},
      'sites': [
        {'id': _siteId, 'name': siteName},
      ],
    },
    package: {
      'id': '01995000-0000-7000-8000-000000000010',
      'status': 'DRAFT',
      'lock_version': 1,
      'budget_centavos': 7500000,
      'version': {
        'content': {
          'name': 'FOUNDATION',
          'site_id': _siteId,
          'fulfillment_method': fulfillment,
          'site_contact': contact,
          'access_instructions': 'Use the north gate',
          'budget_centavos': 7500000,
          'radius_km': 5,
          'destination': {'heavy_vehicle_restriction': heavy},
          'lines': [
            {
              'material_id': _material,
              'name': 'Rerolled steel bar',
              'unit_id': _unit,
              'unit_code': 'PC',
              'quantity': '50',
              'specifications': <String, Object?>{},
            },
          ],
        },
      },
    },
    chooseLocation: () async => null,
  ),
);

Future<void> _open(WidgetTester tester, Widget page) async {
  await tester.binding.setSurfaceSize(const Size(400, 1800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(page);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Site and fulfillment'));
  await tester.pumpAndSettle();
}

Future<void> _pick(WidgetTester tester, String from, String to) async {
  await tester.tap(find.text(from).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(to).last);
  await tester.pumpAndSettle();
}

/// The heavy-vehicle switch; the Budget card has its own switch.
Finder get _heavySwitch => find.descendant(
  of: find.byType(SettingSwitchRow),
  matching: find.byType(Switch),
);

TextField _field(WidgetTester tester, String label) => tester.widget<TextField>(
  find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label,
  ),
);

void main() {
  testWidgets('Fulfillment offers Delivery, Pickup and Both', (tester) async {
    await _open(tester, _editor(_repository(), fulfillment: 'DELIVERY'));
    await tester.tap(find.text('Delivery').first);
    await tester.pumpAndSettle();
    for (final option in ['Delivery', 'Pickup', 'Both']) {
      expect(find.text(option), findsWidgets);
    }
    expect(find.text('Both'), findsOneWidget);
    expect(find.text('Pickup'), findsOneWidget);
  });

  testWidgets('fields follow the order Fulfillment to Heavy vehicles', (
    tester,
  ) async {
    await _open(tester, _editor(_repository(), fulfillment: 'DELIVERY'));
    final tops = [
      for (final label in [
        'Fulfillment',
        'Project site',
        'Site contact',
        'Access instructions',
        'Heavy vehicles restricted',
      ])
        tester.getTopLeft(find.text(label)).dy,
    ];
    expect(tops, orderedEquals([...tops]..sort()));
    // Payment is chosen per supplier at quotation checkout, not in the package.
    expect(find.text('Payment method'), findsNothing);
  });

  testWidgets('Heavy vehicles restricted shows for Delivery and Both only', (
    tester,
  ) async {
    await _open(tester, _editor(_repository(), fulfillment: 'PICKUP'));
    expect(find.text('Heavy vehicles restricted'), findsNothing);

    await _pick(tester, 'Pickup', 'Delivery');
    expect(find.text('Heavy vehicles restricted'), findsOneWidget);
    await tester.tap(find.text('Heavy vehicles restricted'));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(_heavySwitch).value, isTrue);

    await _pick(tester, 'Delivery', 'Both');
    expect(find.text('Heavy vehicles restricted'), findsOneWidget);
    expect(tester.widget<Switch>(_heavySwitch).value, isTrue);

    // Hiding it resets it to off; it is off again when it returns.
    await _pick(tester, 'Both', 'Pickup');
    expect(find.text('Heavy vehicles restricted'), findsNothing);
    await _pick(tester, 'Pickup', 'Both');
    expect(tester.widget<Switch>(_heavySwitch).value, isFalse);
  });

  testWidgets('the off switch is outlined, not faded like a disabled one', (
    tester,
  ) async {
    await _open(tester, _editor(_repository(), fulfillment: 'DELIVERY'));
    final off = tester.widget<Switch>(_heavySwitch);
    expect(off.onChanged, isNotNull);
    expect(off.trackOutlineWidth?.resolve({}), 2);
    expect(off.trackOutlineColor?.resolve({}), BuyerTheme.muted);
    expect(off.thumbColor?.resolve({}), BuyerTheme.muted);
  });

  testWidgets('Both saves as BOTH with the delivery details', (tester) async {
    final saves = <Map<String, Object?>>[];
    await _open(
      tester,
      _editor(
        _repository(phone: '+639171234567', saves: saves),
        fulfillment: 'DELIVERY',
      ),
    );
    await _pick(tester, 'Delivery', 'Both');

    // A Draft saves with Finalize.
    await tester.tap(find.text('Finalize'));
    await tester.pumpAndSettle();
    expect(saves, hasLength(1));
    expect(saves.single['fulfillment_method'], 'BOTH');
    // Payment is chosen per supplier at quotation checkout.
    expect(saves.single.containsKey('payment_method'), isFalse);
    expect(saves.single['site_contact'], '+639171234567');
    expect(saves.single['heavy_vehicle_restriction'], 'NO');
  });

  testWidgets('Site contact opens with the profile phone and stays editable', (
    tester,
  ) async {
    await _open(tester, _editor(_repository(phone: '+639171234567')));
    expect(_field(tester, 'Site contact').controller!.text, '+639171234567');
    await tester.enterText(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Site contact',
      ),
      '09998887777',
    );
    expect(_field(tester, 'Site contact').controller!.text, '09998887777');
  });

  testWidgets('a late profile answer never overwrites what the Buyer typed', (
    tester,
  ) async {
    final gate = Completer<void>();
    await _open(
      tester,
      _editor(_repository(phone: '+639171234567', gate: gate)),
    );
    expect(_field(tester, 'Site contact').controller!.text, isEmpty);
    await tester.enterText(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Site contact',
      ),
      'Foreman Ramon',
    );
    gate.complete();
    await tester.pumpAndSettle();
    expect(_field(tester, 'Site contact').controller!.text, 'Foreman Ramon');
  });

  testWidgets('a saved Site contact is never replaced by the profile phone', (
    tester,
  ) async {
    await _open(
      tester,
      _editor(_repository(phone: '+639171234567'), contact: 'Site foreman'),
    );
    expect(_field(tester, 'Site contact').controller!.text, 'Site foreman');
  });

  testWidgets('a profile without a phone leaves Site contact empty', (
    tester,
  ) async {
    await _open(tester, _editor(_repository()));
    expect(_field(tester, 'Site contact').controller!.text, isEmpty);
  });

  testWidgets('the summary shows only while the card is collapsed', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_editor(_repository(), fulfillment: 'BOTH'));
    await tester.pumpAndSettle();
    expect(find.text('Both · 629 J Nepomuceno St'), findsOneWidget);
    await tester.tap(find.text('Site and fulfillment'));
    await tester.pumpAndSettle();
    expect(find.text('Both · 629 J Nepomuceno St'), findsNothing);
    // Each label and the helper copy appear once in the card.
    for (final text in [
      'Project site',
      'Fulfillment',
      'Site contact',
      'Access instructions',
      'Heavy vehicles restricted',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.textContaining('Project site'), findsOneWidget);
    await tester.tap(find.text('Site and fulfillment'));
    await tester.pumpAndSettle();
    expect(find.text('Both · 629 J Nepomuceno St'), findsOneWidget);
  });

  testWidgets('a long Project site address wraps and ends in an ellipsis', (
    tester,
  ) async {
    await _open(
      tester,
      _editor(_repository(), fulfillment: 'DELIVERY', siteName: _address),
    );
    expect(tester.takeException(), isNull);
    final name = tester.widget<Text>(find.text(_address));
    expect(name.maxLines, 2);
    expect(name.overflow, TextOverflow.ellipsis);
    // The field grew to show both lines instead of clipping the second.
    final field = find.ancestor(
      of: find.text(_address),
      matching: find.byType(InputDecorator),
    );
    expect(tester.getSize(field).height, greaterThan(56));
  });
}
