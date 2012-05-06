-----------------------------------------------------------------------
--  util-encodes-tests - Test for encoding
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

with AUnit.Test_Suites;
with AUnit.Test_Fixtures;
with Util.Tests;
package Util.Encoders.Tests is

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   type Test is new Util.Tests.Test with null record;

   procedure Test_Hex (T : in out Test);
   procedure Test_Base64_Encode (T : in out Test);
   procedure Test_Base64_Decode (T : in out Test);
   procedure Test_Encoder (T : in out Test;
                           C : in out Util.Encoders.Encoder);
   procedure Test_Base64_Benchmark (T : in out Test);
   procedure Test_SHA1_Encode (T : in out Test);

   --  Benchmark test for SHA1
   procedure Test_SHA1_Benchmark (T : in out Test);

   --  Test HMAC-SHA1
   procedure Test_HMAC_SHA1_RFC2202_T1 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T2 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T3 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T4 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T5 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T6 (T : in out Test);
   procedure Test_HMAC_SHA1_RFC2202_T7 (T : in out Test);

end Util.Encoders.Tests;