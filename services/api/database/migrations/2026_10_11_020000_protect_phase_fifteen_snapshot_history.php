<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::unprepared(<<<'SQL'
CREATE TRIGGER notification_attempts_append_only BEFORE UPDATE OR DELETE ON notification_delivery_attempts
FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER export_access_append_only BEFORE UPDATE OR DELETE ON export_access_events
FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER tax_package_lines_append_only BEFORE UPDATE OR DELETE ON tax_report_package_lines
FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE FUNCTION protect_phase15_export_snapshot() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Export history is immutable';
    END IF;
    IF OLD.source_snapshot IS NOT NULL AND
       ROW(NEW.source_snapshot, NEW.source_hash, NEW.source_versions, NEW.requested_by_user_id, NEW.export_type, NEW.resource_id, NEW.resource_type, NEW.filters, NEW.reason, NEW.format)
       IS DISTINCT FROM
       ROW(OLD.source_snapshot, OLD.source_hash, OLD.source_versions, OLD.requested_by_user_id, OLD.export_type, OLD.resource_id, OLD.resource_type, OLD.filters, OLD.reason, OLD.format) THEN
        RAISE EXCEPTION 'Export source is immutable; request a new snapshot';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER export_snapshot_immutable BEFORE UPDATE OR DELETE ON data_exports
FOR EACH ROW EXECUTE FUNCTION protect_phase15_export_snapshot();
CREATE FUNCTION protect_phase15_tax_snapshot() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Tax package history is immutable';
    END IF;
    IF OLD.snapshot IS NOT NULL AND
       ROW(NEW.snapshot, NEW.content_hash, NEW.prepared_by_user_id, NEW.package_type, NEW.period_start, NEW.period_end, NEW.withholding_entity, NEW.vendor_organization_id, NEW.filing_calendar_version_id, NEW.form_version)
       IS DISTINCT FROM
       ROW(OLD.snapshot, OLD.content_hash, OLD.prepared_by_user_id, OLD.package_type, OLD.period_start, OLD.period_end, OLD.withholding_entity, OLD.vendor_organization_id, OLD.filing_calendar_version_id, OLD.form_version) THEN
        RAISE EXCEPTION 'Tax package source is immutable; prepare a new package';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER tax_snapshot_immutable BEFORE UPDATE OR DELETE ON tax_report_packages
FOR EACH ROW EXECUTE FUNCTION protect_phase15_tax_snapshot();
SQL);
    }

    public function down(): void
    {
        // Forward-only: commercial sources and access history remain auditable.
    }
};
