{
     File:       HIToolbox/HIGeometry.h
 
     Contains:   HIToolbox interfaces for geometry
 
     Version:    HIToolbox-219.4.81~2
 
     Copyright:  � 1984-2005 by Apple Computer, Inc., all rights reserved.
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{       Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, August 2005 }
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

unit HIGeometry;
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
uses MacTypes,CGGeometry;


{$ALIGN MAC68K}


{
 *  HIPoint
 *  
 *  Discussion:
 *    HIPoint is a new, floating point-based type to help express
 *    coordinates in a much richer fashion than the classic QuickDraw
 *    points. It will, in time, be more heavily used throughout the
 *    Toolbox. For now, it is replacing our use of typeQDPoint in mouse
 *    events. This is to better support sub-pixel tablet coordinates.
 *    If you ask for a mouse location with typeQDPoint, and the point
 *    is actually stored as typeHIPoint, it will automatically be
 *    coerced to typeQDPoint for you, so this change should be largely
 *    transparent to applications. HIPoints are in screen space, i.e.
 *    the top left of the screen is 0, 0.
 }
type
	HIPoint = CGPoint;
	HIPointPtr = ^HIPoint;

{
 *  HISize
 *  
 *  Discussion:
 *    HISize is a floating point-based type to help express dimensions
 *    in a much richer fashion than the classic QuickDraw coordinates.
 }
type
	HISize = CGSize;
	HISizePtr = ^HISize;

{
 *  HIRect
 *  
 *  Discussion:
 *    HIRect is a new, floating point-based type to help express
 *    rectangles in a much richer fashion than the classic QuickDraw
 *    rects. It will, in time, be more heavily used throughout the
 *    Toolbox. HIRects are in screen space, i.e. the top left of the
 *    screen is 0, 0.
 }
type
	HIRect = CGRect;
	HIRectPtr = ^HIRect;
{
 *  HIGetScaleFactor()
 *  
 *  Discussion:
 *    Returns the resolution independence scale factor.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Result:
 *    A float indicating the resolution independence scale factor.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIGetScaleFactor: Float32; external name '_HIGetScaleFactor';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HICoordinateSpace
 *  
 *  Summary:
 *    Coordinate spaces for use with HIPointConvert, HIRectConvert, and
 *    HISizeConvert.
 }
type
	HICoordinateSpace = UInt32;
const
{
   * The coordinate space defined by the position and sizes of the
   * screen GDevices. More correctly, this is a 72 DPI coordinate space
   * covering the screens. When the scale factor is not 1.0, this is
   * the compatibility notion of global coordinates. When the scale
   * factor is 1.0, this and kHICoordSpaceScreenPixel are the same.
   }
	kHICoordSpace72DPIGlobal = 1;

  {
   * The coordinate space defined by physical screen pixels. When the
   * scale factor is 1.0, this and kHICoordSpace72DPIGlobal are the
   * same.
   }
	kHICoordSpaceScreenPixel = 2;

  {
   * The coordinate space of a specified WindowRef, with ( 0, 0 ) at
   * the top left of the window's structure. When this is passed to a
   * conversion routine as a source or destination coordinate space,
   * you must also pass a WindowRef as a source or destination object.
   }
	kHICoordSpaceWindow = 3;

  {
   * The coordinate space of a given HIViewRef, with ( 0, 0 ) at the
   * top left of the view unless changed by HIViewSetBoundsOrigin. When
   * this is passed to a conversion routine as a source or destination
   * coordinate space, you must also pass an HIViewRef as a source or
   * destination object.
   }
	kHICoordSpaceView = 4;

{
 *  HIPointConvert()
 *  
 *  Discussion:
 *    This routine converts an HIPoint from one coordinate space to
 *    another. It takes into account the resolution-independent display
 *    scale factor as appropriate.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioPoint:
 *      The HIPoint to convert.
 *    
 *    inSourceSpace:
 *      The HICoordinateSpace constant specifying the source coordinate
 *      space that the point is to be converted from. Some coordinate
 *      spaces require the caller to pass extra information in the
 *      inSourceObject parameter.
 *    
 *    inSourceObject:
 *      An specific object defining the source coordinate space that
 *      the point is to be converted from. You might pass a WindowRef
 *      or an HIViewRef. If no object is necessary, you must pass NULL.
 *      See the HICoordinateSpace documentation for details on which
 *      HICoordinateSpaces require objects.
 *    
 *    inDestinationSpace:
 *      The HICoordinateSpace constant specifying the destination
 *      coordinate space that the point is to be converted to. Some
 *      coordinate spaces require the caller to pass extra information
 *      in the inDestinationObject parameter.
 *    
 *    inDestinationObject:
 *      An specific object defining the destination coordinate space
 *      that the point is to be converted to. You might pass a
 *      WindowRef or an HIViewRef. If no object is necessary, you must
 *      pass NULL. See the HICoordinateSpace documentation for details
 *      on which HICoordinateSpaces require objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
procedure HIPointConvert( var ioPoint: HIPoint; inSourceSpace: HICoordinateSpace; inSourceObject: UnivPtr { can be NULL }; inDestinationSpace: HICoordinateSpace; inDestinationObject: UnivPtr { can be NULL } ); external name '_HIPointConvert';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIRectConvert()
 *  
 *  Discussion:
 *    This routine converts an HIRect from one coordinate space to
 *    another. It takes into account the resolution-independent display
 *    scale factor as appropriate.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioRect:
 *      The HIRect to convert.
 *    
 *    inSourceSpace:
 *      The HICoordinateSpace constant specifying the source coordinate
 *      space that the rect is to be converted from. Some coordinate
 *      spaces require the caller to pass extra information in the
 *      inSourceObject parameter.
 *    
 *    inSourceObject:
 *      An specific object defining the source coordinate space that
 *      the rect is to be converted from. You might pass a WindowRef or
 *      an HIViewRef. If no object is necessary, you must pass NULL.
 *      See the HICoordinateSpace documentation for details on which
 *      HICoordinateSpaces require objects.
 *    
 *    inDestinationSpace:
 *      The HICoordinateSpace constant specifying the destination
 *      coordinate space that the rect is to be converted to. Some
 *      coordinate spaces require the caller to pass extra information
 *      in the inDestinationObject parameter.
 *    
 *    inDestinationObject:
 *      An specific object defining the destination coordinate space
 *      that the rect is to be converted to. You might pass a WindowRef
 *      or an HIViewRef. If no object is necessary, you must pass NULL.
 *      See the HICoordinateSpace documentation for details on which
 *      HICoordinateSpaces require objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
procedure HIRectConvert( var ioRect: HIRect; inSourceSpace: HICoordinateSpace; inSourceObject: UnivPtr { can be NULL }; inDestinationSpace: HICoordinateSpace; inDestinationObject: UnivPtr { can be NULL } ); external name '_HIRectConvert';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HISizeConvert()
 *  
 *  Discussion:
 *    This routine converts an HISize from one coordinate space to
 *    another. It takes into account the resolution-independent display
 *    scale factor as appropriate.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioSize:
 *      The HISize to convert.
 *    
 *    inSourceSpace:
 *      The HICoordinateSpace constant specifying the source coordinate
 *      space that the size is to be converted from. Some coordinate
 *      spaces require the caller to pass extra information in the
 *      inSourceObject parameter.
 *    
 *    inSourceObject:
 *      An specific object defining the source coordinate space that
 *      the size is to be converted from. You might pass a WindowRef or
 *      an HIViewRef. If no object is necessary, you must pass NULL.
 *      See the HICoordinateSpace documentation for details on which
 *      HICoordinateSpaces require objects.
 *    
 *    inDestinationSpace:
 *      The HICoordinateSpace constant specifying the destination
 *      coordinate space that the size is to be converted to. Some
 *      coordinate spaces require the caller to pass extra information
 *      in the inDestinationObject parameter.
 *    
 *    inDestinationObject:
 *      An specific object defining the destination coordinate space
 *      that the size is to be converted to. You might pass a WindowRef
 *      or an HIViewRef. If no object is necessary, you must pass NULL.
 *      See the HICoordinateSpace documentation for details on which
 *      HICoordinateSpaces require objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
procedure HISizeConvert( var ioSize: HISize; inSourceSpace: HICoordinateSpace; inSourceObject: UnivPtr { can be NULL }; inDestinationSpace: HICoordinateSpace; inDestinationObject: UnivPtr { can be NULL } ); external name '_HISizeConvert';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)




end.
