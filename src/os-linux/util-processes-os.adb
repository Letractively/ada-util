-----------------------------------------------------------------------
--  util-processes-os -- System specific and low level operations
--  Copyright (C) 2011 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------

with Ada.Unchecked_Deallocation;

with Util.Systems.Os;
package body Util.Processes.Os is

   use Util.Systems.Os;
   use type Interfaces.C.Size_T;

   --  ------------------------------
   --  Create the output stream to read/write on the process input/output.
   --  Setup the file to be closed on exec.
   --  ------------------------------
   function Create_Stream (File : in File_Type)
                           return Util.Streams.Raw.Raw_Stream_Access is
      Stream : constant Util.Streams.Raw.Raw_Stream_Access := new Util.Streams.Raw.Raw_Stream;
      Status : constant Integer := Sys_Fcntl (File, F_SETFL, FD_CLOEXEC);
      pragma Unreferenced (Status);
   begin
      Stream.Initialize (File);
      return Stream;
   end Create_Stream;

   --  ------------------------------
   --  Wait for the process to exit.
   --  ------------------------------
   overriding
   procedure Wait (Sys     : in out System_Process;
                   Proc    : in out Process'Class;
                   Timeout : in Duration) is
      Result : Integer;
      Wpid   : Integer;
   begin
      Wpid := Sys_Waitpid (Integer (Proc.Pid), Result'Address, 0);
      if Wpid = Integer (Proc.Pid) then
         Proc.Exit_Value := Result / 256;
      end if;
   end Wait;

   --  ------------------------------
   --  Spawn a new process.
   --  ------------------------------
   overriding
   procedure Spawn (Sys  : in out System_Process;
                    Proc : in out Process'Class;
                    Mode : in Pipe_Mode := NONE) is
      use Util.Streams.Raw;
      use Interfaces.C.Strings;

      --  Suppress all checks to make sure the child process will not raise any exception.
      pragma Suppress (All_Checks);

      Result : Integer;
      pragma Unreferenced (Result);

      Pipes  : aliased array (0 .. 1) of File_Type := (others => NO_FILE);
   begin
      --  Since checks are disabled, verify by hand that the argv table is correct.
      if Sys.Argv = null or else Sys.Argc < 1 or else Sys.Argv (0) = Null_Ptr then
         raise Program_Error with "Invalid process argument list";
      end if;

      if Mode /= NONE then
         if Sys_Pipe (Pipes'Address) /= 0 then
            raise Process_Error with "Cannot create pipe";
         end if;
      end if;

      --  Create the new process by using vfork instead of fork.  The parent process is blocked
      --  until the child executes the exec or exits.  The child process uses the same stack
      --  as the parent.
      Proc.Pid := Sys_VFork;
      if Proc.Pid = 0 then

         --  Do not use any Ada type while in the child process.
         case Mode is
            when READ =>
               if Pipes (1) /= STDOUT_FILENO then
                  Result := Sys_Dup2 (Pipes (1), STDOUT_FILENO);
                  Result := Sys_Close (Pipes (1));
               end if;
               Result := Sys_Close (Pipes (0));

            when WRITE =>
               if Pipes (0) /= STDIN_FILENO then
                  Result := Sys_Dup2 (Pipes (0), STDIN_FILENO);
                  Result := Sys_Close (Pipes (0));
               end if;
               Result := Sys_Close (Pipes (1));

            when others =>
               null;

         end case;

         Result := Sys_Execvp (Sys.Argv (0), Sys.Argv.all);
         Sys_Exit (255);
      end if;

      --  Process creation failed, cleanup and raise an exception.
      if Proc.Pid < 0 then
         if Mode /= NONE then
            Result := Sys_Close (Pipes (0));
            Result := Sys_Close (Pipes (1));
         end if;
         raise Process_Error with "Cannot create process";
      end if;

      case Mode is
         when READ =>
            Result := Sys_Close (Pipes (1));
            Proc.Output := Create_Stream (Pipes (0)).all'Access;

         when WRITE =>
            Result := Sys_Close (Pipes (0));
            Proc.Input := Create_Stream (Pipes (1)).all'Access;

         when NONE =>
            null;

      end case;
   end Spawn;

   procedure Free is
     new Ada.Unchecked_Deallocation (Name => Ptr_Ptr_Array, Object => Ptr_Array);

   --  ------------------------------
   --  Append the argument to the process argument list.
   --  ------------------------------
   overriding
   procedure Append_Argument (Sys : in out System_Process;
                              Arg : in String) is
   begin
      if Sys.Argv = null then
         Sys.Argv := new Ptr_Array (0 .. 10);
      elsif Sys.Argc = Sys.Argv'Last - 1 then
         declare
            N : Ptr_Ptr_Array := new Ptr_Array (0 .. Sys.Argc + 32);
         begin
            N (0 .. Sys.Argc) := Sys.Argv (0 .. Sys.Argc);
            Free (Sys.Argv);
            Sys.Argv := N;
         end;
      end if;

      Sys.Argv (Sys.Argc) := Interfaces.C.Strings.New_String (Arg);
      Sys.Argc := Sys.Argc + 1;
      Sys.Argv (Sys.Argc) := Interfaces.C.Strings.Null_Ptr;
   end Append_Argument;

   --  ------------------------------
   --  Deletes the storage held by the system process.
   --  ------------------------------
   overriding
   procedure Finalize (Sys : in out System_Process) is
   begin
      if Sys.Argv /= null then
         for I in Sys.Argv'Range loop
            Interfaces.C.Strings.Free (Sys.Argv (I));
         end loop;
         Free (Sys.Argv);
      end if;
   end Finalize;

end Util.Processes.Os;



