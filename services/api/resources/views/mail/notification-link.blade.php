@if(!empty($noticeUrl))
@include('mail.partials.button', ['url' => $noticeUrl, 'label' => $actionLabel ?? $purposeLabel ?? 'View details', 'caption' => 'Sign in to your MateryalPH account to view the full details securely.'])
@endif
