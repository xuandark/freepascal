{
     File:       HIToolbox/TranslationExtensions.h
 
     Contains:   Macintosh Easy Open Translation Extension Interfaces.
 
     Version:    HIToolbox-219.4.81~2
 
     Copyright:  � 1993-2005 by Apple Computer, Inc., all rights reserved.
 
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

unit TranslationExtensions;
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
uses MacTypes,Files,Quickdraw,Components;


{$ALIGN MAC68K}

{
   Translation Extensions are no longer supported. Carbon clients interested in extending translations
   should use filter services as described in TranslationServices.h.  The definitions below will NOT work
   for Carbon and are only defined for those files that need to build pre-Carbon applications.
}
const
	kSupportsFileTranslation = 1;
	kSupportsScrapTranslation = 2;
	kTranslatorCanGenerateFilename = 4;

{****************************************************************************************}
{ better names for 4-char codes}
type
	FileType = OSType;
	FileTypePtr = ^FileType;
	ScrapType = ResType;
{****************************************************************************************}
type
	TranslationAttributes = UInt32;
const
	taDstDocNeedsResourceFork = 1;
	taDstIsAppTranslation = 2;

{****************************************************************************************}
type
	FileTypeSpecPtr = ^FileTypeSpec;
	FileTypeSpec = record
		format: FileType;
		hint: SInt32;
		flags: TranslationAttributes;               { taDstDocNeedsResourceFork, taDstIsAppTranslation}
		catInfoType: OSType;
		catInfoCreator: OSType;
	end;
type
	FileTranslationList = record
		modDate: UInt32;
		groupCount: UInt32;

                                              { conceptual declarations:}

                                              {    unsigned long group1SrcCount;}
                                              {    unsigned long group1SrcEntrySize = sizeof(FileTypeSpec);}
                                              {  FileTypeSpec  group1SrcTypes[group1SrcCount]}
                                              {  unsigned long group1DstCount;}
                                              {  unsigned long group1DstEntrySize = sizeof(FileTypeSpec);}
                                              {  FileTypeSpec  group1DstTypes[group1DstCount]}
	end;
	FileTranslationListPtr = ^FileTranslationList;
	FileTranslationListHandle = ^FileTranslationListPtr;
{****************************************************************************************}
type
	ScrapTypeSpecPtr = ^ScrapTypeSpec;
	ScrapTypeSpec = record
		format: ScrapType;
		hint: SInt32;
	end;
type
	ScrapTranslationList = record
		modDate: UInt32;
		groupCount: UInt32;

                                              { conceptual declarations:}

                                              {    unsigned long     group1SrcCount;}
                                              {    unsigned long     group1SrcEntrySize = sizeof(ScrapTypeSpec);}
                                              {  ScrapTypeSpec     group1SrcTypes[group1SrcCount]}
                                              {  unsigned long     group1DstCount;}
                                              {    unsigned long     group1DstEntrySize = sizeof(ScrapTypeSpec);}
                                              {  ScrapTypeSpec     group1DstTypes[group1DstCount]}
	end;
	ScrapTranslationListPtr = ^ScrapTranslationList;
	ScrapTranslationListHandle = ^ScrapTranslationListPtr;
{******************************************************************************************

    definition of callbacks to update progress dialog

******************************************************************************************}
type
	TranslationRefNum = SInt32;
{******************************************************************************************

    This routine sets the advertisement in the top half of the progress dialog.
    It is called once at the beginning of your DoTranslateFile routine.

    Enter   :   refNum          Translation reference supplied to DoTranslateFile.
                advertisement   A handle to the picture to display.  This must be non-purgable.
                                Before returning from DoTranslateFile, you should dispose
                                of the memory.  (Normally, it is in the temp translation heap
                                so it is cleaned up for you.)

    Exit    :   returns         noErr, paramErr, or memFullErr

******************************************************************************************}
{
 *  SetTranslationAdvertisement()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    There is no direct replacement at this time.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.3
 *    CarbonLib:        in CarbonLib 1.0 thru 1.0.2
 *    Non-Carbon CFM:   in Translation 1.0 and later
 }
function SetTranslationAdvertisement( refNum: TranslationRefNum; advertisement: PicHandle ): OSErr; external name '_SetTranslationAdvertisement';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_3 *)


{******************************************************************************************

    This routine updates the progress bar in the progress dialog.
    It is called repeatedly from within your DoTranslateFile routine.
    It should be called often, so that the user will get feedback if
    he tries to cancel.

    Enter   :   refNum      translation reference supplied to DoTranslateFile.
                progress    percent complete (0-100)

    Exit    :   canceled    TRUE if the user clicked the Cancel button, FALSE otherwise

    Return  :   noErr, paramErr, or memFullErr

******************************************************************************************}
{
 *  UpdateTranslationProgress()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    There is no direct replacement at this time.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.3
 *    CarbonLib:        in CarbonLib 1.0 thru 1.0.2
 *    Non-Carbon CFM:   in Translation 1.0 and later
 }
function UpdateTranslationProgress( refNum: TranslationRefNum; percentDone: SInt16; var canceled: Boolean ): OSErr; external name '_UpdateTranslationProgress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_3 *)


{******************************************************************************************

    Component Manager component selectors for translation extension routines

******************************************************************************************}
const
	kTranslateGetFileTranslationList = 0;
	kTranslateIdentifyFile = 1;
	kTranslateTranslateFile = 2;
	kTranslateGetTranslatedFilename = 3;
	kTranslateGetScrapTranslationList = 10;
	kTranslateIdentifyScrap = 11;
	kTranslateTranslateScrap = 12;
	kTranslateGetScrapTranslationListConsideringData = 13;


{******************************************************************************************

    routines which implement translation extensions

******************************************************************************************}
type
	DoGetFileTranslationListProcPtr = function( self: ComponentInstance; translationList: FileTranslationListHandle ): ComponentResult;
	DoIdentifyFileProcPtr = function( self: ComponentInstance; const (*var*) theDocument: FSSpec; var docType: FileType ): ComponentResult;
	DoTranslateFileProcPtr = function( self: ComponentInstance; refNum: TranslationRefNum; const (*var*) sourceDocument: FSSpec; srcType: FileType; srcTypeHint: SInt32; const (*var*) dstDoc: FSSpec; dstType: FileType; dstTypeHint: SInt32 ): ComponentResult;
	DoGetTranslatedFilenameProcPtr = function( self: ComponentInstance; dstType: FileType; dstTypeHint: SInt32; var theDocument: FSSpec ): ComponentResult;
	DoGetScrapTranslationListProcPtr = function( self: ComponentInstance; list: ScrapTranslationListHandle ): ComponentResult;
	DoIdentifyScrapProcPtr = function( self: ComponentInstance; dataPtr: {const} UnivPtr; dataLength: Size; var dataFormat: ScrapType ): ComponentResult;
	DoTranslateScrapProcPtr = function( self: ComponentInstance; refNum: TranslationRefNum; srcDataPtr: {const} UnivPtr; srcDataLength: Size; srcType: ScrapType; srcTypeHint: SInt32; dstData: Handle; dstType: ScrapType; dstTypeHint: SInt32 ): ComponentResult;



end.
