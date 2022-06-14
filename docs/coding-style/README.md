## 5.1 C# 代码风格

我们遵循“Visual Studio” 默认设置作为通用规则。

- **✓ DO** 要使用[Allman 风格](http://en.wikipedia.org/wiki/Indent_style#Allman_style)大括号，也就是每个大括号另起一行开始。

- **X DO NOT** 不要忽略单行语句块的大括号。

    ```cs
    // bad style
    if (value == null) throw new ArgumentNullException(nameof(value));
    
    // good style
    if (value == null)
    {
        throw new ArgumentNullException(nameof(value));
    }
    ```

- **✓ DO** 要使用 4 个空格进行缩进而不是制表符（tabs）。

    `.` 表示空格，`->`表示制表符。

    ```cs
    // bad style
    class Program
    {
    ->  static void Main(string[] args)
    ->  {
    ->  ->  Console.Write("Hello World");
    ->  }
    }
    
    // good style
    class.Program
    {
    ....static.void.Main(string[].args)
    ....{
    ........Console.Write("Hello.World");
    ....}
    }
    ```

- **✓ CONSIDER** 考虑使用只读的属性代替公用类型的字段。

    ```cs
    // bad style
    public readonly int Age = 18;
    
    // good style
    public int Age { get; } = 18;
    ```

- **✓ DO** 要将`readonly`放置在`static`之后，当使用到`static`字段时。

    ```cs
    // bad style
    private readonly static int _age = 18;

    // good style
    private static readonly int _age = 18;
    ```

- **X AVOID** 避免使用`this`关键字，如无绝对的必要。

    ```cs
    public class Staff
    {
        private readonly int _age;
    
        public Staff(int age)
        {
            // bad style
            this._age = age;

            // good style
            _age = age;
        }
    }
    ```

- **✓ DO** 要总是显示地指定可见性（visibility）修饰符。

    ```cs
    // bad style
    class Staff
    {
        int _age;
        ...
    }
    ```

    ```cs
    // good style
    internal class Staff
    {
        private int _age;
        ...
    }
    ```

- **✓ DO** 要将可见性作为第一个修饰符。

    ```cs
    public abstract class Foobar
    {
        // bad style
        abstract public void DoBuzz();
    
        // good style
        public abstract  void DoBuzz();
    }
    ```

- **✓ DO** 要将名字空间的导入指令（using directives）放在文件的顶部，`namespace` 声明的外部，并将`System`名字空间作为第一顺位按字母顺序排序。

    ```cs
    using System;
    using System.Collections.Generic;
    using System.Net.Mail;
    using Alyio.Extensions;
    using Microsoft.AspNetCore;
    using Microsoft.Extensions.Configuration;
    
    namespace Gridsum.WebDissector
    {
    ...
    ```

- **X AVOID** 避免在任何时候使用多于一个的空行。例如，不要在类型成员之间使用两个空行。

    ```cs
     1 // bad style
     2  {
     3      public int Bar { get; set; }
     4
     5
     6
     7      public int DoBuz()
     8      {
     9          return 0;
    10      }
    11  }
    ```

- **X AVOID** 避免使用多余的空格。

    ```cs
    // bad style
    if.(someVar.==.0)...
    {
    ```

    > 在 Visual Studio 中启用“View White Space (Ctrl+E, S)”进行辅助检查。

- **X AVOID** 避免使用 `#region` 预处理指令（preprocessor directives)。

    ```cs
    // bad style
    class MyClass
    {
        #region Constructors
        public MyClass() { ... }
        #endregion
    
        #region public Methods
        public void DoSomething() { ... }
        #endregion
    
        #region Protected Methods
        protected virtual void DoSomethingCore() { ... }
        #endregion
    }
    ```

- **✓ CONSIDER** 考虑在变量类型显而易见时，才使用 `var` 关键字。

    ```cs
    // bad style
    var stream = OpenStandardInput();
    
    // good style
    var stream = new FileStream(...);

    // When the type of a variable is not clear from the context, use an
    // explicit type.
    TextReader stream = OpenStandardInput();
    ```

- **✓ DO** 要在类型引用和方法调用时使用语言特有的关键字而不是 BCL 类型。

    例如，使用`int, string, float` 而不是 `Int32, String, Single` 等等。同样地使用 `int.Parse` 而不是 `Int32.Parse`。

- **✓ DO** 要尽可能使用`nameof(...)`而不是`"..."`。

    ```cs
    // bad style
    public void DoSomething(string someVar)
    {
        if (string.IsNullOrEmpty(someVar))
        {
            throw new ArgumentNullException("someVar");
        }
    }
    ```

    ```cs
    // good style
    public void DoSomething(string someVar)
    {
        if (string.IsNullOrEmpty(someVar))
        {
            throw new ArgumentNullException(nameof(someVar));
        }
    }
    ```

- **✓ CONSIDER** 考虑使用字符串插值（string interpolation）连接短字符串。

    ```cs
    string displayName = $"{nameList[n].LastName}, {nameList[n].FirstName}";
    ```

- **✓ DO** 要使用 `System.Text.StringBuilder` 对象在循环中添加字符串，特别是处理大量本文操作时。

    ```cs
    var phrase = "banananananananananananananananananananananananana";
    var manyPhrases = new StringBuilder();
    for (var i = 0; i < 10_000; i++)
    {
        manyPhrases.Append(phrase);
    }
    ```

- **✓ CONSIDER** 考虑在短小的局部上下文中使用简短的变量名。

    如 `i`,`j`,`k` 在 `for` 循环中的使用。

    ```cs
    for (var i = 0; i < 10; i++) { ... }
    ```

    如 Lambda 或 LINQ 中使用 `o`, `p`, `q` 等等。

    ```cs
    var staffs = new List<Staff> { ... };
    
    var someStaffs = staffs.Where(s => s.Age < 18).ToList();
    ```

- **✓ CONSIDER** 考虑为公用 API 提供文档化注释。

    ```cs
    /// <summary>
    /// The main <c>Math</c> class.
    /// Contains all methods for performing basic math functions.
    /// <list type="bullet">
    /// <item>
    /// <term>Add</term>
    /// <description>Addition Operation</description>
    /// </item>
    /// <item>
    /// <term>Subtract</term>
    /// <description>Subtraction Operation</description>
    /// </item>
    /// <item>
    /// <term>Multiply</term>
    /// <description>Multiplication Operation</description>
    /// </item>
    /// <item>
    /// <term>Divide</term>
    /// <description>Division Operation</description>
    /// </item>
    /// </list>
    /// </summary>
    /// <remarks>
    /// <para>This class can add, subtract, multiply and divide.</para>
    /// <para>These operations can be performed on both integers and doubles.</para>
    /// </remarks>
    public class Math
    {
        // Adds two integers and returns the result
        /// <summary>
        /// Adds two integers <paramref name="a"/> and <paramref name="b"/> and returns the result.
        /// </summary>
        /// <returns>
        /// The sum of two integers.
        /// </returns>
        /// <example>
        /// <code>
        /// int c = Math.Add(4, 5);
        /// if (c > 10)
        /// {
        ///     Console.WriteLine(c);
        /// }
        /// </code>
        /// </example>
        /// <exception cref="System.OverflowException">Thrown when one parameter is max 
        /// and the other is greater than 0.</exception>
        /// See <see cref="Math.Add(double, double)"/> to add doubles.
        /// <seealso cref="Math.Subtract(int, int)"/>
        /// <seealso cref="Math.Multiply(int, int)"/>
        /// <seealso cref="Math.Divide(int, int)"/>
        /// <param name="a">An integer.</param>
        /// <param name="b">An integer.</param>
        public static int Add(int a, int b)
        {
            // If any parameter is equal to the max value of an integer
            // and the other is greater than zero
            if ((a == int.MaxValue && b > 0) || (b == int.MaxValue && a > 0))
                throw new System.OverflowException();
    
            return a + b;
        }
    
        ...
    
        // Divides a double by another and returns the result
        /// <summary>
        /// Divides a double <paramref name="a"/> by another double <paramref name="b"/> and returns the result.
        /// </summary>
        /// <returns>
        /// The quotient of two doubles.
        /// </returns>
        /// <example>
        /// <code>
        /// double c = Math.Divide(4.5, 5.4);
        /// if (c > 1.0)
        /// {
        ///     Console.WriteLine(c);
        /// }
        /// </code>
        /// </example>
        /// <exception cref="System.DivideByZeroException">Thrown when <paramref name="b"/> is equal to 0.</exception>
        /// See <see cref="Math.Divide(int, int)"/> to divide integers.
        /// <seealso cref="Math.Add(double, double)"/>
        /// <seealso cref="Math.Subtract(double, double)"/>
        /// <seealso cref="Math.Multiply(double, double)"/>
        /// <param name="a">A double precision dividend.</param>
        /// <param name="b">A double precision divisor.</param>
        public static double Divide(double a, double b)
        {
            return a / b;
        }
    }
    ```


## 5.2 文件结构

- **✓ DO** 要在项目的 repository 的根目录下创建 `*.sln` 和 `.gitignore` 文件以及 `src` 和 `test` 目录。

    顾名思义，`src` 包含工程/产品的源码项目文件，`test` 包含测试项目文件。

    ```sh
    $ tree -a -I '.git' -L 3 github.com/qqbuby/Alyio.AspNetCore.ApiMessages/
    github.com/qqbuby/Alyio.AspNetCore.ApiMessages/
    |-- .github
    |   `-- workflows
    |       `-- ci.yml
    |-- .gitignore
    |-- Alyio.AspNetCore.ApiMessages.sln
    |-- LICENSE
    |-- README.md
    |-- nuget.config
    |-- src
    |   `-- Alyio.AspNetCore.ApiMessages
    |       |-- Alyio.AspNetCore.ApiMessages.csproj
    |       |-- ApiMessageHandlerMiddleware.cs
    |       |-- ExceptionHandler.cs
    |       |-- Extensions
    |       |-- Filters
    |       |-- Messages
    |       |-- XMessage.Designer.cs
    |       `-- XMessage.resx
    `-- test
        |-- Alyio.AspNetCore.ApiMessages.Tests
        |   |-- .gitignore
        |   |-- Alyio.AspNetCore.ApiMessages.Tests.csproj
        |   `-- ExceptionResultHandlerMiddlewareTests.cs
        `-- Samples
            |-- WebApiMessages.Samples
            `-- WebApiMessages.Samples.Tests
    
    12 directories, 14 files
    ```

- **✓ DO** 要在工程文件的根目录下添加 [.gitignore](https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore) 文件。

    ```console
    # Creates a gitignore file for a dotnet project.
    $ dotnet new gitignore
    ```

    或者

    GitHub 下载链接：[https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore](https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore)。
