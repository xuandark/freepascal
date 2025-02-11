{
    Free Pascal port of the OpenPTC C++ library.
    Copyright (C) 2001-2003  Nikolay Nikolov (nickysn@users.sourceforge.net)
    Original C++ version by Glenn Fiedler (ptc@gaffer.org)

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

Constructor TWinCEKeyboard.Create(EventQueue : TEventQueue);

Begin
//  m_monitor := Nil;
//  m_event := Nil;
//  Inherited Create(window, thread);
//  m_monitor := TWin32Monitor.Create;
//  m_event := TWin32Event.Create;

  { setup defaults }
  m_alt := False;
  m_shift := False;
  m_control := False;

  { setup data }
  FEventQueue := EventQueue;
//  m_multithreaded := multithreaded;

  { enable buffering }
  m_enabled := True;
End;

Procedure TWinCEKeyboard.enable;

Begin
  { enable buffering }
  m_enabled := True;
End;

Procedure TWinCEKeyboard.disable;

Begin
  { disable buffering }
  m_enabled := False;
End;

Function TWinCEKeyboard.WndProc(hWnd : HWND; message : DWord; wParam : WPARAM; lParam : LPARAM) : LRESULT;

Var
  i : Integer;
  scancode : Integer;
  KeyStateArray : Array[0..255] Of Byte;
  AsciiBuf : Word;
  press : Boolean;
  uni : Integer;
  tmp : Integer;

Begin
  WndProc := 0;
  { check enabled flag }
  If Not m_enabled Then
    Exit;

  { process key message }
  If (message = WM_KEYDOWN) Or (message = WM_KEYUP) {Or ((message = WM_SYSKEYDOWN) And ((lParam And (1 Shl 29)) <> 0))} Then
  Begin
    If message = WM_KEYUP Then
      press := False
    Else
      press := True;

    { update modifiers }
    If wParam = VK_MENU Then
      { alt }
      m_alt := press
    Else
      If wParam = VK_SHIFT Then
        { shift }
        m_shift := press
      Else
        If wParam = VK_CONTROL Then
          { control }
          m_control := press;

    { enter monitor if multithreaded }
(*    If m_multithreaded Then
      m_monitor.enter;*)

    uni := -1;

(*    If GetKeyboardState(@KeyStateArray) Then
    Begin
      scancode := (lParam Shr 16) And $FF;
      {todo: ToUnicode (Windows NT)}
      tmp := ToAscii(wParam, scancode, @KeyStateArray, @AsciiBuf, 0);
      If (tmp = 1) Or (tmp = 2) Then
      Begin
        If tmp = 2 Then
        Begin
//          Writeln('[', AsciiBuf, ']'); {???? todo: dead keys ????}
        End
        Else
        Begin
//          Write(Chr(AsciiBuf));
          {todo: codepage -> unicode}
          If AsciiBuf <= 126 Then
            uni := AsciiBuf;
        End;

      End;
    End;*)

    { handle key repeat count }
    For i := 1 To lParam And $FFFF Do
      { create and insert key object }
      FEventQueue.AddEvent(TPTCKeyEvent.Create(wParam, uni, m_alt, m_shift, m_control, press));

    { check multithreaded flag }
(*    If m_multithreaded Then
    Begin
      { set event }
      m_event._set;

      { leave monitor }
      m_monitor.leave;
    End;*)
  End;
End;
