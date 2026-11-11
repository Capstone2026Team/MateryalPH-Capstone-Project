import 'package:flutter/material.dart';
import '../../design_system/components/guided_walkthrough.dart';

class BuyerTutorialTopic {
  const BuyerTutorialTopic(
    this.key,
    this.label,
    this.destination,
    this.target,
    this.title,
    this.description,
    this.icon,
  );
  final String key, label, target, title, description;
  final int destination;
  final IconData icon;
}

const buyerTutorialTopics = [
  BuyerTutorialTopic(
    'discovery',
    'Find suppliers on the map',
    0,
    'nav-0',
    'Find suppliers near your site',
    'Map starts with your selected location. Choose a search radius, then use a pin or the supplier list to open details. Verified stores support marketplace purchases; Directory suppliers provide reference information only.',
    Icons.map_outlined,
  ),
  BuyerTutorialTopic(
    'procurement',
    'Compare and buy materials',
    1,
    'nav-1',
    'Explore materials and compare options',
    'Explore uses the same location and radius as Map. Search for a material, compare available listings, then open Product Details to choose quantities and fulfillment before adding to your cart.',
    Icons.inventory_2_outlined,
  ),
  BuyerTutorialTopic(
    'projects',
    'Plan a project',
    2,
    'nav-2',
    'Source materials for a project',
    'Create a Project with a site and budget, then add a Work Package with your materials. Scan for supplier options, compare the results and review the costs before selecting an arrangement.',
    Icons.assignment_outlined,
  ),
  BuyerTutorialTopic(
    'messages',
    'Request a quotation',
    3,
    'nav-3',
    'Ask a store for a quotation',
    'Message a verified store from its profile, a product or your project results. Share the materials you need in that conversation. Review the latest quotation and its terms before accepting. Requests go to the stores you contact.',
    Icons.chat_bubble_outline,
  ),
  BuyerTutorialTopic(
    'orders',
    'Track your orders',
    4,
    'profile-orders',
    'Keep track of every purchase',
    'Open Orders from Profile, then select an order for its next action, payment status, pickup or delivery milestones and fulfillment messages. Delivery progress uses status updates, without live vehicle tracking.',
    Icons.local_shipping_outlined,
  ),
];

List<WalkthroughStep> buyerTutorialSteps(
  String key,
  GlobalKey Function(String) anchor,
) {
  final topics = key == 'overview'
      ? buyerTutorialTopics
      : buyerTutorialTopics.where((topic) => topic.key == key);
  final steps = <WalkthroughStep>[];
  for (final topic in topics) {
    steps.add(
      WalkthroughStep(
        target: anchor(topic.target),
        title: topic.title,
        description: topic.description,
        icon: topic.icon,
        destination: topic.destination,
      ),
    );
    if (topic.key == 'discovery') {
      steps.add(
        WalkthroughStep(
          target: anchor('map-origin'),
          title: 'Choose your search area',
          description:
              'Tap the location control to choose where you need materials. Once a location is set, use the radius controls to adjust nearby results. Map and Explore share this search area.',
          icon: Icons.radar,
          destination: 0,
        ),
      );
    }
    if (topic.key == 'procurement') {
      steps.add(
        WalkthroughStep(
          target: anchor('explore-search'),
          title: 'Start with the material you need',
          description:
              'Tap Search to find a material. Compare specifications, prices and supplier details, then review your cart before checkout. Adding an item to your cart does not reserve stock.',
          icon: Icons.search,
          destination: 1,
        ),
      );
    }
  }
  if (key == 'overview') {
    steps.add(
      WalkthroughStep(
        target: anchor('profile-tutorial'),
        title: 'Come back whenever you need help',
        description:
            'Help / tutorial is here in Profile. Replay the complete tour or choose just one feature. You can skip or close a tour at any time.',
        icon: Icons.menu_book_outlined,
        destination: 4,
      ),
    );
  }
  return steps;
}
