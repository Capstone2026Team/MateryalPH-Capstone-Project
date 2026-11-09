@extends('mail.layouts.base')

@section('preheader', $noticeBody)
@section('eyebrow', 'Support')
@section('heading', $noticeSubject)

@section('content')
@isset($supportTicket)
<p style="margin: 0 0 20px; color: #475569;">{{ $accountType === 'ADMIN' ? 'A support request has an update for your review.' : 'There is an update to your support request.' }}</p>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 8px;">
<tr><td style="padding: 18px 20px;">
<p style="margin: 0 0 5px; font-size: 12px; line-height: 18px; color: #64748B;">Support request</p>
<p style="margin: 0 0 8px; font-size: 17px; line-height: 25px; font-weight: 700; overflow-wrap: anywhere;">{{ $supportTicket->ticket_number }}</p>
<p style="margin: 0; font-size: 13px; line-height: 20px; color: #475569;">Status: {{ ucfirst(strtolower(str_replace('_', ' ', $supportTicket->status))) }}</p>
</td></tr>
</table>
@else
@include('mail.partials.notice', ['text' => $noticeBody])
@endisset
<p style="margin: 16px 0 0; font-size: 13px; line-height: 20px; color: #475569;">Your private messages and attachments are available only in the support ticket.</p>
@endsection

@section('next')
@if($accountType === 'BUYER')
Open MateryalPH and go to <strong>Profile → Help Center → My Support Requests</strong> to read the update and reply.
@elseif($accountType === 'VENDOR')
Open <strong>My Support Requests</strong> in the Vendor portal to read the update and reply.
@else
Open <strong>Support Requests</strong> in the Admin portal to review the ticket.
@endif
@endsection

@section('action')
@include('mail.notification-link', ['purposeLabel' => 'View support request'])
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or payment details by email.')
