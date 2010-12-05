-----------------------------------------------------------------------
--  Util.Streams.Files -- File Stream utilities
--  Copyright (C) 2010 Stephane Carrez
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

package body Util.Streams.Texts is

   procedure Initialize (Stream : in out Print_Stream;
                         To     : in Output_Stream_Access) is
   begin
      Stream.Initialize (Output => To, Input => null, Size => 4096);
   end Initialize;

   --  ------------------------------
   --  Write an integer on the stream.
   --  ------------------------------
   procedure Write (Stream : in out Print_Stream;
                    Item   : in Integer) is
      S : constant String := Integer'Image (Item);
   begin
      if Item > 0 then
         Stream.Write (S (S'First + 1 .. S'Last));
      else
         Stream.Write (S);
      end if;
   end Write;

   --  ------------------------------
   --  Write a string on the stream.
   --  ------------------------------
   procedure Write (Stream : in out Print_Stream;
                    Item   : in Ada.Strings.Unbounded.Unbounded_String) is
   begin
      Stream.Write (Ada.Strings.Unbounded.To_String (Item));
   end Write;

end Util.Streams.Texts;