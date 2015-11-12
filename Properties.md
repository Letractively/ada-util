The `Util.Properties` package provides operations and types to read and access
Java-like property files.

### Java Property Files ###

The Java property files is a text file that contains name/value pairs that represent
properties. The example below defines two properties `test.count` and `test.dir`.
(See [java.uti.Properties](http://java.sun.com/javase/6/docs/api/java/util/Properties.html#load%28java.io.Reader%29))

```
test.count=20
test.dir=regtests/files
```

The `Util.Properties` Ada package only implements a subset of the Java properties
(UTF-8 characters are not supported).

### Property Manager Declaration ###

The properties are stored in a property manager which provides getter and setter
operations.  The manager is declared as follows:

```
with Util.Properties;

   Properties : Util.Properties.Manager;
```

### Loading the properties ###

The properties can be loaded from a file by using the `Load_Properties` procedure.

```
   Properties.Load_Properties (Path => "test.properties");
```

### Getting a property ###

The property value can be obtained by using one of the `Get` function.

```
   Value : String := Properties.Get ("test.count");
```

To help in using integer and boolean properties, some package helpers are available
to do the conversion.  The following example gets the `test.count` property as an
integer.  If the property does not exist, the default value `23` is returned.

```
with Util.Properties.Basic;
  ...
  use Util.Properties.Basic;
  ...
   Count : Integer := Integer_Property.Get (Properties, "test.count", 23);
```

### Setting a property ###

The property is created or updated by using the `Set` procedure.

```
   Properties.Set ("test.repeat", "23");
```

### Source ###

  * [Util.Properties](http://code.google.com/p/ada-util/source/browse/trunk/src/util-properties.ads)
  * [Util.Properties.Discrete](http://code.google.com/p/ada-util/source/browse/trunk/src/util-properties-discrete.ads)
  * [Util.Properties.Basic](http://code.google.com/p/ada-util/source/browse/trunk/src/util-properties-basic.ads)
  * [Properties example](http://code.google.com/p/ada-util/source/browse/trunk/samples/properties.adb)