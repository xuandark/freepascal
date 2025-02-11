(*
  $Id: serial.inc 25 2007-12-10 21:06:46Z p4p3r0 $
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

{$ifndef ARM7}
{$error Serial header is for ARM7 only}
{$endif ARM7}

{$ifdef NDS_INTERFACE}
const
// 'Networking'
  REG_RCNT        : pcuint16 = pointer($04000134);
  REG_KEYXY       : pcuint16 = pointer($04000136);
  RTC_CR          : pcuint16 = pointer($04000138);
  RTC_CR8         : pcuint8 = pointer($04000138);

  REG_SIOCNT      : pcuint16 = pointer($04000128);

  SIO_DATA8       : pcuint8 = pointer($0400012A);
  SIO_DATA32      : pcuint32 = pointer($04000120);


// Fixme: Does the hardware still support 16 bit comms mode?
// BIOS makes use of 32 bit mode, so some regs still exist
  SIO_MULTI_0     : pcuint16 = pointer($04000120);
  SIO_MULTI_1     : pcuint16 = pointer($04000122);
  SIO_MULTI_2     : pcuint16 = pointer($04000124);
  SIO_MULTI_3     : pcuint16 = pointer($04000126);
  SIO_MULTI_SEND  : pcuint16 = pointer($0400012A);


// SPI chain registers
  REG_SPICNT      : pcuint16 = pointer($040001C0);
  REG_SPIDATA     : pcuint16 = pointer($040001C2);

  SPI_ENABLE  = (1 shl 15);
  SPI_IRQ     = (1 shl 14);
  SPI_BUSY    = (1 shl 7);

// Pick the SPI clock speed
  SPI_BAUD_4MHZ    = 0;
  SPI_BAUD_2MHZ    = 1;
  SPI_BAUD_1MHZ    = 2;
  SPI_BAUD_512KHZ  = 3;

// Pick the SPI transfer length
  SPI_BYTE_MODE   = (0 shl 10);
  SPI_HWORD_MODE  = (1 shl 10);

// Pick the SPI device
  SPI_DEVICE_POWER      = (0 shl 8);
  SPI_DEVICE_FIRMWARE   = (1 shl 8);
  SPI_DEVICE_NVRAM      = (1 shl 8);
  SPI_DEVICE_TOUCH      = (2 shl 8);
  SPI_DEVICE_MICROPHONE = (2 shl 8);

// When used, the /CS line will stay low after the transfer ends
// i.e. when we're part of a continuous transfer
  SPI_CONTINUOUS       = (1 shl 11);

const
// Firmware commands
  FIRMWARE_WREN = $06;
  FIRMWARE_WRDI = $04;
  FIRMWARE_RDID = $9F;
  FIRMWARE_RDSR = $05;
  FIRMWARE_READ = $03;
  FIRMWARE_PW   = $0A;
  FIRMWARE_PP   = $02;
  FIRMWARE_FAST = $0B;
  FIRMWARE_PE   = $DB;
  FIRMWARE_SE   = $D8;
  FIRMWARE_DP   = $B9;
  FIRMWARE_RDP  = $AB;

procedure SerialWaitBusy(); inline;
procedure readFirmware(address: cuint32; destination: pointer; size: cuint32); cdecl; external;
{$endif NDS_INTERFACE}


{$ifdef NDS_IMPLEMENTATION}
procedure SerialWaitBusy(); inline;
begin
  while (REG_SPICNT^ and SPI_BUSY) <> 0 do 
    swiDelay(1); 
end;
{$endif NDS_IMPLEMENTATION}
