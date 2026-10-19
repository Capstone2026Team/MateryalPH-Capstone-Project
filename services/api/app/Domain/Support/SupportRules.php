<?php

declare(strict_types=1);

namespace App\Domain\Support;

final class SupportRules
{
    public const STATUSES = ['OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER', 'RESOLVED', 'CLOSED'];

    public const CATEGORIES = ['GENERAL_INQUIRY', 'TECHNICAL_ISSUE', 'ACCOUNT_CONCERN', 'VERIFICATION_ISSUE', 'PAYMENT_CONCERN', 'ORDER_CONCERN', 'COMPLAINT', 'FEEDBACK_SUGGESTION', 'OTHER'];

    public const TYPES = ['BUYER', 'VENDOR', 'GUEST'];

    public const REFERENCES = ['ORDER', 'PROJECT', 'WORK_PACKAGE', 'TRANSACTION'];

    public const PRIVACY_NOTICE = 'MateryalPH uses your contact details, messages, reference details and attachments to investigate and respond to this support request. Access is limited to you and authorized administrators. Records are retained under platform retention and legal obligations. Share only relevant information; never send passwords, one-time codes, full payment credentials or unrelated personal data. You may request access or correction through this support channel. Read the Privacy Notice for your rights and further details.';
}
