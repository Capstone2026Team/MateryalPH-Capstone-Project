@if(!empty($noticeUrl))
@include('mail.partials.button', ['url' => $noticeUrl, 'label' => 'Open notification', 'caption' => 'You will be asked to sign in to your MateryalPH account. Access is checked again when you open this link.'])
@endif
