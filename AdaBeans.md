# Introduction #

A [Java Bean](http://en.wikipedia.org/wiki/JavaBean) is an object that allows to access its properties through getters and setters.
Java Beans rely on the use of Java introspection to discover the Java Bean object properties.

An Ada Bean has some similarities with the Java Bean as it tries to expose
an object through a set of common interfaces.  Since Ada does not have introspection, some developer work is necessary.
The Ada Bean framework consists of:

  * An `Object` concrete type that allows to hold any data type such as boolean, integer, floats, strings, dates and Ada bean objects.
  * A `Bean` interface that exposes a `Get_Value` and `Set_Value` operation through which the object properties can be obtained and modified.
  * A `Method_Bean` interface that exposes a set of method bindings that gives access to the methods provided by the Ada Bean object.

The benefit of Ada beans comes when you need to get a value or invoke
a method on an object but you don't know at compile time the object or method.
That step being done later through some external configuration or presentation file.

The Ada Bean framework is the basis for the implementation of
[Ada Server Faces](http://code.google.com/p/ada-asf/) and [Ada EL](http://code.google.com/p/ada-el/).

# Bean Declaration #

The Ada Bean object has to implement the **Readonly\_Bean** or the **Bean** interface.
The former exposes only a getter operation while the later also exposes the setter operation.

```
with Util.Beans.Basic;
with Util.Beans.Objects;
...

   type Compute_Bean is new Util.Beans.Basic.Bean with record
      Height : My_Float := -1.0;
      Radius : My_Float := -1.0;
   end record;

   --  Get the value identified by the name.
   overriding
   function Get_Value (From : Compute_Bean;
                       Name : String) return Util.Beans.Objects.Object;

   --  Set the value identified by the name.
   overriding
   procedure Set_Value (From  : in out Compute_Bean;
                        Name  : in String;
                        Value : in Util.Beans.Objects.Object);
```


# Bean Implementation #


The getter and setter will identify the property to get or set through a name. The value is represented by an `Object` type that can hold several data types (boolean, integer, floats, strings, dates, ...). The getter looks for the name and returns the corresponding value in an `Object` record. Several `To_Object` functions helps in creating the result value.

```
   function Get_Value (From : Compute_Bean;
                       Name : String) return Util.Beans.Objects.Object is
   begin
      if Name = "radius" and From.Radius >= 0.0 then
         return Util.Beans.Objects.To_Object (Float (From.Radius));

      elsif Name = "height" and From.Height >= 0.0 then
         return Util.Beans.Objects.To_Object (Float (From.Height));

      else
         return Util.Beans.Objects.Null_Object;
      end if;
   end Get_Value;
```