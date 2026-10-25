<!doctype html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="x-apple-disable-message-reformatting">
<meta name="color-scheme" content="light">
<meta name="supported-color-schemes" content="light">
<title>@yield('heading')</title>
<style>
    body { margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table { border-collapse: collapse; }
    a { color: #C2410C; }
    @media (max-width: 620px) {
        .mp-shell { padding: 20px 12px !important; }
        .mp-body { padding: 28px 20px !important; }
        .mp-heading { font-size: 22px !important; line-height: 30px !important; }
    }
</style>
</head>
<body style="margin: 0; padding: 0; background-color: #F8FAFC;">
@hasSection('preheader')
<div style="display: none; max-height: 0; max-width: 0; overflow: hidden; opacity: 0; mso-hide: all; font-size: 1px; line-height: 1px; color: #F8FAFC;">@yield('preheader')</div>
@endif
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #F8FAFC;">
<tr>
<td align="center" class="mp-shell" style="padding: 32px 16px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="width: 100%; max-width: 600px;">

<tr>
<td style="padding: 0 4px 20px;">
<table role="presentation" cellpadding="0" cellspacing="0" border="0">
<tr>
<td width="32" height="32" align="center" valign="middle" style="width: 32px; height: 32px; background-color: #C2410C; border-radius: 8px; font-family: Inter, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 17px; font-weight: 700; line-height: 32px; color: #FFFFFF;" aria-hidden="true">M</td>
<td style="padding-left: 10px; font-family: Inter, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 19px; font-weight: 700; line-height: 32px; color: #1F2937; letter-spacing: -0.01em;">MateryalPH</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="background-color: #FFFFFF; border: 1px solid #E5E7EB; border-radius: 12px; overflow: hidden;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
<tr><td height="4" style="height: 4px; line-height: 4px; font-size: 4px; background-color: #F97316; border-radius: 12px 12px 0 0;">&nbsp;</td></tr>
<tr>
<td class="mp-body" style="padding: 36px 40px; font-family: Inter, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 15px; line-height: 24px; color: #1F2937;">
@hasSection('eyebrow')
<p style="margin: 0 0 8px; font-size: 12px; line-height: 16px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #C2410C;">@yield('eyebrow')</p>
@endif
<h1 class="mp-heading" style="margin: 0 0 16px; font-size: 24px; line-height: 32px; font-weight: 700; color: #1F2937;">@yield('heading')</h1>

@yield('content')

@hasSection('next')
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0 0;">
<tr>
<td style="padding: 16px 20px; background-color: #FFF7ED; border-left: 4px solid #F97316; border-radius: 0 8px 8px 0;">
<p style="margin: 0 0 4px; font-size: 13px; line-height: 20px; font-weight: 700; color: #9A3412;">Next step</p>
<p style="margin: 0; font-size: 15px; line-height: 24px; color: #1F2937;">@yield('next')</p>
</td>
</tr>
</table>
@endif

@yield('action')

@hasSection('security')
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 32px 0 0;">
<tr>
<td style="padding: 20px 0 0; border-top: 1px solid #E5E7EB;">
<p style="margin: 0; font-size: 13px; line-height: 20px; color: #475569;"><strong style="color: #1F2937;">Security reminder:</strong> @yield('security')</p>
</td>
</tr>
</table>
@endif
</td>
</tr>
</table>
</td>
</tr>

<tr>
<td align="center" style="padding: 24px 16px 0; font-family: Inter, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 12px; line-height: 18px; color: #475569;">
@hasSection('reason')
<p style="margin: 0 0 6px;">@yield('reason')</p>
@else
<p style="margin: 0 0 6px;">You received this email because you have a MateryalPH account.</p>
@endif
<p style="margin: 0;">&copy; {{ now('Asia/Manila')->year }} MateryalPH &middot; Construction materials marketplace, Philippines</p>
</td>
</tr>

</table>
</td>
</tr>
</table>
</body>
</html>
