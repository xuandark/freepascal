{
     File:       HIToolbox/Dialogs.h
 
     Contains:   Dialog Manager interfaces.
 
     Version:    HIToolbox-219.4.81~2
 
     Copyright:  © 1985-2005 by Apple Computer, Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, August 2005 }
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

unit Dialogs;
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
uses MacTypes,CFBase,CarbonEventsCore,Quickdraw,MixedMode,Events,MacWindows,TextEdit,Controls,MacErrors,CarbonEvents;


{$ALIGN MAC68K}

const
{ new, more standard names for dialog item types}
	kControlDialogItem = 4;
	kButtonDialogItem = kControlDialogItem or 0;
	kCheckBoxDialogItem = kControlDialogItem or 1;
	kRadioButtonDialogItem = kControlDialogItem or 2;
	kResourceControlDialogItem = kControlDialogItem or 3;
	kStaticTextDialogItem = 8;
	kEditTextDialogItem = 16;
	kIconDialogItem = 32;
	kPictureDialogItem = 64;
	kUserDialogItem = 0;
	kHelpDialogItem = 1;
	kItemDisableBit = 128;

const
{ old names for dialog item types}
	ctrlItem = 4;
	btnCtrl = 0;
	chkCtrl = 1;
	radCtrl = 2;
	resCtrl = 3;
	statText = 8;
	editText = 16;
	iconItem = 32;
	picItem = 64;
	userItem = 0;
	itemDisable = 128;

const
{ standard dialog item numbers}
	kStdOkItemIndex = 1;
	kStdCancelItemIndex = 2;    { old names}
	ok = kStdOkItemIndex;
	cancel = kStdCancelItemIndex;

const
{ standard icon resource id's    }
	kStopIcon = 0;
	kNoteIcon = 1;
	kCautionIcon = 2;    { old names}
	stopIcon = kStopIcon;
	noteIcon = kNoteIcon;
	cautionIcon = kCautionIcon;



{  Dialog Item List Manipulation Constants }
type
	DITLMethod = SInt16;
const
	overlayDITL = 0;
	appendDITLRight = 1;
	appendDITLBottom = 2;

type
	StageList = SInt16;
{ DialogPtr is obsolete. Use DialogRef instead.}
type
	DialogRef = DialogPtr;

type
	DialogTemplatePtr = ^DialogTemplate;
	DialogTemplate = record
		boundsRect: Rect;
		procID: SInt16;
		visible: Boolean;
		filler1: Boolean;
		goAwayFlag: Boolean;
		filler2: Boolean;
		refCon: SInt32;
		itemsID: SInt16;
		title: Str255;
	end;
type
	DialogTPtr = DialogTemplatePtr;
type
	DialogTHndl = ^DialogTPtr;
type
	AlertTemplatePtr = ^AlertTemplate;
	AlertTemplate = record
		boundsRect: Rect;
		itemsID: SInt16;
		stages: StageList;
	end;
type
	AlertTPtr = AlertTemplatePtr;
type
	AlertTHndl = ^AlertTPtr;
{ new type abstractions for the dialog manager }
type
	DialogItemIndexZeroBased = SInt16;
type
	DialogItemIndex = SInt16;
type
	DialogItemType = SInt16;
{ dialog manager callbacks }
type
	SoundProcPtr = procedure( soundNumber: SInt16 );
type
	ModalFilterProcPtr = function( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: DialogItemIndex ): Boolean;
{ ModalFilterYDProcPtr was previously in StandardFile.h }
type
	ModalFilterYDProcPtr = function( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: SInt16; yourDataPtr: UnivPtr ): Boolean;
type
	UserItemProcPtr = procedure( theDialog: DialogRef; itemNo: DialogItemIndex );
type
	SoundUPP = SoundProcPtr;
type
	ModalFilterUPP = ModalFilterProcPtr;
type
	ModalFilterYDUPP = ModalFilterYDProcPtr;
type
	UserItemUPP = UserItemProcPtr;
{
 *  NewSoundUPP()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }

{
 *  NewModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewModalFilterUPP( userRoutine: ModalFilterProcPtr ): ModalFilterUPP; external name '_NewModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewModalFilterYDUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewModalFilterYDUPP( userRoutine: ModalFilterYDProcPtr ): ModalFilterYDUPP; external name '_NewModalFilterYDUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewUserItemUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewUserItemUPP( userRoutine: UserItemProcPtr ): UserItemUPP; external name '_NewUserItemUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSoundUPP()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }

{
 *  DisposeModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeModalFilterUPP( userUPP: ModalFilterUPP ); external name '_DisposeModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeModalFilterYDUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeModalFilterYDUPP( userUPP: ModalFilterYDUPP ); external name '_DisposeModalFilterYDUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeUserItemUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeUserItemUPP( userUPP: UserItemUPP ); external name '_DisposeUserItemUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSoundUPP()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }

{
 *  InvokeModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeModalFilterUPP( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: DialogItemIndex; userUPP: ModalFilterUPP ): Boolean; external name '_InvokeModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeModalFilterYDUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeModalFilterYDUPP( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: SInt16; yourDataPtr: UnivPtr; userUPP: ModalFilterYDUPP ): Boolean; external name '_InvokeModalFilterYDUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeUserItemUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeUserItemUPP( theDialog: DialogRef; itemNo: DialogItemIndex; userUPP: UserItemUPP ); external name '_InvokeUserItemUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
    ₯ Following types are valid with Appearance 1.0 and later
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
}
const
{ Alert types to pass into StandardAlert }
	kAlertStopAlert = 0;
	kAlertNoteAlert = 1;
	kAlertCautionAlert = 2;
	kAlertPlainAlert = 3;

type
	AlertType = SInt16;
const
	kAlertDefaultOKText = -1;   { "OK"}
	kAlertDefaultCancelText = -1;   { "Cancel"}
	kAlertDefaultOtherText = -1;    { "Don't Save"}

{ StandardAlert alert button numbers }
const
	kAlertStdAlertOKButton = 1;
	kAlertStdAlertCancelButton = 2;
	kAlertStdAlertOtherButton = 3;
	kAlertStdAlertHelpButton = 4;

const
{ Dialog Flags for use in NewFeaturesDialog or dlgx resource }
	kDialogFlagsUseThemeBackground = 1 shl 0;
	kDialogFlagsUseControlHierarchy = 1 shl 1;
	kDialogFlagsHandleMovableModal = 1 shl 2;
	kDialogFlagsUseThemeControls = 1 shl 3;

const
{ Alert Flags for use in alrx resource }
	kAlertFlagsUseThemeBackground = 1 shl 0;
	kAlertFlagsUseControlHierarchy = 1 shl 1;
	kAlertFlagsAlertIsMovable = 1 shl 2;
	kAlertFlagsUseThemeControls = 1 shl 3;

{ For dftb resource }
const
	kDialogFontNoFontStyle = 0;
	kDialogFontUseFontMask = $0001;
	kDialogFontUseFaceMask = $0002;
	kDialogFontUseSizeMask = $0004;
	kDialogFontUseForeColorMask = $0008;
	kDialogFontUseBackColorMask = $0010;
	kDialogFontUseModeMask = $0020;
	kDialogFontUseJustMask = $0040;
	kDialogFontUseAllMask = $00FF;
	kDialogFontAddFontSizeMask = $0100;
	kDialogFontUseFontNameMask = $0200;
	kDialogFontAddToMetaFontMask = $0400;

{ Also for dftb resource. This one is available in Mac OS X or later. }
{ It corresponds directly to kControlUseThemeFontIDMask from Controls.h. }
const
	kDialogFontUseThemeFontIDMask = $0080;

type
	AlertStdAlertParamRecPtr = ^AlertStdAlertParamRec;
	AlertStdAlertParamRec = record
		movable: Boolean;                { Make alert movable modal }
		helpButton: Boolean;             { Is there a help button? }
		filterProc: ModalFilterUPP;             { Event filter }
		defaultText: ConstStringPtr;            { Text for button in OK position }
		cancelText: ConstStringPtr;             { Text for button in cancel position }
		otherText: ConstStringPtr;              { Text for button in left position }
		defaultButton: SInt16;          { Which button behaves as the default }
		cancelButton: SInt16;           { Which one behaves as cancel (can be 0) }
		position: UInt16;               { Position (kWindowDefaultPosition in this case }
                                              { equals kWindowAlertPositionParentWindowScreen) }
	end;
type
	AlertStdAlertParamPtr = AlertStdAlertParamRecPtr;
const
	kHICommandOther = FourCharCode('othr'); { sent by standard sheet dialogs when the "other" button is pressed }

const
	kStdCFStringAlertVersionOne = 1;     { current version of AlertStdCFStringAlertParamRec }


{
 *  Summary:
 *    Flags to CreateStandardAlert that are specified in the
 *    AlertStdCFStringAlertParamRec.flags field.
 }
const
{
   * Applies to StandardSheet only. Do not dispose of the sheet window
   * after closing it; allows the sheet to be re-used again in a later
   * call to ShowSheetWindow.
   }
	kStdAlertDoNotDisposeSheet = 1 shl 0;

  {
   * Applies to StandardSheet only. Causes the sheet window to be
   * hidden immediately without animation effects when the default
   * button is chosen by the user.
   }
	kStdAlertDoNotAnimateOnDefault = 1 shl 1;

  {
   * Applies to StandardSheet only. Causes the sheet window to be
   * hidden immediately without animation effects when the cancel
   * button is chosen by the user.
   }
	kStdAlertDoNotAnimateOnCancel = 1 shl 2;

  {
   * Applies to StandardSheet only. Causes the sheet window to be
   * hidden immediately without animation effects when the other button
   * is chosen by the user.
   }
	kStdAlertDoNotAnimateOnOther = 1 shl 3;

  {
   * Allows dialog to stay up even after clicking the Help button.
   * Normally, it would close immediately. It is not necessary to set
   * this option for sheets, as they merely send the HICommandHelp
   * command to the target provided. RunStandardAlert will return with
   * the help button item in the itemHit parameter, but the window will
   * remain up. You can then perform whatever help function you wish
   * and then call RunStandardAlert again. This option is available in
   * Mac OS X 10.4 or later.
   }
	kStdAlertDoNotCloseOnHelp = 1 shl 4;

type
	AlertStdCFStringAlertParamRec = record
		version: UInt32;                { kStdCFStringAlertVersionOne }
		movable: Boolean;                { Make alert movable modal }
		helpButton: Boolean;             { Is there a help button? }
		defaultText: CFStringRef;            { Text for button in OK position }
		cancelText: CFStringRef;             { Text for button in cancel position }
		otherText: CFStringRef;              { Text for button in left position }
		defaultButton: SInt16;          { Which button behaves as the default }
		cancelButton: SInt16;           { Which one behaves as cancel (can be 0) }
		position: UInt16;               { Position (kWindowDefaultPosition in this case }
                                              { equals kWindowAlertPositionParentWindowScreen) }
		flags: OptionBits;                  { Options for the behavior of the alert or sheet }
	end;
type
	AlertStdCFStringAlertParamPtr = ^AlertStdCFStringAlertParamRec;
{ ΡΡΡ end Appearance 1.0 or later stuff}


{
    NOTE: Code running under MultiFinder or System 7.0 or newer
    should always pass NULL to InitDialogs.
}
{
 *  InitDialogs()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  ErrorSound()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  NewDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewDialog( dStorage: UnivPtr; const (*var*) boundsRect: Rect; const (*var*) title: Str255; visible: Boolean; procID: SInt16; behind: WindowRef; goAwayFlag: Boolean; refCon: SInt32; items: Handle ): DialogRef; external name '_NewDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNewDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetNewDialog( dialogID: SInt16; dStorage: UnivPtr; behind: WindowRef ): DialogRef; external name '_GetNewDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewColorDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewColorDialog( dStorage: UnivPtr; const (*var*) boundsRect: Rect; const (*var*) title: Str255; visible: Boolean; procID: SInt16; behind: WindowRef; goAwayFlag: Boolean; refCon: SInt32; items: Handle ): DialogRef; external name '_NewColorDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CloseDialog()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  DisposeDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DisposeDialog( theDialog: DialogRef ); external name '_DisposeDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ModalDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ModalDialog( modalFilter: ModalFilterUPP; var itemHit: DialogItemIndex ); external name '_ModalDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsDialogEvent()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function IsDialogEvent( const (*var*) theEvent: EventRecord ): Boolean; external name '_IsDialogEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DialogSelect()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function DialogSelect( const (*var*) theEvent: EventRecord; var theDialog: DialogRef; var itemHit: DialogItemIndex ): Boolean; external name '_DialogSelect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DrawDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DrawDialog( theDialog: DialogRef ); external name '_DrawDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  UpdateDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure UpdateDialog( theDialog: DialogRef; updateRgn: RgnHandle ); external name '_UpdateDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  HideDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure HideDialogItem( theDialog: DialogRef; itemNo: DialogItemIndex ); external name '_HideDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ShowDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ShowDialogItem( theDialog: DialogRef; itemNo: DialogItemIndex ); external name '_ShowDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FindDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function FindDialogItem( theDialog: DialogRef; thePt: Point ): DialogItemIndexZeroBased; external name '_FindDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DialogCut()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DialogCut( theDialog: DialogRef ); external name '_DialogCut';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DialogPaste()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DialogPaste( theDialog: DialogRef ); external name '_DialogPaste';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DialogCopy()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DialogCopy( theDialog: DialogRef ); external name '_DialogCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DialogDelete()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DialogDelete( theDialog: DialogRef ); external name '_DialogDelete';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Alert()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function Alert( alertID: SInt16; modalFilter: ModalFilterUPP ): DialogItemIndex; external name '_Alert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  StopAlert()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function StopAlert( alertID: SInt16; modalFilter: ModalFilterUPP ): DialogItemIndex; external name '_StopAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NoteAlert()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NoteAlert( alertID: SInt16; modalFilter: ModalFilterUPP ): DialogItemIndex; external name '_NoteAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CautionAlert()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function CautionAlert( alertID: SInt16; modalFilter: ModalFilterUPP ): DialogItemIndex; external name '_CautionAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure GetDialogItem( theDialog: DialogRef; itemNo: DialogItemIndex; var itemType: DialogItemType; var item: Handle; var box: Rect ); external name '_GetDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetDialogItem( theDialog: DialogRef; itemNo: DialogItemIndex; itemType: DialogItemType; item: Handle; const (*var*) box: Rect ); external name '_SetDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ParamText()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ParamText( const (*var*) param0: Str255; const (*var*) param1: Str255; const (*var*) param2: Str255; const (*var*) param3: Str255 ); external name '_ParamText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SelectDialogItemText()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SelectDialogItemText( theDialog: DialogRef; itemNo: DialogItemIndex; strtSel: SInt16; endSel: SInt16 ); external name '_SelectDialogItemText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogItemText()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure GetDialogItemText( item: Handle; var text: Str255 ); external name '_GetDialogItemText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogItemText()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetDialogItemText( item: Handle; const (*var*) text: Str255 ); external name '_SetDialogItemText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetAlertStage()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetAlertStage: SInt16; external name '_GetAlertStage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogFont()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetDialogFont( fontNum: SInt16 ); external name '_SetDialogFont';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ResetAlertStage()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ResetAlertStage; external name '_ResetAlertStage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ APIs in Carbon}
{
 *  GetParamText()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
procedure GetParamText( param0: StringPtr; param1: StringPtr; param2: StringPtr; param3: StringPtr ); external name '_GetParamText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  newdialog()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  newcolordialog()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  paramtext()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  getdialogitemtext()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  setdialogitemtext()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  finddialogitem()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }


{
 *  AppendDITL()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure AppendDITL( theDialog: DialogRef; theHandle: Handle; method: DITLMethod ); external name '_AppendDITL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CountDITL()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function CountDITL( theDialog: DialogRef ): DialogItemIndex; external name '_CountDITL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ShortenDITL()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ShortenDITL( theDialog: DialogRef; numberItems: DialogItemIndex ); external name '_ShortenDITL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InsertDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function InsertDialogItem( theDialog: DialogRef; afterItem: DialogItemIndex; itemType: DialogItemType; itemHandle: Handle; const (*var*) box: Rect ): OSStatus; external name '_InsertDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveDialogItems()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function RemoveDialogItems( theDialog: DialogRef; itemNo: DialogItemIndex; amountToRemove: DialogItemIndex; disposeItemData: Boolean ): OSStatus; external name '_RemoveDialogItems';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  StdFilterProc()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function StdFilterProc( theDialog: DialogRef; var event: EventRecord; var itemHit: DialogItemIndex ): Boolean; external name '_StdFilterProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetStdFilterProc()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetStdFilterProc( var theProc: ModalFilterUPP ): OSErr; external name '_GetStdFilterProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogDefaultItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function SetDialogDefaultItem( theDialog: DialogRef; newItem: DialogItemIndex ): OSErr; external name '_SetDialogDefaultItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogCancelItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function SetDialogCancelItem( theDialog: DialogRef; newItem: DialogItemIndex ): OSErr; external name '_SetDialogCancelItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDialogTracksCursor()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function SetDialogTracksCursor( theDialog: DialogRef; tracks: Boolean ): OSErr; external name '_SetDialogTracksCursor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
    ₯ Appearance Dialog Routines (available only with Appearance 1.0 and later)
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
}

{
 *  NewFeaturesDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function NewFeaturesDialog( inStorage: UnivPtr; const (*var*) inBoundsRect: Rect; const (*var*) inTitle: Str255; inIsVisible: Boolean; inProcID: SInt16; inBehind: WindowRef; inGoAwayFlag: Boolean; inRefCon: SInt32; inItemListHandle: Handle; inFlags: UInt32 ): DialogRef; external name '_NewFeaturesDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AutoSizeDialog()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function AutoSizeDialog( inDialog: DialogRef ): OSErr; external name '_AutoSizeDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Regarding StandardAlert and constness:
    Even though the inAlertParam parameter is marked const here, there was
    a chance Dialog Manager would modify it on versions of Mac OS prior to 9.
}
{
 *  StandardAlert()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function StandardAlert( inAlertType: AlertType; const (*var*) inError: Str255; const (*var*) inExplanation: Str255; {const} inAlertParam: AlertStdAlertParamRecPtr { can be NULL }; var outItemHit: SInt16 ): OSErr; external name '_StandardAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ CFString-based StandardAlert and StandardSheet APIs are only available on Mac OS X and later}

{
 *  GetStandardAlertDefaultParams()
 *  
 *  Summary:
 *    Fills out an AlertStdCFStringAlertParamRec with default values: -
 *      not movable -   no help button -   default button with title
 *    kAlertDefaultOKText, meaning "OK" -   no cancel or other buttons
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    param:
 *      The parameter block to initialize.
 *    
 *    version:
 *      The parameter block version; pass kStdCFStringAlertVersionOne.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetStandardAlertDefaultParams( param: AlertStdCFStringAlertParamPtr; version: UInt32 ): OSStatus; external name '_GetStandardAlertDefaultParams';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateStandardAlert()
 *  
 *  Summary:
 *    Creates an alert containing standard elements and using standard
 *    formatting rules.
 *  
 *  Discussion:
 *    CreateStandardAlert should be used in conjunction with
 *    RunStandardAlert. After CreateStandardAlert returns, the alert is
 *    still invisible. RunStandardAlert will show the alert and run a
 *    modal dialog loop to process events in the alert. 
 *    
 *    The strings passed to this API in the error, explanation, and
 *    AlertStdCFStringAlertParamRec button title parameters will all be
 *    retained during the creation of the alert, and released when the
 *    alert is disposed by RunStandardAlert. There is no net change to
 *    the refcount of these strings across CreateStandardAlert and
 *    RunStandardAlert.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    alertType:
 *      The type of alert to create.
 *    
 *    error:
 *      The error string to display. CreateStandardAlert increments the
 *      refcount on this string, so you may release it after
 *      CreateStandardAlert returns if you don't need it later.
 *    
 *    explanation:
 *      The explanation string to display. May be NULL or empty to
 *      display no explanation. CreateStandardAlert increments the
 *      refcount on this string, so you may release it after
 *      CreateStandardAlert returns if you don't need it later.
 *    
 *    param:
 *      The parameter block describing how to create the alert. May be
 *      NULL. CreateStandardAlert increments the refcount on the button
 *      title strings in the parameter block, so you may release them
 *      after CreateStandardAlert returns if you don't need them later.
 *    
 *    outAlert:
 *      On exit, contains the new alert.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function CreateStandardAlert( alertType_: AlertType; error: CFStringRef; explanation: CFStringRef { can be NULL }; {const} param: AlertStdCFStringAlertParamPtr { can be NULL }; var outAlert: DialogRef ): OSStatus; external name '_CreateStandardAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RunStandardAlert()
 *  
 *  Summary:
 *    Shows, runs, and destroys a standard alert using a modal dialog
 *    loop.
 *  
 *  Discussion:
 *    RunStandardAlert displays and runs an alert created by
 *    CreateStandardAlert. It handles all user interaction with the
 *    alert. After the user has dismissed the alert, RunStandardAlert
 *    destroys the alert dialog; the DialogRef will be invalid after
 *    RunStandardAlert returns. DO NOT call DisposeDialog. 
 *    
 *    NOTE: DO NOT call this function for a dialog that was not created
 *    with CreateStandardAlert! You will sorely regret it, I promise
 *    you.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inAlert:
 *      The alert to display.
 *    
 *    filterProc:
 *      An event filter function for handling events that do not apply
 *      to the alert. May be NULL.
 *    
 *    outItemHit:
 *      On exit, contains the item index of the button that was pressed
 *      to close the alert.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function RunStandardAlert( inAlert: DialogRef; filterProc: ModalFilterUPP { can be NULL }; var outItemHit: DialogItemIndex ): OSStatus; external name '_RunStandardAlert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateStandardSheet()
 *  
 *  Summary:
 *    Creates an alert containing standard elements and using standard
 *    formatting rules, and prepares it to be displayed as a sheet.
 *  
 *  Discussion:
 *    CreateStandardSheet should be used in conjunction with
 *    ShowSheetWindow. After CreateStandardSheet returns, the alert is
 *    still invisible. ShowSheetWindow will show the alert and then
 *    return. Events in the sheet are handled asynchronously; the
 *    application should be prepared for the sheet window to be part of
 *    its windowlist while running its own event loop. When a button in
 *    the sheet is pressed, the EventTargetRef passed to
 *    CreateStandardSheet will receive a command event with one of the
 *    command IDs kHICommandOK, kHICommandCancel, or kHICommandOther.
 *    The sheet is hidden and the sheet dialog destroyed before the
 *    command is sent; the caller does not have to call HideSheetWindow
 *    or DisposeDialog. 
 *    
 *    If the caller needs to destroy the sheet before showing it, then
 *    it is sufficient to call DisposeDialog on the sheet. This is the
 *    only case in which the caller would need to destroy the sheet
 *    explicitly. 
 *    
 *    The strings passed to this API in the error, explanation, and
 *    AlertStdCFStringAlertParamRec button title parameters will all be
 *    retained during the creation of the sheet, and released when the
 *    sheet is disposed. There is no net change to the refcount of
 *    these strings across CreateStandardSheet and sheet destruction.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    alertType:
 *      The type of alert to create.
 *    
 *    error:
 *      The error string to display. CreateStandardSheet increments the
 *      refcount on this string, so you may release it after
 *      CreateStandardSheet returns if you don't need it later.
 *    
 *    explanation:
 *      The explanation string to display. May be NULL or empty to
 *      display no explanation. CreateStandardSheet increments the
 *      refcount on this string, so you may release it after
 *      CreateStandardSheet returns if you don't need it later.
 *    
 *    param:
 *      The parameter block describing how to create the alert. May be
 *      NULL. CreateStandardSheet increments the refcount on the button
 *      title strings in the parameter block, so you may release them
 *      after CreateStandardSheet returns if you don't need them later.
 *    
 *    notifyTarget:
 *      The event target to be notified when the sheet is closed. The
 *      caller should install an event handler on this target for the
 *      [kEventClassCommand, kEventProcessCommand] event. May be NULL
 *      if the caller does not need the command event to be sent to any
 *      target. 
 *      
 *      Typically, this will be the event target for the parent window
 *      of the sheet; a standard practice is to install a handler on
 *      the parent window just before showing the sheet window, and to
 *      remove the handler from the parent window after the sheet has
 *      been closed. It is also possible to install a handler on the
 *      sheet window itself, in which case you would pass NULL for this
 *      parameter, since the command event is automatically sent to the
 *      sheet window already. If you install a handler on the sheet
 *      itself, make sure to return eventNotHandledErr from your
 *      handler, because CreateStandardSheet installs its own handler
 *      on the sheet and that handler must be allowed to run to close
 *      the sheet window and release the DialogRef.
 *    
 *    outSheet:
 *      On exit, contains the new alert.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function CreateStandardSheet( alertType_: AlertType; error: CFStringRef; explanation: CFStringRef { can be NULL }; {const} param: AlertStdCFStringAlertParamPtr { can be NULL }; notifyTarget: EventTargetRef { can be NULL }; var outSheet: DialogRef ): OSStatus; external name '_CreateStandardSheet';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CloseStandardSheet()
 *  
 *  Summary:
 *    Closes a standard sheet dialog and releases the dialog data
 *    structures.
 *  
 *  Discussion:
 *    CloseStandardSheet is meant to be used when you need to remove a
 *    sheet because of a higher-priority request to close the sheet's
 *    document window. For example, you might have a Save Changes sheet
 *    open on a document window. Meanwhile, the user drags the document
 *    into the trash. When your application sees that the document has
 *    been moved to the trash, it knows that it should close the
 *    document window, but first it needs to close the sheet. 
 *    
 *    CloseStandardSheet should not be used by your Carbon event
 *    handler in response to a click in one of the sheet buttons; the
 *    Dialog Manager will close the sheet automatically in that case.
 *    
 *    
 *    If kStdAlertDoNotDisposeSheet was specified when the sheet was
 *    created, the sheet dialog will be hidden but not released, and
 *    you can reuse the sheet later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inSheet:
 *      The sheet to close.
 *    
 *    inResultCommand:
 *      This command, if not zero, will be sent to the EventTarget
 *      specified when the sheet was created.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function CloseStandardSheet( inSheet: DialogRef; inResultCommand: UInt32 ): OSStatus; external name '_CloseStandardSheet';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogItemAsControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetDialogItemAsControl( inDialog: DialogRef; inItemNo: SInt16; var outControl: ControlRef ): OSErr; external name '_GetDialogItemAsControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MoveDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function MoveDialogItem( inDialog: DialogRef; inItemNo: SInt16; inHoriz: SInt16; inVert: SInt16 ): OSErr; external name '_MoveDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SizeDialogItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SizeDialogItem( inDialog: DialogRef; inItemNo: SInt16; inWidth: SInt16; inHeight: SInt16 ): OSErr; external name '_SizeDialogItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AppendDialogItemList()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in DialogsLib 8.5 and later
 }
function AppendDialogItemList( dialog: DialogRef; ditlID: SInt16; method: DITLMethod ): OSErr; external name '_AppendDialogItemList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
    ₯ Dialog Routines available only with Appearance 1.1 (Mac OS 8.5) and later
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
}

{
 *  SetDialogTimeout()
 *  
 *  Summary:
 *    Sets the timeout for a modal dialog.
 *  
 *  Discussion:
 *    SetDialogTimeout sets the delay after which a dialog will be
 *    automatically dismissed. When SetDialogTimeout is called, the
 *    Dialog Manager takes the current time, adds the timeout to it,
 *    and stores the result as the time to dismiss the dialog. If the
 *    dismissal time is reached, the dialog is automatically closed and
 *    the specified dialog item index is returned from ModalDialog in
 *    the itemHit parameter. If the user moves the mouse or presses a
 *    key, the dismissal time is reset by adding the original timeout
 *    to the time of the event. Only the ModalDialog API observes the
 *    timeout value; if you are handling events in a modeless dialog or
 *    sheet using IsDialogEvent and DialogSelect, the timeout will be
 *    ignored.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inDialog:
 *      The dialog on which to set a timeout.
 *    
 *    inButtonToPress:
 *      The dialog item index that should be returned from ModalDialog
 *      when the timeout expires.
 *    
 *    inSecondsToWait:
 *      The time to wait before dismissing the dialog, in seconds.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in DialogsLib 8.5 and later
 }
function SetDialogTimeout( inDialog: DialogRef; inButtonToPress: SInt16; inSecondsToWait: UInt32 ): OSStatus; external name '_SetDialogTimeout';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogTimeout()
 *  
 *  Summary:
 *    Retrieves the timeout for a modal dialog.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inDialog:
 *      The dialog from which to retrieve the timeout.
 *    
 *    outButtonToPress:
 *      On exit, contains the dialog item index that should be returned
 *      from ModalDialog when the dialog is dismissed. May be NULL if
 *      you do not need this information.
 *    
 *    outSecondsToWait:
 *      On exit, contains the time to wait before dismissing the
 *      dialog, in seconds. May be NULL if you do not need this
 *      information.
 *    
 *    outSecondsRemaining:
 *      On exit, contains the time until the dialog is dismissed, in
 *      seconds. May be NULL if you do not need this information.
 *  
 *  Result:
 *    An operating system result code. Returns dialogNoTimeoutErr if no
 *    timeout has been set for this dialog.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in DialogsLib 8.5 and later
 }
function GetDialogTimeout( inDialog: DialogRef; outButtonToPress: SInt16Ptr { can be NULL }; outSecondsToWait: UInt32Ptr { can be NULL }; outSecondsRemaining: UInt32Ptr { can be NULL } ): OSStatus; external name '_GetDialogTimeout';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetModalDialogEventMask()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in DialogsLib 8.5 and later
 }
function SetModalDialogEventMask( inDialog: DialogRef; inMask: EventMask ): OSStatus; external name '_SetModalDialogEventMask';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetModalDialogEventMask()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in DialogsLib 8.5 and later
 }
function GetModalDialogEventMask( inDialog: DialogRef; var outMask: EventMask ): OSStatus; external name '_GetModalDialogEventMask';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
    ₯ Accessor functions
  ΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡΡ
}


{
 *  GetDialogWindow()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogWindow( dialog: DialogRef ): WindowRef; external name '_GetDialogWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogTextEditHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogTextEditHandle( dialog: DialogRef ): TEHandle; external name '_GetDialogTextEditHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogDefaultItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogDefaultItem( dialog: DialogRef ): SInt16; external name '_GetDialogDefaultItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogCancelItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogCancelItem( dialog: DialogRef ): SInt16; external name '_GetDialogCancelItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogKeyboardFocusItem()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogKeyboardFocusItem( dialog: DialogRef ): SInt16; external name '_GetDialogKeyboardFocusItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetPortDialogPort()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
procedure SetPortDialogPort( dialog: DialogRef ); external name '_SetPortDialogPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogPort()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogPort( dialog: DialogRef ): CGrafPtr; external name '_GetDialogPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDialogFromWindow()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later or as macro/inline
 }
function GetDialogFromWindow( window: WindowRef ): DialogRef; external name '_GetDialogFromWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CouldDialog()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }


{
 *  FreeDialog()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }


{
 *  CouldAlert()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }


{
 *  FreeAlert()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }

(*
#if OLDROUTINENAMES
#define DisposDialog(theDialog) DisposeDialog(theDialog)
#define UpdtDialog(theDialog, updateRgn) UpdateDialog(theDialog, updateRgn)
#define GetDItem(theDialog, itemNo, itemType, item, box) GetDialogItem(theDialog, itemNo, itemType, item, box)
#define SetDItem(theDialog, itemNo, itemType, item, box) SetDialogItem(theDialog, itemNo, itemType, item, box)
#define HideDItem(theDialog, itemNo) HideDialogItem(theDialog, itemNo)
#define ShowDItem(theDialog, itemNo) ShowDialogItem(theDialog, itemNo)
#define SelIText(theDialog, itemNo, strtSel, endSel) SelectDialogItemText(theDialog, itemNo, strtSel, endSel)
#define GetIText(item, text) GetDialogItemText(item, text)
#define SetIText(item, text) SetDialogItemText(item, text)
#define FindDItem(theDialog, thePt) FindDialogItem(theDialog, thePt)
#define NewCDialog(dStorage, boundsRect, title, visible, procID, behind, goAwayFlag, refCon, items) \
NewColorDialog(dStorage, boundsRect, title, visible, procID, behind, goAwayFlag, refCon, items)
#define GetAlrtStage() GetAlertStage()
#define ResetAlrtStage() ResetAlertStage()
#define DlgCut(theDialog) DialogCut(theDialog)
#define DlgPaste(theDialog) DialogPaste(theDialog)
#define DlgCopy(theDialog) DialogCopy(theDialog)
#define DlgDelete(theDialog) DialogDelete(theDialog)
#define SetDAFont(fontNum) SetDialogFont(fontNum)
#define SetGrafPortOfDialog(dialog) SetPortDialogPort(dialog)
#endif  { OLDROUTINENAMES }
*)



end.
