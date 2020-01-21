## 2.1 抛出异常

- **X DO NOT** 不要返回错误码。

- **✓ DO** 要通过抛出异常的方式来报告操作失败。

    > 操作失败就是成员不能完成应该完成的任务（成员的名字所暗示的任务）。例如，如果`OpenFile`方法无法打开文件并将文件句柄返回给调用方，那么这就可以称为操作失败。

- **X DO NOT** 不要在正常的控制流中使用异常，如果能够避免的话。

    ```cs
    // Tester-Doer 模式
    ICollection<int> collection = ...;
    if (!collection.IsReadOnly) // tester
    {
        collection.Add(additionalNumber);   // doer
    }
    ```

    ```cs
    if (int.TryParse(..., out var number)) { ... } // Try-Parse 模式
    ```
- **✓ CONSIDER** 考虑抛出异常可能会对性能造成的影响。

- **✓ DO** 要为所有的异常撰写文档，并把它们作为协定的一部分，前提是这些异常是由于违反公用（public）成员的协定而抛出的。

    异常是协定的一部分，不应该随版本而变化（也就是说，既不应该改变异常的类型，也不应该增加新的异常）。

- **X DO NOT** 不要让公有成员根据某个选项决定是否抛出异常。

    ```cs
    // bad design
    public Type GetType(string name, bool throwOnError)
    ```

- **X DO NOT** 不要把异常用作公有成员的返回值或输出参数。

    ```cs
    // bad desgin
    public Exception DoSomething() { ... }
    ```

- **✓ CONSIDER** 考虑使用辅助方法来创建异常。

   从不同的地方抛出一个异常是很常见的，为了避免代码重复，可以使用辅助函数来创建异常并对其属性进行初始化。

    另外，抛出异常的成员无法被内联（inlining），如果把抛出异常的语句移到辅助函数中，那么成员就有可能被内联。例如：
 
    ```cs
    class File
    {
        public byte[] Read(int bytes)
        {
            if (!ReadFile(handle, bytes))
            {
                ThrowNewFileIOException(...);
            }
        }
    
        void ThrowNewFileIOException(...)
        {
            string description = ... ;// build localized string
            throw new FileIOException(description);
        }
    }
    ```

- **X DO NOT** 不要在异常筛选器（exception filter）中抛出异常。

    如果在异常筛选器中触发异常，那么 CLR 会捕获异常，筛选器会返回 false。由于同实际运行筛选器并显示地返回 false 相比，这两种情况很难区分，因此调试起来会非常困难。

    ```cs
    // This is bad desgin. The exception filter (when clause)
    // may throw an exception when the InnerException property
    // returns null.
    try
    {
        // ...
    }
    catch (Exception e) when (e.InnerException.Message.StartsWith("File"))
    {
        // ...
    }
    ```

- **X AVOID** 避免显示地从 finally 代码块中抛出异常。隐式地抛出异常，即在调用其他方法时由其他方法抛出异常，是可以接受的。

## 2.2 为抛出的异常选择合适的类型

- **✓ CONSIDER** 考虑优先使用 System 名字空间中已有的异常，而不是自己创建新的异常。

- **✓ DO** 要使用自定义的异常类型，如果对错误的处理方式与其他已有的异常有所不同。否则的话，应该使用已有的异常。

- **X DO NOT** 不要仅仅为了拥有自己的异常而创建并使用新的异常。

- **✓ DO** 要使用最合理、最具针对性的异常。

    例如，如果传入的参数是 `null`，那么应该抛出 `ArgumentNullException`，而不是其基类 `ArgumentException`。

- **X AVOID** 避免抛出 `System.Exception` 异常。

### 2.2.1 错误消息的设计

- **✓ DO** 要在抛出异常时为开发人员提供丰富而有意义的错误消息。

- **X AVOID** 避免在异常消息中使用问号和惊叹号。

- **X DO NOT** 不要在没有得到许可的情况下在异常消息中泄漏安全信息。

- **✓ CONSIDER** 考虑把抛出的异常消息本地化，如果希望组件为说不同语言的开发人员所使用。

### 2.2.2 异常处理

> 如果用 `catch` 代码块来捕获某个特定类型的异常，并完全理解在 `catch` 代码块之后继续执行对应用程序来说意味着什么，那么我们说这种情况是对异常进行了处理。举个例子，在试图打开一个配置文件时，如果文件不存在，那么可以捕获 `FileNotFoundException`，并在这种情况下使用默认的配置文件。

> 如果捕获的异常具体类型不确定（通常都是如此），并在不完全理解失败的原因或没有对失败做出反应的情况下让应用程序继续执行，那么我们说着种情况是把异常吞了。

- **X AVOID** 避免在应用程序的代码中，在捕获具体类型不确定的异常（比如 `System.Exception`、`System.SystemException` 等等）时，把错误吞了。

    ```cs
    try
    {
        File.Open(...);
    }
    catch (Exception e) { } // swallow 'all' exceptions - don't do this!
    ```

- **✓ CONSIDER** 考虑捕获特定类型的异常，如果理解该异常在具体环境中产生的原因，并能对错误做出适当的反应。

- **X DO NOT** 不要捕获不应该捕获的异常。通常应该允许异常沿着调用栈向上传递。

- **✓ DO** 要在清理工作时使用 try-finally, 避免使用 try-catch。

    ```cs
    FileStream stream = null;
    try
    {
        stream = new FileStream(...);
    }
    finally
    {
        if (stream != null)
        {
            stream.Close();
        }
    }
    ```
    
    ```cs
    // C# 提供了 using 语句，这样在清理那些实现了 IDisposable 接口的对象时，就
    // 可以使用 using 语句而不必用 try-finally。
    using (FileStream stream = new FileStream(...))
    {
        // ...
    }
    ```

- **✓ DO** 要在捕获并重新抛出异常时使用空的 `throw` 语句。这是保持调用栈的最好方法。

   ```cs
   public void DoSomething(FileStream file)
   {
       long position = file.Position;
       try
       {
           ...; // do some reading with the file
       }
       catch
       {
           file.Position = position;   // unwind on failure
           throw;  // rethrow
       }
   }
   ```
    > 当抛出新的异常时（与重新抛出原来的异常相比），所报告的错误不再是实际发生的错误，而这不利于应用程序的调试。因此，应该优先重新抛出原来的异常，而不要抛出新的异常。最好是完全避免捕获和（重新）抛出异常。

## 2.3 自定义异常的设计

- **X AVOID** 避免太深层次的继承层次。

- **✓ DO** 要从 `System.Exception` 或其他常用的异常基类派生新的异常类。

- **✓ DO** 要在命名异常类时使用 "Exception" 后缀。

- **✓ DO** 要使异常可序列化。为了使异常能够在跨应用程序和跨远程边界时仍能正常工作，这样做是必须的。

- **✓ DO** 要为所有的异常（自少）提供下面这些常用的构造函数。

    要确保参数的名字和类型与下面的例子完全一样。

    ```cs
    public class SomeException : Exception
    {
        public SomeException()
        {
        }
    
        public SomeException(string message) : base(message)
        {
        }
    
        public SomeException(string message, Exception innerException) : base(message, innerException)
        {
        }
    
        // this constructor is needed for serialization
        protected SomeException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
    ```

- **✓ DO** 要通过 `ToString` 的重载方法来报告对安全敏感的信息，前提是必须先获得相应的许可。

- **✓ CONSIDER** 考虑为异常定义属性，这样就能够从程序中获得与异常相关的（除了消息字符串之外的）额外信息。

## 2.4 异常与性能

- **X DO NOT** 不要因异常可能对性能造成的负面影响而使用错误码。

- **✓ CONSIDER** 考虑在方法中使用 Tester-Doer 模式来避免异常而引起的性能问题，如果该方法在普通的场景中都可能会抛出异常。

    ```cs
    // Tester-Doer 模式
    ICollection<int> numbers = ...
    ...
    if (!numbers.IsReadOnly)    // 用来对条件进行测试的成员称为 tester.
    {
        numbers.Add(1); // 用来执行实际的操作并可能会抛出异常的成员称为 doer.
    }
    ```

    > 如果有多个线程同时访问一个对象，那么可能会出现问题。例如，一个线程可能运行 tester 方法并通过测试，但在 doer 方法运行时，另一个线程可能会改变对象的状态并导致 doer 的操作失败。虽然这个模式可能会提供性能，但是它也会引入竟态条件，因此在使用时必须极其小心。

- **✓ CONSIDER** 考虑在方法中使用 Try-Parse 模式来避免因异常而引起的性能问题，如果该方法在普通的场景中都可能会抛出异常。

    ```cs
    public struct DateTime
    {
        public static DateTime Parse(string dateTime) { ... }
        public static bool TryParse(string dateTime, out DateTime result) { ... }
    }
    ```

    - **✓ DO** 要在实现 Try-Parse 模式时使用 “Try”前缀，并用布尔类型作为方法的返回类型。
    - **✓ DO** 要为每个使用 Try-Parse 模式的方法提供一个会抛出异常的对应成员。
