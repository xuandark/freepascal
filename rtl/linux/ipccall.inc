{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2001 by Free Pascal development team

    Linux IPC implemented with ipccall

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 ***********************************************************************}
{ The following definitions come from linux/ipc.h }

Function ftok (Path : pchar; ID : cint) : TKey;
Var Info : TStat;
begin
  If fpstat(path,info)<0 then
    ftok:=-1
  else
    begin
    ftok:= (info.st_ino and $FFFF) or ((info.st_dev and $ff) shl 16) or (byte(ID) shl 24)
    end;
end;

Const
  CALL_SEMOP   = 1;
  CALL_SEMGET  = 2;
  CALL_SEMCTL  = 3;
  CALL_MSGSND  = 11;
  CALL_MSGRCV  = 12;
  CALL_MSGGET  = 13;
  CALL_MSGCTL  = 14;
  CALL_SHMAT   = 21;
  CALL_SHMDT   = 22;
  CALL_SHMGET  = 23;
  CALL_SHMCTL  = 24;

{ generic call that handles all IPC calls }

function ipccall(Call,First,Second,Third : cint; P : Pointer) : ptrint;
begin
 ipccall:=do_syscall(syscall_nr_ipc,call,first,second,third,ptrint(P));
// ipcerror:=fpgetErrno;
end;

function shmget(key: Tkey; size:size_t; flag:cint):cint;
begin
  shmget:=ipccall (CALL_SHMGET,key,size,flag,nil);
end;

Function shmat (shmid:cint; shmaddr:pointer; shmflg:cint):pointer;
Var raddr : pchar;
    error : ptrint;
begin
  error:=ipccall(CALL_SHMAT,shmid,shmflg,cint(@raddr),shmaddr);
  If Error<0 then
    shmat:=pchar(error)
  else
    shmat:=raddr;
end;

function shmdt (shmaddr:pointer): cint;
begin
  shmdt:=ipccall(CALL_SHMDT,0,0,0,shmaddr);
end;

function shmctl(shmid:cint; cmd:cint; buf: pshmid_ds): cint;
begin
 shmctl:=ipccall(CALL_SHMCTL,shmid,cmd,0,buf);
end;

function msgget(key:Tkey; msgflg:cint):cint;
begin
  msgget:=ipccall(CALL_MSGGET,key,msgflg,0,Nil);
end;

function msgsnd(msqid:cint; msgp: PMSGBuf; msgsz: size_t; msgflg:cint):cint;
begin
  msgsnd:=ipccall(Call_MSGSND,msqid,msgsz,msgflg,msgp);
end;

function msgrcv(msqid:cint; msgp: PMSGBuf; msgsz: size_t; msgtyp:cint; msgflg:cint):cint;
Type
  TIPC_Kludge = Record
    msgp   : pmsgbuf;
    msgtyp : cint;
  end;
Var
   tmp : TIPC_Kludge;
begin
  tmp.msgp   := msgp;
  tmp.msgtyp := msgtyp;
  msgrcv:=ipccall(CALL_MSGRCV,msqid,msgsz,msgflg,@tmp);
end;

Function msgctl(msqid:cint; cmd: cint; buf: PMSQid_ds): cint;
begin
  msgctl:=ipccall(CALL_MSGCTL,msqid,cmd,0,buf);
end;

Function semget(key:Tkey; nsems:cint; semflg:cint): cint;
begin
  semget:=ipccall (CALL_SEMGET,key,nsems,semflg,Nil);
end;

Function semop(semid:cint; sops: psembuf; nsops:cuint): cint;
begin
  semop:=ipccall (CALL_SEMOP,semid,cint(nsops),0,Pointer(sops));
end;

Function semctl(semid:cint; semnum:cint; cmd:cint; var arg: tsemun): cint;
begin
  semctl:=ipccall(CALL_SEMCTL,semid,semnum,cmd,@arg);
end;

