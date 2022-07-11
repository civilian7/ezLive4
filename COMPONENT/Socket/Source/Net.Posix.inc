function PosixSend(ASocket: THandle; ABuf: Pointer; ALen: Integer): Integer;
var
  LBuf: PByte;
  LSent, LError: Integer;
  LFlags: Integer;
begin
  Result := 0;

  {$IF defined(LINUX) or defined(ANDROID)}
  LFlags := MSG_NOSIGNAL;
  {$ELSE}
  LFlags := 0;
  {$ENDIF}

  LBuf := ABuf;
  while (Result < ALen) do
  begin
    LSent := TSocketAPI.Send(ASocket, LBuf^, ALen - Result, LFlags);

    if (LSent < 0) then
    begin
      LError := GetLastError;

      if (LError = EINTR) then
        Continue
      else
      if (LError = EAGAIN) or (LError = EWOULDBLOCK) then
        Break
      else
        Exit(-1);
    end;

    Inc(Result, LSent);
    Inc(LBuf, LSent);
  end;
end;
