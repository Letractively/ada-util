# Introduction #

The [Util.Streams](http://code.google.com/p/ada-util/source/browse/trunk/src/util-streams.ads) package defines the `Input_Stream` and `Output_Stream` interfaces which
allow to read and write data on a stream.  These interfaces are very close to the Java `InputStream` and `OutputStream` classes.


# Buffered Streams #

The `Util.Streams.Buffered` package implements a buffered input and output stream.
It allows to write or read data from a buffer.  The following code extract declares
and initialized a stream buffer of 1024 bytes.

```
with Util.Streams.Buffered;
...
   Stream     : Util.Streams.Buffered.Buffered_Stream;

   ...
   Stream.Initialize (Size => 1024);
```

To write data on the stream, various `Write` procedures are provided:

```
   Stream.Write ("abcd");
   Stream.Write ('d');
```

When the stream buffer is full, the `Flush` procedure is called.  The default implementation will flush the buffer to the output stream to which the buffer stream
is connected.  If there is none, it raises the `Ada.IO_Exceptions.Data_Error` exception.


To read data from the stream, several `Read` procedures are also provided:

```
   C : Character;
   ...
   Stream.Read (C);
```

If the stream buffer is empty, the `Fill` procedure is invoked.  Again, the default
implementation will fill the buffer from the connected input stream.  If there is none,
the `Ada.IO_Exceptions.Data_Error` exception is raised.

# File Streams #

The `Util.Streams.Files` is an unbuffered stream that reads or writes to a file.
The stream is configured either for reading or for writing.  The following extract
declares a file stream for writing in the file `test-stream.txt`.  This stream is unbuffered.

```
with Util.Streams.Files;
   ...
   File : Util.Streams.Files.File_Stream;
   ...
   File.Create (Mode => Out_File, Name => "test-stream.txt");
```

The `Write` and `Read` operations are available on the `File_Stream` but it may be
convenient to add use the `Buffered_Stream` instead.  In that case, the buffered stream
is initialized as follows:

```
   File   : aliased Util.Streams.Files.File_Stream;
   Buffer : Util.Streams.Buffered.Buffered_Stream;
   ...
   Buffer.Initialize (Output => File'Unchecked_Access,
                      Input  => null,
                      Size   => 1024);
```

Writing or reading to the stream is made on the buffered stream (`Buffer` object)
as follows:

```
   Buffer.Write ("Hello");
```

The buffer can be flushed explicitly with `Flush` and the file can be closed with the
`Close` procedure.  However, the `Flush` procedure will be called when the buffer object
is finalized and the `Close` procedure will be called when the file object is finalized.


# Pipe Streams #

The `Pipe_Stream` is a special stream which launches an external process
and redirects the standard input and standard output of the process.
The `Pipe_Stream` can be used to write on the process standard input
or read the process standard output.  It is very close to the `popen` operation provided by the C stdio library.  First, create the pipe instance:

```
with Util.Streams.Pipes;
...
   Pipe : aliased Util.Streams.Pipes.Pipe_Stream;
```

The pipe instance can be associated with only one process at a time.
The process is launched by using the `Open` command and specifying the
command to execute as well as the pipe redirection mode.

  * READ to read the process standard output,
  * WRITE to write on the process standard input,

```
   Command : constant String := "ls -l";
   ...
   Pipe.Open (Command => Command,
              Mode    => Util.Processes.READ);
```

The `Pipe_Stream` is not buffered.  A buffer can be configured easily as follows:

```
  Buffer : Util.Streams.Buffered.Buffered_Stream;
  ...
  Buffer.Initialize (Output => null,
                     Input  => Pipe'Unchecked_Access,
                     Size   => 1024);
```

And to read the process output, one can use the following:

```
  Content : Ada.Strings.Unbounded.Unbounded_String;
  ...
  Buffer.Read (Into => Content);
```

The pipe object should be closed when reading or writing to it is finished.
By closing the pipe, the caller will wait for the termination of the process.
The process exit status can be obtained by using the `Get_Exit_Status` function.

```
   Pipe.Close;

   if Pipe.Get_Exit_Status /= 0 then
      Ada.Text_IO.Put_Line (Command & " exited with status "
                            & Integer'Image (Pipe.Get_Exit_Status));
      return;
   end if;
```

The `Pipe_Stream` is a limited type and thus cannot be copied.
When leaving the scope of the `Pipe_Stream` instance, the application will
wait for the process to terminate.