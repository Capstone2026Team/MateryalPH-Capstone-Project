<!doctype html>
<html lang="en"><body>
<h1>{{ $noticeSubject }}</h1>
<p>{{ $noticeBody }}</p>
@if($accountType === 'BUYER')
<p>Open MateryalPH and go to Profile → Help Center → My Support Requests to read the update and reply.</p>
@elseif($accountType === 'VENDOR')
<p>Open My Support Requests in the Vendor portal to read the update and reply.</p>
@else
<p>Open Support Requests in the Admin portal to review the ticket.</p>
@endif
@include('mail.notification-link')
<p>Your private messages and attachments are available only in the support ticket. MateryalPH will never ask you to send a password, one-time code or payment details by email.</p>
</body></html>
