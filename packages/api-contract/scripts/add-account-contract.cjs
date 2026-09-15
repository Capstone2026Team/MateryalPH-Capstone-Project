const fs = require('node:fs');
const path = require('node:path');
const target = path.join(__dirname, '../openapi.yaml');
const ref = name => ({ $ref: '#/components/schemas/' + name });
const string = { type: 'string' };
const nullable = { type: ['string', 'null'] };
const boolean = { type: 'boolean' };
const integer = { type: 'integer' };
const array = items => ({ type: 'array', items });
const object = (properties, required = Object.keys(properties)) => ({ type: 'object', additionalProperties: false, required, properties });
const schemas = {
  AccountProfile: object({ id: string, full_name: string, email: string, account_type: string, account_status: string, lock_version: integer, created_at: nullable, buyer_type: nullable, company_name: nullable, organization_name: nullable, role: string, organization_id: nullable, membership_id: nullable, can_manage_staff: boolean, permissions: array(string) }),
  AccountProfileUpdate: object({ full_name: {type:'string',maxLength:160}, lock_version: {type:'integer',minimum:1}, buyer_type: {type:'string',enum:['INDIVIDUAL','BUSINESS']}, company_name: nullable }, ['full_name','lock_version']),
  AccountSession: object({ id: string, description: string, current: boolean, created_at: nullable, last_active_at: nullable }),
  AccountSecurity: object({ totp_enrolled: boolean, recent_authentication_expires_at: nullable }),
  AccountReauthentication: object({ password: nullable, code: nullable, email_code: nullable }, []),
  AccountPasswordChange: object({ password: {type:'string',minLength:14,maxLength:1024}, password_confirmation: string }),
  AccountEmailChange: object({ email: {type:'string',format:'email'} }),
  AccountCodeConfirmation: object({ id: {type:'string',format:'uuid'}, code: {type:'string',pattern:'^[0-9]{6}$'} }),
  AccountPendingChange: object({id:string,expires_at:string}),
  AccountFactorEnrollment: object({id:string,expires_at:string,secret:string,provisioning_uri:string}),
  AccountRecoveryCodes: object({recovery_codes:array(string),sign_in_required:boolean},['recovery_codes']),
  AccountMutationResult: object({changed:boolean,verified:boolean,revoked:boolean,accepted:boolean,queued:boolean,sign_in_required:boolean,next:string},[]),
  AccountSessionRevocation: object({scope:{type:'string',enum:['OTHERS','ALL']}}),
  AccountAgreement: object({id:string,code:string,title:string,version:integer,content:nullable,content_available:boolean,accepted_at:nullable,requires_acceptance:boolean}),
  AccountAgreementAcceptance: object({version_ids:array({type:'string',format:'uuid'})}),
  AccountMembership: object({id:string,name:string,role:string,status:string,can_manage_staff:boolean}),
  AccountDelegation: object({can_manage_staff:boolean}),
  AccountMembershipStatus: object({status:{type:'string',enum:['ACTIVE','SUSPENDED','DEACTIVATED']}}),
  AccountAdministrator: object({id:string,name:string,role:string,role_id:string,status:string,lock_version:integer}),
  AccountAdminChange: object({lock_version:integer,reason:{type:'string',minLength:3,maxLength:500},status:{type:'string',enum:['ACTIVE','SUSPENDED','DEACTIVATED']},role_id:{type:'string',format:'uuid'}},['lock_version','reason']),
  AccountRole: object({id:string,code:string,name:string}),
  AccountAdminInvitation: object({email:{type:'string',format:'email'},role_id:{type:'string',format:'uuid'}}),
  VendorInvitationAcceptance: object({token:string,email:{type:'string',format:'email'},full_name:string,password:{type:'string',minLength:14},password_confirmation:string}),
};
for (const [name, data] of Object.entries({...schemas})) {
  if (['AccountProfile','AccountSecurity','AccountPendingChange','AccountFactorEnrollment','AccountRecoveryCodes','AccountMutationResult'].includes(name)) schemas[name+'Envelope'] = object({data:ref(name),meta:{type:'object',additionalProperties:true},errors:array({type:'object',additionalProperties:true})});
}
for(const name of ['AccountSession','AccountAgreement','AccountMembership','AccountRole','AccountAdministrator']) schemas[name+'ListEnvelope']=object({data:array(ref(name)),meta:{type:'object',additionalProperties:true},errors:array({type:'object',additionalProperties:true})});
const paths = {};
function operation(suffix,method,id,response,body, extra=[]){
 const key='/{accountPortal}/account/'+suffix;
 const audience = suffix.startsWith('memberships') ? ['vendors'] : (['roles','invitations'].includes(suffix) || suffix.startsWith('administrators')) ? ['admin'] : (suffix.startsWith('factor') || suffix === 'recovery-codes') ? ['vendors','admin'] : ['buyers','vendors','admin'];
 const parameters=[{name:'accountPortal',in:'path',required:true,schema:{type:'string',enum:audience}},...extra];
 const op={operationId:id,tags:['Accounts'],description:'Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.',parameters,security:[{passportBearer:[]},{accessCookie:[],...(method==='get'?{}:{webCsrf:[]})}],responses:{'200':{description:'Successful account operation.',content:{'application/json':{schema:ref(response)}}}}};
 for(const code of ['401','403','404','409','419','422','429','503']) op.responses[code]={description:'Safe canonical error with correlation identifier.',content:{'application/json':{schema:ref('ErrorEnvelope')}}};
 if(body)op.requestBody={required:true,content:{'application/json':{schema:ref(body)}}};
 (paths[key]??={})[method]=op;
}
operation('profile','get','getAccountProfile','AccountProfileEnvelope');
operation('profile','patch','updateAccountProfile','AccountProfileEnvelope','AccountProfileUpdate');
operation('security','get','getAccountSecurity','AccountSecurityEnvelope');
operation('reauthentication','post','reauthenticateAccount','AccountMutationResultEnvelope','AccountReauthentication');
operation('reauthentication/email','post','sendAccountReauthenticationEmail','AccountMutationResultEnvelope');
operation('sessions','get','listAccountSessions','AccountSessionListEnvelope',null,[{name:'page',in:'query',schema:{type:'integer',minimum:1}}]);
operation('sessions/{sessionId}','delete','revokeAccountSession','AccountMutationResultEnvelope',null,[{name:'sessionId',in:'path',required:true,schema:{type:'string',format:'uuid'}}]);
operation('sessions/revoke','post','revokeAccountSessions','AccountMutationResultEnvelope','AccountSessionRevocation');
operation('password','post','changeAccountPassword','AccountMutationResultEnvelope','AccountPasswordChange');
operation('email','post','startAccountEmailChange','AccountPendingChangeEnvelope','AccountEmailChange');
operation('email/confirm','post','confirmAccountEmailChange','AccountMutationResultEnvelope','AccountCodeConfirmation');
operation('factor','post','startAccountFactorReplacement','AccountFactorEnrollmentEnvelope');
operation('factor/confirm','post','confirmAccountFactorReplacement','AccountRecoveryCodesEnvelope','AccountCodeConfirmation');
operation('recovery-codes','post','replaceAccountRecoveryCodes','AccountRecoveryCodesEnvelope');
operation('agreements','get','listAccountAgreements','AccountAgreementListEnvelope');
operation('agreements','post','acceptAccountAgreements','AccountMutationResultEnvelope','AccountAgreementAcceptance');
operation('memberships','get','listAccountMemberships','AccountMembershipListEnvelope',null,[{name:'page',in:'query',schema:{type:'integer',minimum:1}}]);
operation('memberships/{membershipId}/delegation','patch','changeAccountDelegation','AccountMutationResultEnvelope','AccountDelegation',[{name:'membershipId',in:'path',required:true,schema:{type:'string',format:'uuid'}}]);
operation('memberships/{membershipId}/status','patch','changeAccountMembershipStatus','AccountMutationResultEnvelope','AccountMembershipStatus',[{name:'membershipId',in:'path',required:true,schema:{type:'string',format:'uuid'}}]);
operation('administrators','get','listAccountAdministrators','AccountAdministratorListEnvelope',null,[{name:'page',in:'query',schema:{type:'integer',minimum:1}}]);
operation('administrators/{publicId}','patch','changeAccountAdministrator','AccountMutationResultEnvelope','AccountAdminChange',[{name:'publicId',in:'path',required:true,schema:{type:'string',format:'uuid'}}]);
operation('roles','get','listAccountAdminRoles','AccountRoleListEnvelope');
operation('invitations','post','inviteAccountAdmin','AccountMutationResultEnvelope','AccountAdminInvitation',[{name:'Idempotency-Key',in:'header',required:true,schema:{type:'string',format:'uuid'}}]);
paths['/{accountPortal}/account/invitations'].post.responses['202']=paths['/{accountPortal}/account/invitations'].post.responses['200'];
delete paths['/{accountPortal}/account/invitations'].post.responses['200'];
paths['/auth/vendor-invitations/accept']={post:{operationId:'acceptVendorStaffInvitation',tags:['Accounts'],security:[{webCsrf:[]}],requestBody:{required:true,content:{'application/json':{schema:ref('VendorInvitationAcceptance')}}},responses:{'201':{description:'Invitation consumed. Verify email and sign in; privileged roles require TOTP.',content:{'application/json':{schema:ref('AccountMutationResultEnvelope')}}},'422':{description:'Invalid invitation or details.',content:{'application/json':{schema:ref('ErrorEnvelope')}}}}}};
let source=fs.readFileSync(target,'utf8');
source=source.split(/\r?\n/).filter(line => !line.startsWith('  "/{accountPortal}/account/') && !line.startsWith('  "/auth/vendor-invitations/accept"') && !Object.keys(schemas).some(name=>line.startsWith('    '+JSON.stringify(name)+': '))).join('\n');
const entries=(value,spaces)=>Object.entries(value).map(([key,v])=>' '.repeat(spaces)+JSON.stringify(key)+': '+JSON.stringify(v)).join('\n')+'\n';
source=source.replace('components:',entries(paths,2)+'components:');
source=source.replace('  schemas:', '  schemas:\n'+entries(schemas,4));
source=source.replace('version: 1.0.0-phase.1','version: 1.0.0-phase.2');
fs.writeFileSync(target,source);
