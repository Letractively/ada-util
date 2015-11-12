# Introduction #

Performance measurements is often made using profiling tools such as GNU gprof or others.
This profiling is however not always appropriate for production or release delivery.
The mechanism presented here is a lightweight performance measurement that can be
used in production environments.

The Ada package `Util.Measures` defines the types and operations to put in place
performance measurements.

# Create the measure set #

Measures are collected in a **Measure\_Set**.  Each measure has a name, a counter and
a sum of time spent for all the measure.  The measure set should be declared as some
global variable.  The implementation is thread safe meaning that a measure set can
be used by several threads at the same time.  It can also be associated with a per-thread data (or task attribute).

To declare the measure set, use:
```
with Util.Measures;

   Perf : Util.Measures.Measure_Set;
```

# Measure the implementation #

A measure is made by creating a variable of type **Stamp**.  The declaration of
this variable marks the begining of the measure.  The measure ends at the
next call to the **Report** procedure.

```
with Util.Measures;
...
   declare
      Start : Util.Measures.Stamp;
   begin
      ...
      Util.Measures.Report (Perf, Start, "Measure for a block");
   end;
```

When the `Report` procedure is called, the time that elapsed between the creation of
the `Start` variable and the procedure call is computed.  This time is
then associated with the measure title and the associated counter is incremented.
The precision of the measured time depends on the system.  On GNU/Linux, it uses
`gettimeofday`.

If the block code is executed several times, the measure set will report
the number of times it was executed.

# Reporting results #

After measures are collected, the results can be saved in a file or in
an output stream.  When saving the measures, the measure set is cleared.

```
   Util.Measures.Write (Perf, "Title of measures",
                        Ada.Text_IO.Standard_Output);
```

# Measure Overhead #

The overhead introduced by the measurement is quite small as it does not exceeds 1.5 us
on a 2.6 Ghz Core Quad.

# What must be measured #

Defining a lot of measurements for a production system is in general not very useful.
Measurements should be relatively high level measurements.  For example:

  * Loading or saving a file
  * Rendering a page in a web application
  * Executing a database query

# Source #

http://code.google.com/p/ada-util/source/browse/trunk/samples/measures.adb