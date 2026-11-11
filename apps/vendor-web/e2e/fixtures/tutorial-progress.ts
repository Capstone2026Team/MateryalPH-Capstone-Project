// Returning users keep manual replay checks independent of first-visit behavior.
export const completedVendorTutorials = [
  'overview', 'store', 'products', 'inventory', 'messages', 'orders', 'dashboard', 'fulfillment',
  'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions',
  'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support',
].map(tutorial_key => ({ tutorial_key, status: 'COMPLETED', updated_at: '2026-11-11T00:00:00Z' }))
