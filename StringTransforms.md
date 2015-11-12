# Introduction #

The `Util.Texts.Transforms` generic package provides various functions and
procedures to transform strings:

  * Capitalize a string,
  * Transform to upper case,
  * Transform to lower case,
  * Escape the string using Javascript escape rules,
  * Escape the string using XML escape rules

The `Util.Strings.Transforms` package is an instantiation of this
generic package for the `String` and the `Unbounded_String` types.
To use the string transformation package, add the following with clause:

```
with Util.Strings.Transforms;
```

# Escape XML #

The `Escape_Xml` function replaces XML special characters by the equivalent
XML entities.  The function is limited to the following characters: '<', '>', '&', '''

```
  S      : constant String := ...;
  Result : constant String := Util.Strings.Transforms.Escape_Xml (S);
```

# Escape `JavaScript` #

The `Escape_Javascript` function escape the special characters for Javascript.
The special characters are converted to \n, \b, \t, \r, \f, \uxx.  Single quotes
are prefixed by \.

```
  S      : constant String := ...;
  Result : constant String := Util.Strings.Transforms.Escape_Javascript (S);
```


# Source #

http://code.google.com/p/ada-util/source/browse/trunk/samples/escape.adb