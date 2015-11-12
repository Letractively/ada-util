## Introduction ##
The `Listeners` package implements a simple observer/listener design pattern.
A subscriber registers to a list.  When a change is made on an object, the
application can notify the subscribers which are then called with the object.

## Creating the listener list ##
The listeners list contains a list of listener interfaces.

```
  L : Util.Listeners.List;
```

The list is heterogeneous meaning that several kinds of listeners could
be registered.

## Creating the observers ##
First the `Observers` package must be instantiated with the type being
observed.  In the example below, we will observe a string:

```
  package String_Observers is new Util.Listeners.Observers (String);
```

## Implementing the observer ##
Now we must implement the string observer:

```
  type String_Observer is new String_Observer.Observer with null record;
  procedure Update (List : in String_Observer; Item : in String);
```

## Registering the observer ##
An instance of the string observer must now be registered in the list.

```
  O : aliased String_Observer;
  L.Append (O'Access);
```

## Publishing ##
Notifying the listeners is done by invoking the `Notify` operation
provided by the `String_Observers` package:

```
  String_Observer.Notify (L, "Hello");
```


---

[Generated by Dynamo](http://code.google.com/p/ada-gen) _from util-listeners.ads_