//
//  ABPeoplePickerC.h
//  AddressBook Framework
//
//  Copyright (c) 2003 Apple Computer. All rights reserved.
//
{	  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }


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

unit ABPeoplePicker;
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
uses MacTypes,ABAddressBook,CFBase,CFArray,CGGeometry,Drag,HIObjectCore,HIGeometry;
{$ALIGN MAC68K}

type
	ABPickerRef							= ^SInt32;

{
 * Picker creation and manipulation
 }

// Creates an ABPickerRef. Release with CFRelease(). The window is created hidden. Call
// ABPickerSetVisibility() to show it.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCreate: ABPickerRef; external name '_ABPickerCreate';

// Change the structural frame of the window.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSetFrame( inPicker: ABPickerRef; const (*var*) inFrame: HIRect ); external name '_ABPickerSetFrame';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerGetFrame( inPicker: ABPickerRef; var outFrame: HIRect ); external name '_ABPickerGetFrame';

// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSetVisibility( inPicker: ABPickerRef; visible: Boolean ); external name '_ABPickerSetVisibility';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerIsVisible( inPicker: ABPickerRef ): Boolean; external name '_ABPickerIsVisible';

{
 * Look and Feel
 }

const
    // Choose the selection behavior for the value column. If multiple behaviors are selected,
    // the most restrictive behavior will be used. Defaults to kABPickerSingleValueSelection set
    // to TRUE.
    kABPickerSingleValueSelection   = 1 shl 0; // Allow user to choose a single value for a person.
    kABPickerMultipleValueSelection = 1 shl 1; // Allow user to choose multiple values for a person.

    // Allow the user to select entire groups in the group column. If false, at least one
    // person in the group will be selected. Defaults to FALSE.
    kABPickerAllowGroupSelection    = 1 shl 2;

    // Allow the user to select more than one group/record at a time. Defaults to TRUE.
    kABPickerAllowMultipleSelection = 1 shl 3;

type ABPickerAttributes = OptionBits;

// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerGetAttributes( inPicker: ABPickerRef ): ABPickerAttributes; external name '_ABPickerGetAttributes';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerChangeAttributes( inPicker: ABPickerRef; inAttributesToSet: ABPickerAttributes; inAttributesToClear: ABPickerAttributes ); external name '_ABPickerChangeAttributes';

{
 * Value column
 }

    // These methods control what data (if any) is shown in the values column. The column will only
    // display if an AB property is added. A popup button in the column header will be used if more
    // than one property is added. Titles for built in properties will localized automatically. A
    // list of AB properties can be found in <AddressBook/ABGlobals.h>.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerAddProperty( inPicker: ABPickerRef; inProperty: CFStringRef ); external name '_ABPickerAddProperty';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerRemoveProperty( inPicker: ABPickerRef; inProperty: CFStringRef ); external name '_ABPickerRemoveProperty';
    // Returns an array of AB Properties as CFStringRefs.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopyProperties( inPicker: ABPickerRef ): CFArrayRef; external name '_ABPickerCopyProperties';

    // Localized titles for third party properties should be set with these methods.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSetColumnTitle( inPicker: ABPickerRef; inTitle: CFStringRef; inProperty: CFStringRef ); external name '_ABPickerSetColumnTitle';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopyColumnTitle( inPicker: ABPickerRef; inProperty: CFStringRef ): CFStringRef; external name '_ABPickerCopyColumnTitle';

    // Display one of the properties added above in the values column.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSetDisplayedProperty( inPicker: ABPickerRef; inProperty: CFStringRef ); external name '_ABPickerSetDisplayedProperty';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopyDisplayedProperty( inPicker: ABPickerRef ): CFStringRef; external name '_ABPickerCopyDisplayedProperty';

{
 * Selection
 }

    // Returns group column selection as an array of ABGroupRef objects.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopySelectedGroups( inPicker: ABPickerRef ): CFArrayRef; external name '_ABPickerCopySelectedGroups';

    // Returns names column selection as an array of ABGroupRef or ABPersonRef objects.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopySelectedRecords( inPicker: ABPickerRef ): CFArrayRef; external name '_ABPickerCopySelectedRecords';

    // This method returns an array of selected multi-value identifiers. Returns nil if the displayed
    // property is a single value type.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopySelectedIdentifiers( inPicker: ABPickerRef; inPerson: ABPersonRef ): CFArrayRef; external name '_ABPickerCopySelectedIdentifiers';

    // Returns an array containing CFStringRefs for each item selected in the values column.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerCopySelectedValues( inPicker: ABPickerRef ): CFArrayRef; external name '_ABPickerCopySelectedValues';

    // Select group/name/value programatically.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSelectGroup( inPicker: ABPickerRef; inGroup: ABGroupRef; inExtendSelection: Boolean ); external name '_ABPickerSelectGroup';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSelectRecord( inPicker: ABPickerRef; inRecord: ABRecordRef; inExtendSelection: Boolean ); external name '_ABPickerSelectRecord';
    // Individual values contained within an multi-value property can be selected with this method.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSelectIdentifier( inPicker: ABPickerRef; inPerson: ABPersonRef; inIdentifier: CFStringRef; inExtendSelection: Boolean ); external name '_ABPickerSelectIdentifier';

    // Remove selection
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerDeselectGroup( inPicker: ABPickerRef; inGroup: ABGroupRef ); external name '_ABPickerDeselectGroup';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerDeselectRecord( inPicker: ABPickerRef; inRecord: ABRecordRef ); external name '_ABPickerDeselectRecord';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerDeselectIdentifier( inPicker: ABPickerRef; inPerson: ABPersonRef; inIdentifier: CFStringRef ); external name '_ABPickerDeselectIdentifier';

// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerDeselectAll( inPicker: ABPickerRef ); external name '_ABPickerDeselectAll';

{
 * Events and Actions
 *
 * Your delegate will be notified when the user changes the selection or displayed property of the picker.
 * Picker events have an event class of kEventClassABPeoplePicker and one of the kinds listed below. Picker
 * events contain an event parameter which contains the ABPickerRef. To obtain this:
 *
 * GetEventParameter(inEvent, kEventParamABPickerRef,
 *                   typeCFTypeRef, NULL, sizeof(ABPickerRef),
 *                   NULL, &outPickerRef);
 *
 }

const
    // Carbon Event class for People Picker
    kEventClassABPeoplePicker = FourCharCode('abpp');

const
    // Carbon Event kinds for People Picker
    kEventABPeoplePickerGroupSelectionChanged     = 1;
    kEventABPeoplePickerNameSelectionChanged      = 2;
    kEventABPeoplePickerValueSelectionChanged     = 3;
    kEventABPeoplePickerDisplayedPropertyChanged  = 4;

    kEventABPeoplePickerGroupDoubleClicked        = 5;
    kEventABPeoplePickerNameDoubleClicked         = 6;

const
    // Carbon Event parameter name
    kEventParamABPickerRef	=  FourCharCode('abpp');

    // Set the event handler for People Picker events.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSetDelegate( inPicker: ABPickerRef; inDelegate: HIObjectRef ); external name '_ABPickerSetDelegate';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
function ABPickerGetDelegate( inPicker: ABPickerRef ): HIObjectRef; external name '_ABPickerGetDelegate';

    // Clear the search field and reset the list of displayed names.
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerClearSearchField( inPicker: ABPickerRef ); external name '_ABPickerClearSearchField';

    // Launch AddressBook and edit the current selection
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerEditInAddressBook( inPicker: ABPickerRef ); external name '_ABPickerEditInAddressBook';
// AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
procedure ABPickerSelectInAddressBook( inPicker: ABPickerRef ); external name '_ABPickerSelectInAddressBook';

end.
