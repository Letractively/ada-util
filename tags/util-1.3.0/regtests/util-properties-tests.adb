-----------------------------------------------------------------------
--  Util -- Unit tests for properties
--  Copyright (C) 2009, 2010, 2011 Stephane Carrez
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

with Util.Test_Caller;

with Ada.Text_IO;

with Util.Properties;
with Util.Properties.Basic;

package body Util.Properties.Tests is

   use Ada.Text_IO;
   use Util.Properties.Basic;
   use Util;

   --  Test
   --    Properties.Set
   --    Properties.Exists
   --    Properties.Get
   procedure Test_Property (T : in out Test) is
      Props : Properties.Manager;
   begin
      T.Assert (Exists (Props, "test") = false,
                "Invalid properties");
      Props.Set ("test", "toto");
      T.Assert (Exists (Props, "test"),
                "Property was not inserted");
      declare
         V : constant String := Props.Get ("test");
      begin

         T.Assert (V = "toto",
                   "Property was not set correctly");
      end;
   end Test_Property;

   --  Test basic properties
   --     Get
   --     Set
   procedure Test_Integer_Property (T : in out Test) is
      Props : Properties.Manager;
      V     : Integer := 23;
   begin
      Integer_Property.Set (Props, "test-integer", V);
      T.Assert (Props.Exists ("test-integer"), "Invalid properties");

      V := Integer_Property.Get (Props, "test-integer");
      T.Assert (V = 23, "Property was not inserted");

      Integer_Property.Set (Props, "test-integer", 24);
      V := Integer_Property.Get (Props, "test-integer");
      T.Assert (V = 24, "Property was not inserted");

      V := Integer_Property.Get (Props, "unknown", 25);
      T.Assert (V = 25, "Default value must be returned for a Get");
   end Test_Integer_Property;

   --  Test loading of property files
   procedure Test_Load_Property (T : in out Test) is
      Props : Properties.Manager;
      F : File_Type;
   begin
      Open (F, In_File, "regtests/test.properties");
      Load_Properties (Props, F);
      Close (F);

      declare
         Names : constant Name_Array := Get_Names (Props);
      begin
         T.Assert (Names'Length > 30,
                   "Loading the test properties returned too few properties");

         T.Assert (To_String (Props.Get ("root.dir")) = ".",
                   "Invalid property 'root.dir'");
         T.Assert (To_String (Props.Get ("console.lib")) = "${dist.lib.dir}/console.jar",
                   "Invalid property 'console.lib'");
      end;
   exception
      when Ada.Text_IO.Name_Error =>
         Ada.Text_IO.Put_Line ("Cannot find test file: regtests/test.properties");
         raise;
   end Test_Load_Property;

   --  ------------------------------
   --  Test loading of property files
   --  ------------------------------
   procedure Test_Load_Strip_Property (T : in out Test) is
      Props : Properties.Manager;
      F : File_Type;
   begin
      --  Load, filter and strip properties
      Open (F, In_File, "regtests/test.properties");
      Load_Properties (Props, F, "tomcat.", True);
      Close (F);

      declare
         Names : constant Name_Array := Get_Names (Props);
      begin
         T.Assert (Names'Length > 3,
                   "Loading the test properties returned too few properties");

         T.Assert (To_String (Props.Get ("version")) = "0.6",
                   "Invalid property 'root.dir'");
      end;
   exception
      when Ada.Text_IO.Name_Error =>
         Ada.Text_IO.Put_Line ("Cannot find test file: regtests/test.properties");
         raise;
   end Test_Load_Strip_Property;

   --  ------------------------------
   --  Test copy of properties
   --  ------------------------------
   procedure Test_Copy_Property (T : in out Test) is
      Props : Properties.Manager;
   begin
      Props.Set ("prefix.one", "1");
      Props.Set ("prefix.two", "2");
      Props.Set ("prefix", "Not copied");
      Props.Set ("prefix.", "Copied");
      declare
         Copy : Properties.Manager;
      begin
         Copy.Copy (From   => Props,
                    Prefix => "prefix.",
                    Strip  => True);
         T.Assert (Copy.Exists ("one"), "Property one not found");
         T.Assert (Copy.Exists ("two"), "Property two not found");
         T.Assert (Copy.Exists (""), "Property '' does not exist.");
      end;
   end Test_Copy_Property;

   package Caller is new Util.Test_Caller (Test);

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Util.Properties.Set",
                       Test_Property'Access);
      Caller.Add_Test (Suite, "Test Util.Properties.Get",
                       Test_Property'Access);
      Caller.Add_Test (Suite, "Test Util.Properties.Exists",
                       Test_Property'Access);

      Caller.Add_Test (Suite, "Test Util.Properties.Discrete.Get",
                       Test_Integer_Property'Access);

      Caller.Add_Test (Suite, "Test Util.Properties.Discrete.Set",
                       Test_Integer_Property'Access);

      Caller.Add_Test (Suite, "Test Util.Properties.Load_Properties",
                       Test_Load_Property'Access);
      Caller.Add_Test (Suite, "Test Util.Properties.Load_Strip_Properties",
                       Test_Load_Strip_Property'Access);
      Caller.Add_Test (Suite, "Test Util.Properties.Copy",
                       Test_Copy_Property'Access);
   end Add_Tests;

end Util.Properties.Tests;