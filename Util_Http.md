## Introduction ##
The <tt>Util.Http</tt> package provides a set of APIs that allows applications to use
the HTTP protocol.

## Client ##
The <tt>Util.Http.Clients</tt> package defines a set of API for an HTTP client to send
requests to an HTTP server.

### GET request ###
To retrieve a content using the HTTP GET operation, a client instance must be created.
The response is returned in a specific object that must therefore be declared:

```
  Http     : Util.Http.Clients.Client;
  Response : Util.Http.Clients.Response;
```

Before invoking the GET operation, the client can setup a number of HTTP headers.

```
  Http.Add_Header ("X-Requested-By", "wget");
```

The GET operation is performed when the <tt>Get</tt> procedure is called:

```
  Http.Get ("http://www.google.com", Response);
```

Once the response is received, the <tt>Response</tt> object contains the status of the
HTTP response, the HTTP reply headers and the body.  A response header can be obtained
by using the <tt>Get_Header</tt> function and the body using <tt>Get_Body</tt>:

```
  Body : constant String := Response.Get_Body;
```


---

[Generated by Dynamo](http://code.google.com/p/ada-gen) _from util-http.ads_