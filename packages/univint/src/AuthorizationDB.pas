{
 * Copyright (c) 2003 Apple Computer, Inc. All Rights Reserved.
 * 
 * The contents of this file constitute Original Code as defined in and are
 * subject to the Apple Public Source License Version 1.2 (the 'License').
 * You may not use this file except in compliance with the License. Please obtain
 * a copy of the License at http://www.apple.com/publicsource and read it before
 * using this file.
 * 
 * This Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY of ANY KIND, EITHER EXPRESS
 * OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES, INCLUDING WITHOUT
 * LIMITATION, ANY WARRANTIES of MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT. Please see the License for the
 * specific language governing rights and limitations under the License.
 }
{	  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }

{
 *  AuthorizationDB.h -- APIs for managing the authorization policy database
 *  and daemons.
 }


{
    Modified for use with Free Pascal
    Version 210
    Please report any bugs to <gpc@microbizz.nl>
}

{$mode macpas}
{$packenum 1}
{$macro on}
{$inline on}
{$calling mwpascal}

unit AuthorizationDB;
interface
{$setc UNIVERSAL_INTERFACES_VERSION := $0342}
{$setc GAP_INTERFACES_VERSION := $0210}

{$ifc not defined USE_CFSTR_CONSTANT_MACROS}
    {$setc USE_CFSTR_CONSTANT_MACROS := TRUE}
{$endc}

{$ifc defined CPUPOWERPC and defined CPUI386}
	{$error Conflicting initial definitions for CPUPOWERPC and CPUI386}
{$endc}
{$ifc defined FPC_BIG_ENDIAN and defined FPC_LITTLE_ENDIAN}
	{$error Conflicting initial definitions for FPC_BIG_ENDIAN and FPC_LITTLE_ENDIAN}
{$endc}

{$ifc not defined __ppc__ and defined CPUPOWERPC}
	{$setc __ppc__ := 1}
{$elsec}
	{$setc __ppc__ := 0}
{$endc}
{$ifc not defined __i386__ and defined CPUI386}
	{$setc __i386__ := 1}
{$elsec}
	{$setc __i386__ := 0}
{$endc}

{$ifc defined __ppc__ and __ppc__ and defined __i386__ and __i386__}
	{$error Conflicting definitions for __ppc__ and __i386__}
{$endc}

{$ifc defined __ppc__ and __ppc__}
	{$setc TARGET_CPU_PPC := TRUE}
	{$setc TARGET_CPU_X86 := FALSE}
{$elifc defined __i386__ and __i386__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_X86 := TRUE}
{$elsec}
	{$error Neither __ppc__ nor __i386__ is defined.}
{$endc}
{$setc TARGET_CPU_PPC_64 := FALSE}

{$ifc defined FPC_BIG_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := TRUE}
	{$setc TARGET_RT_LITTLE_ENDIAN := FALSE}
{$elifc defined FPC_LITTLE_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := FALSE}
	{$setc TARGET_RT_LITTLE_ENDIAN := TRUE}
{$elsec}
	{$error Neither FPC_BIG_ENDIAN nor FPC_LITTLE_ENDIAN are defined.}
{$endc}
{$setc ACCESSOR_CALLS_ARE_FUNCTIONS := TRUE}
{$setc CALL_NOT_IN_CARBON := FALSE}
{$setc OLDROUTINENAMES := FALSE}
{$setc OPAQUE_TOOLBOX_STRUCTS := TRUE}
{$setc OPAQUE_UPP_TYPES := TRUE}
{$setc OTCARBONAPPLICATION := TRUE}
{$setc OTKERNEL := FALSE}
{$setc PM_USE_SESSION_APIS := TRUE}
{$setc TARGET_API_MAC_CARBON := TRUE}
{$setc TARGET_API_MAC_OS8 := FALSE}
{$setc TARGET_API_MAC_OSX := TRUE}
{$setc TARGET_CARBON := TRUE}
{$setc TARGET_CPU_68K := FALSE}
{$setc TARGET_CPU_MIPS := FALSE}
{$setc TARGET_CPU_SPARC := FALSE}
{$setc TARGET_OS_MAC := TRUE}
{$setc TARGET_OS_UNIX := FALSE}
{$setc TARGET_OS_WIN32 := FALSE}
{$setc TARGET_RT_MAC_68881 := FALSE}
{$setc TARGET_RT_MAC_CFM := FALSE}
{$setc TARGET_RT_MAC_MACHO := TRUE}
{$setc TYPED_FUNCTION_POINTERS := TRUE}
{$setc TYPE_BOOL := FALSE}
{$setc TYPE_EXTENDED := FALSE}
{$setc TYPE_LONGLONG := TRUE}
uses MacTypes,Authorization,CFBase,CFDictionary,CFString,CFBundle;
{$ALIGN MAC68K}
{!
	@header AuthorizationDB
	Version 1.0

	This API allows for any programs to get, modify, delete and add new right definitions to the policy database.  Meta-rights specify whether and what authorization is required to make these modifications.
	
	AuthorizationRightSet(NULL, "com.ifoo.ifax.send", CFSTR(kRuleIsAdmin), CFSTR("You must authenticate to send a fax."), NULL, NULL)

	add a rule for letting admins send faxes using a canned rule, delegating to a pre-specified rule that authorizes everyone who is an admin.
	
	AuthorizationRightSet(NULL, "com.ifoo.ifax.send", [[CFSTR(kRightRule), CFSTR(kRuleIsAdmin)], [CFSTR(kRightComment), CFSTR("authorizes sending of 1 fax message")]], CFSTR("Authorize sending of a fax"), NULL, NULL)

	add identical rule, but specify additional attributes this time.

	Keep in mind while specifying a comment to be specific about what you need to authorize for (1 fax), in terms of a general message for user.  The means of proof required for kRuleIsAdmin (enter username/password for example) should not be included here, since it could be configured differently.

}

{!	@define kRightRule
	rule delegation key.  Instead of specifying exact behavior some canned rules
   are shipped that may be switched by configurable security.
}
const kAuthorizationRightRule					= 'rule';

{! @defined kRuleIsAdmin
	canned rule values for use with rule delegation definitions: require user to be an admin.
}
const kAuthorizationRuleIsAdmin				= 'is-admin';

{! @defined kRuleAuthenticateAsSessionUser
	canned rule value for use with rule delegation definitions: require user to authenticate as the session owner (logged-in user).
}
const kAuthorizationRuleAuthenticateAsSessionUser= 'authenticate-session-user';

{! @defined kRuleAuthenticateAsAdmin
	Canned rule value for use with rule delegation definitions: require user to authenticate as admin.
}
const kAuthorizationRuleAuthenticateAsAdmin	= 'authenticate-admin';

{! @defined kAuthorizationRuleClassAllow
	Class that allows anything.
}
const kAuthorizationRuleClassAllow		= 'allow';

{! @defined kAuthorizationRuleClassDeny
	Class that denies anything. 
}
const kAuthorizationRuleClassDeny			= 'deny';

{! @defined kAuthorizationComment
    comments for the administrator on what is being customized here;
   as opposed to (localized) descriptions presented to the user.
}
const kAuthorizationComment = 'comment';


{!
	@function AuthorizationRightGet 
	
	Retrieves a right definition as a dictionary.  There are no restrictions to keep anyone from retrieving these definitions.  

	@param rightName (input) the rightname (ASCII).  Wildcard rightname definitions are okay.
	@param rightDefinition (output/optional) the dictionary with all keys defining the right.  See documented keys.  Passing in NULL will just check if there is a definition.  The caller is responsible for releasing the returned dictionary.

	@result errAuthorizationSuccess 0 No error.

	errAuthorizationDenied -60005 No definition found.

}
function AuthorizationRightGet( rightName: ConstCStringPtr; rightDefinition: CFDictionaryRefPtr ): OSStatus; external name '_AuthorizationRightGet';
// attribute(weak_import);

{!
	@function AuthorizationRightSet
	
	Create or update a right entry.  Only normal rights can be registered (wildcard rights are denied); wildcard rights are considered to be put in by an administrator putting together a site configuration.

	@param authRef (input) authRef to authorize modifications.
	@param rightName (input) the rightname (ASCII).  Wildcard rightnames are not okay.
	@param rightDefinition (input) a CFString of the name of a rule to use (delegate) or CFDictionary containing keys defining one.
	@param descriptionKey (input/optional) a CFString to use as a key for looking up localized descriptions.  If no localization is found this will be the description itself.
	@param bundle (input/optional) a bundle to get localizations from if not the main bundle.
	@param localeTableName (input/optional) stringtable name to get localizations from.
	
	@result errAuthorizationSuccess 0 added right definition successfully.

	errAuthorizationDenied -60005 Unable to create or update right definition.

	errAuthorizationCanceled -60006 Authorization was canceled by user.

	errAuthorizationInteractionNotAllowed -60007 Interaction was required but not possible.

}
function AuthorizationRightSet(authRef: AuthorizationRef; rightName: ConstCStringPtr; rightDefinition: CFTypeRef; descriptionKey: CFStringRef; bundle: CFBundleRef; localeTableName: CFStringRef): OSStatus; external name '_AuthorizationRightSet';
// attribute(weak_import);


{!
	@function AuthorizationRightRemove

	Request to remove a right from the policy database.

	@param authRef (input) authRef, to be used to authorize this action.
	@param rightName (input) the rightname (ASCII).  Wildcard rightnames are not okay.
	
}
function AuthorizationRightRemove(authRef: AuthorizationRef; rightName: ConstCStringPtr): OSStatus; external name '_AuthorizationRightRemove';

end.
