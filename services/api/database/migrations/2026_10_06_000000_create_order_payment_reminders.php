<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Records which Pending Payment reminders were already sent for an order (for example 12 hours and 1 hour before
 * the deadline) so the scheduler can run as often as it likes without ever notifying the Buyer twice for the same
 * point. The deadline itself stays in `orders.payment_expires_at`, the single source of truth.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('order_payment_reminders', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained('orders')->restrictOnDelete();
            $table->unsignedSmallInteger('hours_before');
            $table->timestampTz('sent_at');
            $table->timestampsTz();
            $table->unique(['order_id', 'hours_before']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('order_payment_reminders');
    }
};
