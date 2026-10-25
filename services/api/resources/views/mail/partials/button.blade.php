<table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin: 28px 0 0;">
<tr>
<td align="center" bgcolor="#C2410C" style="background-color: #C2410C; border-radius: 8px;">
<a href="{{ $url }}" target="_blank" rel="noopener" style="display: inline-block; padding: 13px 28px; font-family: Inter, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 15px; line-height: 20px; font-weight: 700; color: #FFFFFF; text-decoration: none; border-radius: 8px;">{{ $label }}</a>
</td>
</tr>
</table>
@isset($caption)
<p style="margin: 12px 0 0; font-size: 13px; line-height: 20px; color: #475569;">{{ $caption }}</p>
@endisset
