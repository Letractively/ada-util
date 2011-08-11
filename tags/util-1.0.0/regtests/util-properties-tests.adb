-----------------------------------------------------------------------
--  Util -- Unit tests for properties
--  Copyright (C) 2009, 2010 Stephane Carrez
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

with AUnit.Assertions;
with AUnit.Test_Caller;

with Ada.Text_IO;

with Util.Properties;
with Util.Properties.Basic;
with Util.Properties.Bundle;

package body Util.Properties.Tests is

   use Ada.Text_IO;
   use AUnit.Assertions;
   use Util.Properties.Basic;
   use Util;

   --  Test
   --    Properties.Set
   --    Properties.Exists
   --    Properties.Get
   procedure Test_Property (T : in out Test) is
      pragma Unreferenced (T);

      Props : Properties.Manager;
   begin
      Assert (Exists (Props, "test") = false,
              "Invalid properties");
      Props.Set ("test", "toto");
      Assert (Exists (Props, "test"),
              "Property was not inserted");
      declare
         V : constant String := Props.Get ("test");
      begin

         Assert (V = "toto",
                 "Property was not set correctly");
      end;
   end Test_Property;

   --  Test basic properties
   --     Get
   --     Set
   procedure Test_Integer_Property (T : in out Test) is
      pragma Unreferenced (T);

      Props : Properties.Manager;
      V     : Integer := 23;
   begin
      Integer_Property.Set (Props, "test-integer", V);
      Assert (Props.Exists ("test-integer"), "Invalid properties");

      V := Integer_Property.Get (Props, "test-integer");
      Assert (V = 23, "Property was not inserted");

      Integer_Property.Set (Props, "test-integer", 24);
      V := Integer_Property.Get (Props, "test-integer");
      Assert (V = 24, "Property was not inserted");

      V := Integer_Property.Get (Props, "unknown", 25);
      Assert (V = 25, "Default value must be returned for a Get");
   end Test_Integer_Property;

   --  Test the bundle
   procedure Test_Bundle (T : in out Test) is
      pragma Unreferenced (T);

      Bundle : Properties.Bundle.Manager;
      Props  : constant Properties.Manager_Access := new Properties.Manager;
      V : Integer := 23;
   begin
      --  Create a first property (while the bundle is empty)
      Integer_Property.Set (Bundle, "test-integer", 123);
      Assert (Bundle.Exists ("test-integer"), "Invalid properties");

      V := Integer_Property.Get (Bundle, "test-integer");
      Assert (V = 123, "Property was not inserted");

      --  Add a property set to the bundle
      Bundle.Add_Bundle (Props);
      Integer_Property.Set (Props.all, "test-integer-second", 24);
      V := Integer_Property.Get (Props.all, "test-integer-second");
      Assert (V = 24, "Property was not inserted");

      V := Integer_Property.Get (Bundle, "test-integer-second");
      Assert (V = 24, "Property was not inserted");

      Bundle.Remove ("test-integer-second");
      Assert (Props.all.Exists ("test-integer-second") = False,
              "The 'test-integer-second' property was not removed");

      Assert (Bundle.Exists ("test-integer-second") = False,
              "Property not removed from bundle");
   end Test_Bundle;

   --  Test loading of bundles
   procedure Test_Load_Bundle (T : in out Test) is
      pragma Unreferenced (T);

      Bundle    : Util.Properties.Bundle.Manager;
      Fr_Bundle : Util.Properties.Bundle.Manager;
      De_Bundle : Util.Properties.Bundle.Manager;
   begin
      Bundle.Load_Bundle (".", "test");
      Bundle.Find_Bundle ("fr", Fr_Bundle);
      Bundle.Find_Bundle ("de", De_Bundle);
   end Test_Load_Bundle;

   --  Test loading of property files
   procedure Test_Load_Property (T : in out Test) is
      pragma Unreferenced (T);

      Props : Properties.Manager;
      F : File_Type;
   begin
      Open (F, In_File, "regtests/test.properties");
      Load_Properties (Props, F);
      Close (F);

      declare
         Names : constant Name_Array := Get_Names (Props);
      begin
         Assert (Names'Length > 30,
                 "Loading the test properties returned too few properties");

         Assert (To_String (Props.Get ("root.dir")) = ".",
                 "Invalid property 'root.dir'");
         Assert (To_String (Props.Get ("console.lib")) = "${dist.lib.dir}/console.jar",
                 "Invalid property 'console.lib'");
      end;
   exception
      when Ada.Text_IO.Name_Error =>
         Ada.Text_IO.Put_Line ("Cannot find test file: regtests/test.properties");
         raise;
   end Test_Load_Property;

   package Caller is new AUnit.Test_Caller (Test);

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      Suite.Add_Test (Caller.Create ("Test Util.Properties.Set",
        Test_Property'Access));
      Suite.Add_Test (Caller.Create ("Test Util.Properties.Get",
        Test_Property'Access));
      Suite.Add_Test (Caller.Create ("Test Util.Properties.Exists",
        Test_Property'Access));

      Suite.Add_Test (Caller.Create ("Test Util.Properties.Discrete.Get",
        Test_Integer_Property'Access));

      Suite.Add_Test (Caller.Create ("Test Util.Properties.Discrete.Set",
        Test_Integer_Property'Access));

      Suite.Add_Test (Caller.Create ("Test Util.Properties.Bundle",
        Test_Bundle'Access));

      Suite.Add_Test (Caller.Create ("Test Util.Properties.Bundle.Load",
        Test_Load_Bundle'Access));

      Suite.Add_Test (Caller.Create ("Test Util.Properties.Load_Properties",
        Test_Load_Property'Access));
   end Add_Tests;

end Util.Properties.Tests;