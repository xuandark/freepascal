{	CFBase.h
	Copyright (c) 1998-2005, Apple, Inc. All rights reserved.
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
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

unit CFBase;
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
uses MacTypes;
{$ALIGN POWER}


var kCFCoreFoundationVersionNumber: Float64; external name '_kCFCoreFoundationVersionNumber'; (* attribute const *)

const
	kCFCoreFoundationVersionNumber10_0 = 196.4;
const
	kCFCoreFoundationVersionNumber10_0_3 = 196.5;
const
	kCFCoreFoundationVersionNumber10_1 = 226.0;
{ Note the next two do not follow the usual numbering policy from the base release }
const
	kCFCoreFoundationVersionNumber10_1_2 = 227.2;
const
	kCFCoreFoundationVersionNumber10_1_4 = 227.3;
const
	kCFCoreFoundationVersionNumber10_2 = 263.0;
const
	kCFCoreFoundationVersionNumber10_3 = 299.0;
const
	kCFCoreFoundationVersionNumber10_3_3 = 299.3;
const
	kCFCoreFoundationVersionNumber10_3_4 = 299.31;

{$ifc TARGET_CPU_PPC_64}
type
	CFTypeID = UInt32;
	CFOptionFlags = UInt64;
	CFHashCode = UInt32;
	CFIndex = SInt64;
	CFIndexPtr = ^CFIndex;
{$elsec}
type
	CFTypeID = UInt32;
	CFOptionFlags = UInt32;
	CFHashCode = UInt32;
	CFIndex = SInt32;
	CFIndexPtr = ^CFIndex;
{$endc}

{ Base "type" of all "CF objects", and polymorphic functions on them }
type
	CFTypeRef = ^SInt32; { an opaque 32-bit type }

type
	CFStringRef = ^SInt32; { an opaque 32-bit type }
	CFStringRefPtr = ^CFStringRef;
	CFMutableStringRef = ^SInt32; { an opaque 32-bit type }
	CFMutableStringRefPtr = ^CFMutableStringRef;

{
        Type to mean any instance of a property list type;
        currently, CFString, CFData, CFNumber, CFBoolean, CFDate,
        CFArray, and CFDictionary.
}
type
	CFPropertyListRef = CFTypeRef;

{ Values returned from comparison functions }
	CFComparisonResult = SInt32;
const
	kCFCompareLessThan = -1;
	kCFCompareEqualTo = 0;
	kCFCompareGreaterThan = 1;

{ A standard comparison function }
type
	CFComparatorFunction = function( val1: {const} UnivPtr; val2: {const} UnivPtr; context: UnivPtr ): CFComparisonResult;

{ Constant used by some functions to indicate failed searches. }
{ This is of type CFIndex. }
const
	kCFNotFound = -1;


{ Range type }
type
	CFRangePtr = ^CFRange;
	CFRange = record
		location: CFIndex;
		length: CFIndex;
	end;

function CFRangeMake( loc: CFIndex; len: CFIndex ): CFRange; external name '___CFRangeMake';

{ Private; do not use }
function __CFRangeMake( loc: CFIndex; len: CFIndex ): CFRange; external name '___CFRangeMake';


{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
{ Null representant }

type
	CFNullRef = ^SInt32; { an opaque 32-bit type }

function CFNullGetTypeID: CFTypeID; external name '_CFNullGetTypeID';

var kCFNull: CFNullRef; external name '_kCFNull'; (* attribute const *)	// the singleton null instance

{#endif}


{ Allocator API

   Most of the time when specifying an allocator to Create functions, the NULL
   argument indicates "use the default"; this is the same as using kCFAllocatorDefault
   or the return value from CFAllocatorGetDefault().  This assures that you will use
   the allocator in effect at that time.

   You should rarely use kCFAllocatorSystemDefault, the default default allocator.
}
type
	CFAllocatorRef = ^SInt32; { an opaque 32-bit type }
	CFAllocatorRefPtr = ^CFAllocatorRef;

{ This is a synonym for NULL, if you'd rather use a named constant. }
var kCFAllocatorDefault: CFAllocatorRef; external name '_kCFAllocatorDefault'; (* attribute const *)

{ Default system allocator; you rarely need to use this. }
var kCFAllocatorSystemDefault: CFAllocatorRef; external name '_kCFAllocatorSystemDefault'; (* attribute const *)

{ This allocator uses malloc(), realloc(), and free(). This should not be
   generally used; stick to kCFAllocatorDefault whenever possible. This
   allocator is useful as the "bytesDeallocator" in CFData or
   "contentsDeallocator" in CFString where the memory was obtained as a
   result of malloc() type functions.
}
var kCFAllocatorMalloc: CFAllocatorRef; external name '_kCFAllocatorMalloc'; (* attribute const *)

{ This allocator explicitly uses the default malloc zone, returned by
   malloc_default_zone(). It should only be used when an object is
   safe to be allocated in non-scanned memory.
 }
var kCFAllocatorMallocZone: CFAllocatorRef; external name '_kCFAllocatorMallocZone'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{ Null allocator which does nothing and allocates no memory. This allocator
   is useful as the "bytesDeallocator" in CFData or "contentsDeallocator"
   in CFString where the memory should not be freed. 
}
var kCFAllocatorNull: CFAllocatorRef; external name '_kCFAllocatorNull'; (* attribute const *)

{ Special allocator argument to CFAllocatorCreate() which means
   "use the functions given in the context to allocate the allocator
   itself as well". 
}
var kCFAllocatorUseContext: CFAllocatorRef; external name '_kCFAllocatorUseContext'; (* attribute const *)

type
	CFAllocatorRetainCallBack = function( info: {const} UnivPtr ): UnivPtr;
	CFAllocatorReleaseCallBack = procedure( info: {const} UnivPtr );
	CFAllocatorCopyDescriptionCallBack = function( info: {const} UnivPtr ): CFStringRef;
	CFAllocatorAllocateCallBack = function( allocSize: CFIndex; hint: CFOptionFlags; info: UnivPtr ): UnivPtr;
	CFAllocatorReallocateCallBack = function( ptr: UnivPtr; newsize: CFIndex; hint: CFOptionFlags; info: UnivPtr ): UnivPtr;
	CFAllocatorDeallocateCallBack = procedure( ptr: UnivPtr; info: UnivPtr );
	CFAllocatorPreferredSizeCallBack = function( size: CFIndex; hint: CFOptionFlags; info: UnivPtr ): CFIndex;
	CFAllocatorContextPtr = ^CFAllocatorContext;
	CFAllocatorContext = record
		version: CFIndex;
		info: UnivPtr;
		retain: CFAllocatorRetainCallBack;
		release: CFAllocatorReleaseCallBack;        
		copyDescription: CFAllocatorCopyDescriptionCallBack;
		allocate: CFAllocatorAllocateCallBack;
		reallocate: CFAllocatorReallocateCallBack;
		deallocate: CFAllocatorDeallocateCallBack;
		preferredSize: CFAllocatorPreferredSizeCallBack;
	end;

function CFAllocatorGetTypeID: CFTypeID; external name '_CFAllocatorGetTypeID';

{
	CFAllocatorSetDefault() sets the allocator that is used in the current
	thread whenever NULL is specified as an allocator argument. This means
	that most, if not all allocations will go through this allocator. It
	also means that any allocator set as the default needs to be ready to
	deal with arbitrary memory allocation requests; in addition, the size
	and number of requests will change between releases.

	An allocator set as the default will never be released, even if later
	another allocator replaces it as the default. Not only is it impractical
	for it to be released (as there might be caches created under the covers
	that refer to the allocator), in general it's also safer and more
	efficient to keep it around.

	If you wish to use a custom allocator in a context, it's best to provide
	it as the argument to the various creation functions rather than setting
	it as the default. Setting the default allocator is not encouraged.

	If you do set an allocator as the default, either do it for all time in
	your app, or do it in a nested fashion (by restoring the previous allocator
	when you exit your context). The latter might be appropriate for plug-ins
	or libraries that wish to set the default allocator.
}
procedure CFAllocatorSetDefault( allocator: CFAllocatorRef ); external name '_CFAllocatorSetDefault';

function CFAllocatorGetDefault: CFAllocatorRef; external name '_CFAllocatorGetDefault';

function CFAllocatorCreate( allocator: CFAllocatorRef; var context: CFAllocatorContext ): CFAllocatorRef; external name '_CFAllocatorCreate';

function CFAllocatorAllocate( allocator: CFAllocatorRef; size: CFIndex; hint: CFOptionFlags ): UnivPtr; external name '_CFAllocatorAllocate';

function CFAllocatorReallocate( allocator: CFAllocatorRef; ptr: UnivPtr; newsize: CFIndex; hint: CFOptionFlags ): UnivPtr; external name '_CFAllocatorReallocate';

procedure CFAllocatorDeallocate( allocator: CFAllocatorRef; ptr: UnivPtr ); external name '_CFAllocatorDeallocate';

function CFAllocatorGetPreferredSizeForSize( allocator: CFAllocatorRef; size: CFIndex; hint: CFOptionFlags ): CFIndex; external name '_CFAllocatorGetPreferredSizeForSize';

procedure CFAllocatorGetContext( allocator: CFAllocatorRef; var context: CFAllocatorContext ); external name '_CFAllocatorGetContext';


{ Polymorphic CF functions }

function CFGetTypeID( cf: CFTypeRef ): CFTypeID; external name '_CFGetTypeID';

function CFCopyTypeIDDescription( type_id: CFTypeID ): CFStringRef; external name '_CFCopyTypeIDDescription';

function CFRetain( cf: CFTypeRef ): CFTypeRef; external name '_CFRetain';

procedure CFRelease( cf: CFTypeRef ); external name '_CFRelease';

function CFGetRetainCount( cf: CFTypeRef ): CFIndex; external name '_CFGetRetainCount';

function CFMakeCollectable( cf: CFTypeRef ): CFTypeRef; external name '_CFMakeCollectable';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

function CFEqual( cf1: CFTypeRef; cf2: CFTypeRef ): Boolean; external name '_CFEqual';

function CFHash( cf: CFTypeRef ): CFHashCode; external name '_CFHash';

function CFCopyDescription( cf: CFTypeRef ): CFStringRef; external name '_CFCopyDescription';

function CFGetAllocator( cf: CFTypeRef ): CFAllocatorRef; external name '_CFGetAllocator';


end.
