The log library is heavily inspired from the [Apache Log4j](http://logging.apache.org/log4j/index.html) library.  However it is intended to provide a small subset of logging features that Log4j implements, be flexible, extensible, small and efficient.

## Logger Declaration ##



Declare a constant `Logger` variable that will be used to produce the log messages.
A good practice is to declare the `Log` constant in the package body.

```
with Util.Log.Loggers;
package body X is
   use Util.Log;

   Log : constant Loggers.Logger := Loggers.Create ("EL.Expression");
   ...
end X;
```

The `Loggers.Create` function configures the logger with the log name (`EL.Expression`
in the example).  The configuration defines the log level and the appenders that
will receive the message.

## Log Messages ##

The `Logger` type provides several procedures to write a message: `Print`, `Debug`,
`Info`, `Warn` and `Error`.  The message can have up to 3 parameters represented
by `{0}`, `{1}` and `{2}`.

The following call:
```
   Log.info ("Evaluating expression: {0}", "1+2");
```

will produce an information message.  With the default configuration, the output
will look like:

```
[2010-07-03 15:31:21] INFO  - EL.Expression - Evaluating expression: 1+2
```

The following call:
```
   Log.error ("Invalid expression: '{0}': {1}", "23+", "Missing operand");
```
will produce an error message.  The output will look like:


```
[2010-07-03 15:31:21] ERROR - EL.Expression - Invalid expression: '23+': Missing operand
```


## Log Configuration ##

The log configuration uses property files close to the [Apache Log4j](http://logging.apache.org/log4j/index.html) configuration.

A file appender is declared using several properties.

```
log4j.appender.result=File
log4j.appender.result.File=result-output.txt
```

This definition defines an appender named `result` that will write the
message in the file named `result-output.txt`.

The loggers are configured using similar properties that specify the log level
and the optional appender.
The logger `EL.Expression` is configured using the following file:

```
log4j.logger.EL=INFO,result
log4j.logger.EL.Expression=DEBUG
```

This configuration defines that the `EL` loggers and its descendant will
log by default the `INFO` log level and use the `result` appender.
The `EL.Expression` logger overrides the log level and will log the `DEBUG` level.


### Source ###

  * [Log Example](http://code.google.com/p/ada-util/source/browse/trunk/samples/log.adb)
  * [Log4j.properties](http://code.google.com/p/ada-util/source/browse/trunk/samples/log4j.properties)
  * [Util.Log](http://code.google.com/p/ada-util/source/browse/trunk/src/util-log.ads)
  * [Util.Log.Loggers](http://code.google.com/p/ada-util/source/browse/trunk/src/util-log-loggers.ads)
  * [Util.Log.Appenders](http://code.google.com/p/ada-util/source/browse/trunk/src/util-log-appenders.ads)