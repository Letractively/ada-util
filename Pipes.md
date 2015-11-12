# Introduction #

An external process can be launched and controlled by the `Process` type.
It allows to read the process standard output as well as write on the process standard input.



# Launching a process #

A process can be launched and controlled by the limited type
`Process`.  First, let's declare the process instance:

```
with Util.Processes;
...
   Proc : Util.Processes.Process;
```

The process is launched by the `Spawn` procedure.  The command and its arguments to execute is passed as a string to the procedure.

```
   Proc.Spawn ("gnatmake --version");
```

Once the process is spawned, the procedure returns: it does not wait for the process to terminate.  We have to use the `Wait` procedure:

```
   Proc.Wait;
```

Then, the process exit status is obtained by calling `Get_Exit_Status`.

# Pipe #

If we want to read the process output, the `Pipe_Stream` simplifies this task.  It is very close to the traditional `popen` operation of the C stdio library.

First, let's define the pipe stream as well as a buffer:
```
with Util.Streams.Pipes;
...
   Pipe    : aliased Util.Streams.Pipes.Pipe_Stream;
   Buffer  : Util.Streams.Buffered.Buffered_Stream;
   Content : Ada.Strings.Unbounded.Unbounded_String;
```

The process is launched easily by using the `Open` procedure.
By default, the pipe will be configured to read the process output.
It is possible to also redirect the process input.

```
   Pipe.Open ("gnatmake --version");
```

The buffer stream object helps in reading the process output.
It is initialized as follows:

```
   Buffer.Initialize (null, Pipe'Unchecked_Access, 1024);
```

The process output can be read easily as follows:

```
   Buffer.Read (Content);
```

The `Read` procedure will read the complete output stream so it may contain multiple lines.

By closing the pipe, we wait for the process to terminate.

```
   Pipe.Close;
```

# References #

[util-processes.ads](http://code.google.com/p/ada-util/source/browse/trunk/src/util-processes.ads)

[popen.adb](http://code.google.com/p/ada-util/source/browse/trunk/samples/popen.adb)

[Process creation in Java and Ada](http://blog.vacs.fr/index.php?post/2012/03/16/Process-creation-in-Java-and-Ada)