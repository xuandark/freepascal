(*
  $Id$
  ------------------------------------------------------------------------------
  	Copyright (C) 2005
  		Jason Rogers (dovoto)
  		Dave Murphy (WinterMute)
  	
  	This software is provided 'as-is', without any express or implied
  	warranty.  In no event will the authors be held liable for any
  	damages arising from the use of this software.
  	
  	Permission is granted to anyone to use this software for any
  	purpose, including commercial applications, and to alter it and
  	redistribute it freely, subject to the following restrictions:
  	
  	1.	The origin of this software must not be misrepresented; you
  		must not claim that you wrote the original software. If you use
  		this software in a product, an acknowledgment in the product
  		documentation would be appreciated but is not required.
  	
  	2.	Altered source versions must be plainly marked as such, and
  		must not be misrepresented as being the original software.
  	
  	3.	This notice may not be removed or altered from any source
  		distribution.
  ------------------------------------------------------------------------------
    
    
  Conversion by Legolas (http://itaprogaming.free.fr) for freepascal compiler
  (http://www.freepascal.org)
   
  Copyright (C) 2006  Francesco Lombardi
  Check http://sourceforge.net/projects/libndsfpc for updates
   
  ------------------------------------------------------------------------------

  $Log$

*)

{$ifdef NDS_INTERFACE}

const
  FEATURE_MEDIUM_CANREAD		= $00000001;
  FEATURE_MEDIUM_CANWRITE		= $00000002;
  FEATURE_SLOT_GBA			= $00000010;
  FEATURE_SLOT_NDS			= $00000020;

type
  FN_MEDIUM_STARTUP = function: cbool;
  FN_MEDIUM_ISINSERTED = function: cbool;
  FN_MEDIUM_READSECTORS = function(sector, numSectors: cuint32; buffer: pointer): cbool;
  FN_MEDIUM_WRITESECTORS = function(sector, numSectors: cuint32; const buffer: pointer): cbool;
  FN_MEDIUM_CLEARSTATUS = function: cbool;
  FN_MEDIUM_SHUTDOWN = function: cbool;

  DISC_INTERFACE_STRUCT = record
    ioType: cuint32;
    features: cuint32;
    startup: FN_MEDIUM_STARTUP;
    isInserted: FN_MEDIUM_ISINSERTED;
    readSectors: FN_MEDIUM_READSECTORS;
    writeSectors: FN_MEDIUM_WRITESECTORS;
    clearStatus: FN_MEDIUM_CLEARSTATUS;
    shutdown: FN_MEDIUM_SHUTDOWN;
  end;

  DISC_INTERFACE = DISC_INTERFACE_STRUCT;
  TDISC_INTERFACE = DISC_INTERFACE_STRUCT;
  PDISC_INTERFACE = ^DISC_INTERFACE_STRUCT;
(*
  PARTITION_INTERFACE = (
    PI_DEFAULT = 0,
    PI_SLOT_1, 
    PI_SLOT_2, 
    PI_CUSTOM
  );
*)
{$endif NDS_INTERFACE}

{$ifdef NDS_IMPLEMENTATION}



{$endif NDS_IMPLEMENTATION}
