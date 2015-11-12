The **Counters** package defines data types which provide
atomic increment and decrement operations.  It is intended to be used
in a multi-threaded environment.

## Arithmetic Operations Are Not Thread-Safe ##

Lets suppose we have a `Counter` variable of type `Integer`,
the following Ada statement is not thread safe because it is not atomic.
```
  Counter := Counter + 1;
```

The language (and the compiler) cannot guarantee that such operation be atomic.
An instruction can be generated to read the counter, another one to increment and
a third one to save the value.  For example, on a Sparc, the following could
be generated:

```
  ld      [%o0], %g1
  add     %g1, 1, %g1
  st      %g1, [%o0]
```

On x86 processors, the compiler could use an `incl` instruction as follows:

```
  incl %(eax)
```

Still, this is not correct in multi-processor environments.  Since each processor
have their own cache, a concurrent access to the same memory location will result
to unpredictable results.  To avoid this, it is necessary to use special instructions
that will force the memory location to be synchronized.  On x86, this is achieved
by the `lock` instruction.  The following is guaranteed to be atomic on multi-processors:

```
  lock
  incl %(eax)
```

For Sparc, Mips and other processors, the implementation requires to loop until
either a lock is get (Spinlock) or it is guaranteed that no other processor has
modified the counter at the same time.


## Reference Counting ##

The **Counter** type can be used for the implementation of object reference
counting.

### Type Declarations ###
Lets define a type for which we want to track the references.  The record
type could hold the reference counter:

```
with Util.Concurrent.Counters;
use Util.Concurrent;
...
type Node is limited record
   Ref_Counter : Counters.Counter;
   ...
end record;
type Node_Access is access all Node;
```

Now, lets define the type that will hold the access to our object instance.
The goal is to track the references of our instance in order to free it
when there is no reference to it.  For this we use the Ada Finalization
package.

```
type Expression is new Ada.Finalization.Controlled with record
   Node  : Node_Access := null;
   ...
end record;
```

### Adjust ###

The `Adjust` procedure is called immediately after an assignment.
The reference counter has to be updated and is incremented.  The `Increment`
procedure guarantees that the increment is atomic even on a multi-processor
environment (The naive `Counter := Counter + 1` implementation does not guarantee
anything).

```
overriding
procedure Adjust (Object : in out Expression) is
begin
   if Object.Node /= null then
      Counters.Increment (Object.Node.Ref_Counter);
   end if;
end Adjust;
```


### Finalize ###

The `Finalize` procedure is called before the object is finalized.
The reference counter must be decremented and the object can be released when
the counter reaches 0.

```
overriding
procedure Finalize (Object : in out Expression) is
   Is_Zero : Boolean;
begin
   if Object.Node /= null then
      Counters.Decrement (Object.Node.Ref_Counter, Is_Zero);
      if Is_Zero then
         Delete (Object.Node);
      end if;
   end if;
end Finalize;
```

## Implementation ##

### x86 ###

The x86 based implementation uses the `lock` instruction.  The `Increment`
and `Decrement` operations can be inlined.

[Util.Concurrent.Counters](http://code.google.com/p/ada-util/source/browse/trunk/src/asm-x86/util-concurrent-counters.ads)

### Default ###

The default implementation uses an Ada protected type to guarantee the
atomicity.

```
protected type Cnt is
  procedure Increment;
  procedure Decrement (Is_Zero : out Boolean);
  function Get return Natural;
private
  N : Integer := 0;
end Cnt;

type Counter is limited record
  Value : Cnt;
end record;
```

[Util.Concurrent.Counters](http://code.google.com/p/ada-util/source/browse/trunk/src/asm-none/util-concurrent-counters.ads)

## References ##

[Showing multiprocessor issue when updating a shared counter](http://blog.vacs.fr/index.php?post/2011/02/01/Showing-multiprocessor-issue-when-updating-a-shared-counter)