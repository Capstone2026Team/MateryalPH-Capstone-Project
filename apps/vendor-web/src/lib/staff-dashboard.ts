export function staffDashboardCopy(permissions: string[]) {
  if (permissions.includes('portal.fulfillment') && !permissions.includes('fulfillment.assign')) return { title: 'Your delivery dashboard', description: 'Your assigned deliveries and pickups, with active work first.' }
  if (permissions.includes('inventory.manage') && !permissions.includes('orders.confirm')) return { title: 'Your inventory dashboard', description: 'Stock availability, replenishment and product maintenance for your store.' }
  if (permissions.includes('scores.view_store')) return { title: 'Your operations dashboard', description: 'Order decisions, fulfillment deadlines and store operations that need your attention.' }
  if (permissions.includes('orders.confirm') && !permissions.includes('catalog.manage')) return { title: 'Your service dashboard', description: 'Buyer coordination, order requests and cases that need a response.' }
  return { title: 'Your team dashboard', description: 'Your order, inventory and customer service work in one place.' }
}
