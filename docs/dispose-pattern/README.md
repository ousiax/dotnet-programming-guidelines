所有的程序在执行过程中都会使用或多或少的系统资源，比如内存、文件句柄以及数据库连接。在使用这些系统资源时，开发人员一定要小心，因为它们必须在用完后释放。

CLR 提供了自动内存管理（automatic memory management）。**托管内存**（managed memory，用 C# 的 `new` 操作符分配的内存）不需要显示地由开发人员释放，**垃圾收集器**（garbage collector，GC）会自动地释放它们。

令人遗憾的是，托管内存只是多种系统资源中的一种，托管内存之外的资源仍然需要由开发人员显示地释放。我们把这些资源称为**非托管资源**（unmanaged resources）。GC 并不是专门设计用来管理这些非托管资源的，这意味着释放非托管资源的责任落到了开发人员的肩上。

CLR 为释放非托管资源提供了一些帮助。`System.Object` 声明了一个虚方法 `Finalize`（也称为**终结方法**，finalizer），GC 会在回收对象占用的内存之前调用该方法，这样开发人员就可以覆盖该方法来释放非托管资源。覆盖了终结方法的类型也称为**可终结**（finalizable）类型。

虽然终结方法在某些需要进行清理的情况下是有效的，但是它有两个严重的缺点：

- 只有 GC 检测到某个对象可以被回收时才会调用该对象的终结方法，这发生在不再需要资源之后的某个不确定的时间。这样一来，开发人员可以或希望释放资源的时刻与资源实际被终结方法释放的时刻之间会有一个延迟。如果程序需要使用许多稀缺资源（容易耗尽的资源）或不释放资源的代价会很高（例如，大块的非托管内存），那么这样的延迟可能会让人无法接受。

- 当 CLR 需要调用终结方法时，它必须把回收对象内存的工作推迟到垃圾收集的下一轮（终结方法会在两轮垃圾收集之间运行），这意味着对象的内存会在很长一段时间得不到释放。

因此，如果需要尽快回收非托管资源，或者资源很稀缺，或者对性能要求极高以至于无法接受在 GC 时增加的额外开销，那么在这种情况下完全依靠终结方法可能不太合适。

.NET 提供了 `System.IDisposable` 接口，该接口为开发人员提供了一种手动释放非托管资源的方法，可以用来立即释放不再需要的非托管资源。 .NET 同时提供了 `GC.SupperessFinalize` 方法，该方法可以告诉 GC 已经对对象进行了手动清理，因此不需要再调用 `Finalize` 方法。在这种情况下，GC 可以更早地回收对象所占用的内存。我们把那些实现了 `IDisposable` 接口的类型称为**可处置**（disposable）类型。

Disposable 模式的目的是为了使终结方法和 `IDisposable` 接口的使用和实现得以标准化。

Dispoable 模式的主要动机是为了降低 `Finalize` 和 `Dispose` 方法在实现时的复杂度，复杂度的产生是由于两个方法共享一部分逻辑，但并非全部。

- **✓ DO** 要为含有可处置类型实例的类型实现[基本 Dispose 模式](#41-基本-dispose-模式)。

    如果一个类型负责管理其他可处置对象的生命期，那么开发人员同样需要一种方法来处理它，而为外层类型实现[基本 Dispose 模式](#41-基本-dispose-模式)方法则是最方便的方法。

- **✓ DO** 要为类型实现[基本 Dispose 模式](#41-基本-dispose-模式)并提供终结方法，如果类型持有需要由开发人员显示释放的类型，而后者本身没有终结方法。

- **✓ CONSIDER** 考虑为类实现 Dispose 模式，如果类本身并不持有非托管资源或可处置对象，但它的子类却可能会持有非托管资源或可处置对象。

    `System.IO.Stream` 类是一个非常好的例子。虽然它是一个抽象基类，不持有任何资源，但它的大多数子类会持有资源，正因为如此它才实现了[基本 Dispose 模式](#41-基本-dispose-模式)。

## 4.1 基本 Dispose 模式

Dispose 模式的基本实现涉及实现 `System.IDisposable` 接口和声明 `Dispose(bool)` 方法，后者用来进行所有的资源清理工作。`Dispose` 方法和终结方法都会用到 `Dispose(bool)`，但终结方法不是必须的。

```cs

class DisposableResourceHolder : IDisposable
{
    private SafeHandle _resouce;    // handle to a resource

    public DisposableResourceHolder()
    {
        _resouce = ...;    // allocates the resource
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            if (_resouce != null)
            {
                _resouce.Dispose();
            }
        }
    }
}
```

布尔参数 `disposing` 表示 `Dispose(bool)` 方法的调用者是 `IDisposable.Dispose` 方法还是终结方法。`Dispose(bool)` 的实现应该在访问其他的引用对象（例如，前面样例代码中的 `_resource` 字段）之前检查该参数。只有当调用者是 `IDisposable.Dispose` 方法时（当 `disposing` 参数为 `true` 时），才能访问此类对象。如果调用者是终结方法，那么不应该访问其他对象。这样做的原因是系统会以任意的顺序终结对象，在这种情况下，对象或对象依赖的对象可能已经被终结了。

- **✓ DO** 要声明 `protected virtual void Dispose(bool disposing)` 方法，来把所有与非托管资源有关的清理工作集中在一起。

- **✓ DO** 要按下面的方法来实现 `IDisposable` 接口，即先调用 `Dispose(true)`，然后再调用 `GC.SuppressFinalize(this)`。

    ```cs
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }
    ```

- **X DO NOT** 不要使无参的 `Dispose` 方法为虚方法。

    ```cs
    // bad design
    class DisposableResourceHolder : IDisposable
    {
        public virtual void Dispose() { ... }
        protected virtual void Dispose(bool disposing) { ... }
    }
    
    // good design
    class DisposableResourceHolder : IDisposable
    {
        public void Dispose() { ... }
        protected virtual void Dispose(bool disposing) { ... }
    }
    ```

- **X DO NOT** 不要为 `Dispose` 方法声明除了 `Dispose()` 和 `Dispose(bool)` 之外的任何其他重载方法。

- **✓ DO** 要允许多次调用 `Dispose(bool)` 方法。它可以在第一次调用之后就什么也不做。

    ```cs
    class DisposableResourceHolder : IDisposable
    {
        private bool _disposed = false;
    
        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
            {
                return;
            }

            // cleanup
            ...

            _disposed = true;    
        }
    }
    ```

- **X AVOID** 避免从 `Dispose(bool)` 方法中抛出异常，除非是紧急情况，所处的线程已被破坏（泄漏、共享状态不一致，等等）。

- **✓ DO** 要从成员中抛出 `ObjectDisposedException` 异常，如果该成员在对象被 dispose 之后就无法继续使用。

    ```cs
    class DisposableResourceHolder : IDisposable
    {
        private SafeHandle _resouce;    // handle to a resource
        private bool _disposed = false;
    
        public void DoSomething()
        {
            if (_disposed)
            {
                throw new ObjectDisposedException(...);
            }
    
            // now call some native methods using the resource
            ...
        }
    
        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
            {
                return;
            }
    
            // cleanup
            ...
    
            _disposed = true;
        }
    }
    ```

- **✓ CONSIDER** 考虑在 `Dispose()` 方法之外再提供一个 `Close()` 方法，如果 **Close** 是该领域的一个标准术语。

    ```cs
    class Stream : IDisposable
    {
        void IDisposable.Dispose()
        {
            Close();
        }
    
        public void Close()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
    ```

## 4.2 可终结类型

如果类型覆盖了终结方法，并在 `Dispose(bool)` 方法中加入支持终结的代码，以此来扩展[基本 Dispose 模式](#41-基本-dispose-模式)，那么这些类型就是**可终结类型**。

> **对待终结方法的态度应该是，能不写就不写。**为类型编写终结方法会增加其开销，变得难以使用，即使终结方法从未被调用。例如，分配一个可终结对象的开销较高，这是因为系统必须将其放入**可终结对象的列表**（finalization queue）中。

```cs
public class ComplexResourceHolder : IDisposable
{
    private IntPtr _buffer;  // unmanaged memory buffer

    private SafeHandle _resource;    // disposable handle to a resouce

    public ComplexResourceHolder()
    {
        _buffer = ...       // allocates memory
        _resource = ...     // allocates the resource
    }

    protected virtual void Dispose(bool disposing)
    {
        ReleaseBuffer(_buffer);     // release unmanaged memory

        // release other disposable objects
        if (disposing)
        {
            if (_resource != null)
            {
                _resource.Dispose();
            }
        }
    }

    ~ComplexResourceHolder()
    {
        Dispose(false);
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }
}
```

- **X AVOID** 避免使类型为可终结。

    对每一种你认为需要终结方法的情况，都要仔细考虑。带终结方法的类型无论从性能还是从代码复杂度的角度来说，都存在实际的开销。要尽可能使用 `SafeHandle` 之类的资源封装类来封装非托管资源，这样一来就不要终结方法了，因为资源封装类会负责清理它所拥有的资源。

    > 当然，如果你要自己实现托管的封装类来封装非托管资源，那么这些封装类仍必须是可终结类型。

- **✓ DO** 要使类型为可终结，如果该类型要负责释放本身并不具备终结方法的非托管资源。

- **✓ DO** 要为所有的可终结类型实现[基本 Dispose 模式](#41-基本-dispose-模式)。

- **X DO NOT** 不要在终结方法调用的代码中访问任何可终结对象，这样做有很大的风险，因为对象可能已经被终结了。

- **X DO NOT** 不要在终结方法中放过任何异常，除非是致命的系统错误。
