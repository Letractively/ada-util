/* Generate a package from system header definitions
--  Copyright (C) 2011, 2013 Stephane Carrez
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
*/

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#ifdef HAVE_CURL
#include <curl/curl.h>
#endif
#ifdef HAVE_DLFCN_H
#include <dlfcn.h>
#endif

int main(int argc, char** argv)
{
  printf("--  Generated by utildgen.c from system includes\n");

  if (argc > 1 && strcmp(argv[1], "curl") == 0) {
    printf("private package Util.Http.Clients.Curl.Constants is\n");
#ifdef HAVE_CURL
    printf("\n");
    printf("   CURLOPT_URL            : constant Curl_Option := %d;\n", CURLOPT_URL);
    printf("   CURLOPT_READFUNCTION   : constant Curl_Option := %d;\n", CURLOPT_READFUNCTION);
    printf("   CURLOPT_WRITEUNCTION   : constant Curl_Option := %d;\n", CURLOPT_WRITEFUNCTION);
    printf("   CURLOPT_HTTPHEADER     : constant Curl_Option := %d;\n", CURLOPT_HTTPHEADER);
    printf("   CURLOPT_INTERFACE      : constant Curl_Option := %d;\n", CURLOPT_INTERFACE);
    printf("   CURLOPT_USERPWD        : constant Curl_Option := %d;\n", CURLOPT_USERPWD);
    printf("   CURLOPT_HTTPAUTH       : constant Curl_Option := %d;\n", CURLOPT_HTTPAUTH);
    printf("   CURLOPT_MAXFILESIZE    : constant Curl_Option := %d;\n", CURLOPT_MAXFILESIZE);
    printf("   CURLOPT_WRITEDATA      : constant Curl_Option := %d;\n", CURLOPT_WRITEDATA);
    printf("   CURLOPT_HEADER         : constant Curl_Option := %d;\n", CURLOPT_HEADER);
    printf("   CURLOPT_POSTFIELDS     : constant Curl_Option := %d;\n", CURLOPT_POSTFIELDS);
    printf("   CURLOPT_POSTFIELDSIZE  : constant Curl_Option := %d;\n", CURLOPT_POSTFIELDSIZE);
    printf("\n");
    printf("   CURLINFO_RESPONSE_CODE : constant CURL_Info := %d;\n", CURLINFO_RESPONSE_CODE);
    printf("\n");
#endif
    printf("end Util.Http.Clients.Curl.Constants;\n");

  } else {
    printf("with Interfaces.C;\n");
    printf("package Util.Systems.Constants is\n");
    printf("\n");
    printf("   pragma Pure;\n");

    printf("\n   --  Flags used when opening a file with open/creat.\n");
    printf("   O_RDONLY                      : constant Interfaces.C.int := 8#%06o#;\n", O_RDONLY);
    printf("   O_WRONLY                      : constant Interfaces.C.int := 8#%06o#;\n", O_WRONLY);
    printf("   O_RDWR                        : constant Interfaces.C.int := 8#%06o#;\n", O_RDWR);
    printf("   O_CREAT                       : constant Interfaces.C.int := 8#%06o#;\n", O_CREAT);
    printf("   O_EXCL                        : constant Interfaces.C.int := 8#%06o#;\n", O_EXCL);
    printf("   O_TRUNC                       : constant Interfaces.C.int := 8#%06o#;\n", O_TRUNC);
    printf("   O_APPEND                      : constant Interfaces.C.int := 8#%06o#;\n", O_APPEND);

    printf("\n");

#ifdef F_SETFL
    printf("   --  Flags used by fcntl\n");
    printf("   F_SETFL                       : constant Interfaces.C.int := %d;\n", F_SETFL);
    printf("   FD_CLOEXEC                    : constant Interfaces.C.int := %d;\n", FD_CLOEXEC);
#endif

#ifdef HAVE_DLOPEN
    printf("\n");
    printf("   --  Flags used by dlopen\n");
    printf("   RTLD_LAZY                     : constant Interfaces.C.int := 8#%06o#;\n", RTLD_LAZY);
    printf("   RTLD_NOW                      : constant Interfaces.C.int := 8#%06o#;\n", RTLD_NOW);
    printf("   RTLD_NOLOAD                   : constant Interfaces.C.int := 8#%06o#;\n", RTLD_NOLOAD);
    printf("   RTLD_DEEPBIND                 : constant Interfaces.C.int := 8#%06o#;\n", RTLD_DEEPBIND);
    printf("   RTLD_GLOBAL                   : constant Interfaces.C.int := 8#%06o#;\n", RTLD_GLOBAL);
    printf("   RTLD_LOCAL                    : constant Interfaces.C.int := 8#%06o#;\n", RTLD_LOCAL);
    printf("   RTLD_NODELETE                 : constant Interfaces.C.int := 8#%06o#;\n", RTLD_NODELETE);
#endif
    
    printf("\n");

    printf("end Util.Systems.Constants;\n");
  }
  
  return 0;
}
