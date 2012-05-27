-----------------------------------------------------------------------
--  util-http-clients -- HTTP Clients
--  Copyright (C) 2011, 2012 Stephane Carrez
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
package body Util.Http.Clients is

   --  ------------------------------
   --  Returns a boolean indicating whether the named response header has already
   --  been set.
   --  ------------------------------
   overriding
   function Contains_Header (Reply : in Response;
                             Name  : in String) return Boolean is
   begin
      if Reply.Delegate = null then
         return False;
      else
         return Reply.Delegate.Contains_Header (Name);
      end if;
   end Contains_Header;

   --  ------------------------------
   --  Returns the value of the specified response header as a String. If the response
   --  did not include a header of the specified name, this method returns null.
   --  If there are multiple headers with the same name, this method returns the
   --  first head in the request. The header name is case insensitive. You can use
   --  this method with any response header.
   --  ------------------------------
   overriding
   function Get_Header (Reply  : in Response;
                        Name   : in String) return String is
   begin
      if Reply.Delegate = null then
         return "";
      else
         return Reply.Delegate.Get_Header (Name);
      end if;
   end Get_Header;

   --  ------------------------------
   --  Sets a message header with the given name and value. If the header had already
   --  been set, the new value overwrites the previous one. The containsHeader
   --  method can be used to test for the presence of a header before setting its value.
   --  ------------------------------
   overriding
   procedure Set_Header (Reply    : in out Response;
                         Name     : in String;
                         Value    : in String) is
   begin
      if Reply.Delegate = null then
         null;
      end if;
      Reply.Delegate.Set_Header (Name, Value);
   end Set_Header;

   --  ------------------------------
   --  Adds a request header with the given name and value.
   --  This method allows request headers to have multiple values.
   --  ------------------------------
   overriding
   procedure Add_Header (Reply   : in out Response;
                         Name    : in String;
                         Value   : in String) is
   begin
      Reply.Delegate.Add_Header (Name, Value);
   end Add_Header;

   --  ------------------------------
   --  Iterate over the response headers and executes the <b>Process</b> procedure.
   --  ------------------------------
   overriding
   procedure Iterate_Headers (Reply   : in Response;
                              Process : not null access
                                procedure (Name  : in String;
                                           Value : in String)) is
   begin
      if Reply.Delegate /= null then
         Reply.Delegate.Iterate_Headers (Process);
      end if;
   end Iterate_Headers;

   --  ------------------------------
   --  Get the response body as a string.
   --  ------------------------------
   overriding
   function Get_Body (Reply : in Response) return String is
   begin
      if Reply.Delegate = null then
         return "";
      else
         return Reply.Delegate.Get_Body;
      end if;
   end Get_Body;

   --  ------------------------------
   --  Get the response status code.
   --  ------------------------------
   function Get_Status (Reply : in Response) return Natural is
   begin
      return Reply.Delegate.Get_Status;
   end Get_Status;

   --  Returns a boolean indicating whether the named response header has already
   --  been set.
   overriding
   function Contains_Header (Request : in Client;
                             Name    : in String) return Boolean is
   begin
      return Request.Delegate.Contains_Header (Name);
   end Contains_Header;

   --  Returns the value of the specified request header as a String. If the request
   --  did not include a header of the specified name, this method returns null.
   --  If there are multiple headers with the same name, this method returns the
   --  first head in the request. The header name is case insensitive. You can use
   --  this method with any response header.
   overriding
   function Get_Header (Request : in Client;
                        Name    : in String) return String is
   begin
      return Request.Delegate.Get_Header (Name);
   end Get_Header;

   --  Sets a header with the given name and value. If the header had already
   --  been set, the new value overwrites the previous one. The containsHeader
   --  method can be used to test for the presence of a header before setting its value.
   overriding
   procedure Set_Header (Request  : in out Client;
                         Name     : in String;
                         Value    : in String) is
   begin
      Request.Delegate.Set_Header (Name, Value);
   end Set_Header;

   --  Adds a header with the given name and value.
   --  This method allows headers to have multiple values.
   overriding
   procedure Add_Header (Request  : in out Client;
                         Name     : in String;
                         Value    : in String) is
   begin
      Request.Delegate.Add_Header (Name, Value);
   end Add_Header;

   --  Iterate over the request headers and executes the <b>Process</b> procedure.
   overriding
   procedure Iterate_Headers (Request : in Client;
                              Process : not null access
                                procedure (Name  : in String;
                                           Value : in String)) is
   begin
      Request.Delegate.Iterate_Headers (Process);
   end Iterate_Headers;

   --  Removes all headers with the given name.
   procedure Remove_Header (Request : in out Client;
                            Name    : in String) is
   begin
      null;
   end Remove_Header;

   --  Returns a boolean indicating whether the named header has already been set.
--     function Contains_Header (Request : in Client;
--                               Name    : in String) return Boolean is
--     begin
--        return False;
--     end Contains_Header;

   --  ------------------------------
   --  Initialize the client
   --  ------------------------------
   overriding
   procedure Initialize (Http : in out Client) is
   begin
      Http.Delegate := null;
      Http.Manager  := Default_Http_Manager;
      Http.Manager.Create (Http);
   end Initialize;

   overriding
   procedure Finalize (Http : in out Client) is
      procedure Free is new Ada.Unchecked_Deallocation (Http_Request'Class,
                                                        Http_Request_Access);
   begin
      Free (Http.Delegate);
   end Finalize;

   --  ------------------------------
   --  Execute an http GET request on the given URL.  Additional request parameters,
   --  cookies and headers should have been set on the client object.
   --  ------------------------------
   procedure Get (Request  : in out Client;
                  URL      : in String;
                  Reply    : out Response'Class) is
   begin
      Request.Manager.Do_Get (Request, URL, Reply);
   end Get;

   --  ------------------------------
   --  Execute an http POST request on the given URL.  The post data is passed in <b>Data</b>.
   --  Additional request cookies and headers should have been set on the client object.
   --  ------------------------------
   procedure Post (Request : in out Client;
                   URL     : in String;
                   Data    : in String;
                   Reply   : out Response'Class) is
   begin
      Request.Manager.Do_Post (Request, URL, Data, Reply);
   end Post;

   --  ------------------------------
   --  Adds the specified cookie to the request. This method can be called multiple
   --  times to set more than one cookie.
   --  ------------------------------
   procedure Add_Cookie (Http   : in out Client;
                         Cookie : in Util.Http.Cookies.Cookie) is
   begin
      null;
   end Add_Cookie;

   --  ------------------------------
   --  Free the resource used by the response.
   --  ------------------------------
   overriding
   procedure Finalize (Reply : in out Response) is
      procedure Free is new Ada.Unchecked_Deallocation (Http_Response'Class,
                                                        Http_Response_Access);
   begin
      Free (Reply.Delegate);
   end Finalize;

end Util.Http.Clients;
