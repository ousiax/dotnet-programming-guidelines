本章描述了一般的命名规范，包括如何使用大小写，如何为标识符选择恰当的名字，以及如何使用某些特定的术语。本章还为名字空间、类型、成员、参数、程序集、版本号以及 JSON 的命名提供了具体的规范。

## 1.1 大小写规范

### 1.1.1 标志符的大小写规则

为了区分一个标识符的多个单词，把标识符中的每个单词的首字母大写。不要用下划线来区分单词，或者在标识符中的任何地方使用下划线（私有字段采用 _camelCasing 风格）。有两种合适的方法来大写标志符中的字母：

- **PascalCasing**
- **camelCasing**

PascalCasing 约定被用于除了参数名之外的所有标识符，它把标识符中每个单词的首字母（包括长度为两个字符以上的首字母缩写词）大写，如下面的例子所示：

```cs
PropertyDescriptor
HtmlTag
```

两个字母长的首字母缩写词是一个特例，在这种情况下两个字母都要大写，如下面的标识符所示：

```cs
IOStream
```

cameCasing 约定仅用于参数的名字，它把标识符中除了第一个单词之外的所有单词的首字母大写，如下面的例子所示。在例子中，如果 camelCasing 风格的标识符以两个字母长的首字母缩写词开始，那么这个缩写词都要小写。

```cs
propertyDescriptor
ioStream
htmlTag
```

下面是一些用于标识符的基本大小写规范。

- **✓ DO** 要把 PascalCasing 用于由多个单词构成的名字空间、类型以及成员的名字。
- **✓ DO** 要把 camelCasing 用于参数的名字。

*表 1-1 不同类型的标识符的大小写规则*


标识符      | 大小写    | 样例    |
-------     | --------- | ------- |
名字空间    | Pascal | ```namespace System.Security { ... }```
类型        | Pascal | ```public class StreamReader { ... }```
接口        | Pascal | ```public interface IEnumerable { ... }```
方法        | Pascal | ```public virtual string ToString();```
属性        | Pascal | ```public int Length { get; }```
事件        | Pascal | ```public event EventHandler Exited;```
字段（静态）| Pascal | ```puglic static readonly TimeSpan InfiniteTimeout;```
枚举值      | Pascal | ```File Mode { Append, ...}```
参数        | Camel  | ```public static int ToInt32(string value);```

### 1.1.2 首字母缩写词的大小写

一般来说，避免在标识符的名字中使用首字母缩写词是很重要的，除非他们是普遍使用的，能够立刻被使用的人所理解。例如，HTML、XML 和 IO 很容易理解，但不怎么常用的首字母缩写词绝对应该避免。

> **注：**首字母缩写词（acronyms）与单词缩写（abbreviations）是有区别的，绝对不应该在标识符中使用单词缩写。首字母缩写词是由一个短语的首字母组成的，而单词缩写则仅仅把一个单词的长度变短。

从定义上讲，首字母缩写词必须至少有两个字母。由三个或以上的字母组成的首字母缩写词遵循与任何其他单词一样的规范，只有第一个字母大写，除非是 camelCasing 风格的参数名称中的第一个单词，在这种情况下第一个单词全部小写。例如：

```cs
public void StartIO(Stream ioStream, bool closeIOStream);
public void ProcessHtmlTag(string htmlTag);
```

- **✓ DO** 要把两个字母的首字母缩写词全部大写，除非它是 camelCasing 风格的参数的第一个单词。

    ```cs
    System.IO
    public void StartIO(Stream ioStream);
    ```

- **✓ DO** 要把由三个或者三个以上字母组成的首字母缩写词的第一个字母大写。只有第一个字母大写，除非首字母缩写词是 camelCasing 风格的标识符的第一个单词。

    ```cs
    System.Xml
    public void ProcessHtmlTag(string htmlTag)
    ```

- **X DO NOT** 不要把 camelCasing 风格的标识符头部的任何首字母缩写词的任何字母大写，无论首字母缩写词的长度是多少。

### 1.1.3 复合词和常用术语的大小写

在涉及大小写时，大多数复合词术语要作为单个单词处理。

- **X DO NOT** 不要把所谓闭合形式的复合词中的每个单词的首字母大写。

    这些复合词要写成一个单词，比如 `endpoint`。为了统一大小写规范，我们把闭合形式的复合词作为一个单词处理。

*表 1-2 常用的复合词和常用术语的大小写及拼写*

|   Pascal      | Camel         | Not       |
| ---------     | ---------     | -----     |
| BitFlag       | bitFlag       | Bitflag   |
| Callback      | callback      | CallBack  |
| Canceled      | canceled      | Cancelled |
| DoNot         | doNot         | Dont      |
| Email         | email         | EMail     |
| Endpoint      | endpoint      | EndPoint  |
| FileName      | fileName      | Filename  |
| Gridline      | gridline      | GridLine  |
| Hashtable     | hashtable     | HashTable |
| Id            | id            | ID        |
| Indexes       | indexes       | Indices   |
| LogOff        | logOff        | LogOut    |
| LogOn         | logOn         | LogIn     |
| Metadata      | metadata      | MetaData, metaData |
| Multipanel    | multiplanel   | MultiPanel    |
| Multiview     | multiview     | MultiView |
| Namespace     | namespace     | NameSpace |
| Ok            | ok            | OK        |
| Pi            | pi            | PI        |
| SignIn        | signIn        | SignOn    |
| SignOut       | signOut       | signOff   |
| UserName      | userName      | Username  |
| WhiteSpace    | whiteSpace    | WhiteSpace    |
| Writable      | writable      | Writeable  |

有两个常用的其他术语，它们本身属于另一个类别，因为它们是俚语性质的常用缩写。这两个单词是 `Ok` 和 `Id` (它们的大小写应该如显示的那样），虽然前面的规范说过名字不应该使用缩写，但它们是例外。

## 1.2 通用命名规范

本节描述了一些通用的命名约束，它们涉及到单词的选择、单词缩写和首字母缩写词的使用规范以及如何避免使用编程语言特有的名字。

### 1.2.1 单词的选择

标识符的名字要一目了然，应该清楚地说明每个成员做什么，以及每个类型和参数表示什么。为此，名字的意思清楚要比长度短更重要。

- **✓ DO** 要为标识符选择易于阅读的名字。

    例如，一个名为 `HorizontalAlignment` 的属性就比 `AlignmentHorizontal` 更容易阅读。

- **✓ DO** 要更看重可读性，而不是更看重简短性。属性名 `CanScrollHorizontally` 要胜过 ScrollableX （不太明显地引用到了 X 坐标轴）。

- **X DO NOT** 不要使用下划线、连字符以及其他任何既非字母也非数字的字符。

- **X DO NOT** 不要使用匈牙利命名法。

- **X AVOID** 避免使用与广泛使用的编程语言的关键字有冲突的标识符。如 C# 中的 `@` 符号等。

### 1.2.2 使用单词缩写和首字母缩写

- **X DO NOT** 不要使用缩写词和缩约词（如 won't 是 will not 的缩约词）作为标识符的一部分。例如，要用 `GetWindow`，而不要用 `GetWin`。

- **X DO NOT** 不要使用未被广泛接受的首字母缩写词，即使是被广泛接受的首字母缩写词，也只应该在必须的时候才使用。

### 1.2.3 避免使用语言特有的名字

对那些所谓的基本类型，CLR 平台上的编程语言通常都有自己的名称（别名）来称呼它们。例如 `int` 是 C# 中 `System.Int32` 的别名。

- **✓ DO** 要给类型名使用语义上有意义的名字，而不要使用语言特有的关键字。

    例如，`GetLength` 这个名字比 `GetInt` 要好。

- **✓ DO** 要使用 CLR 的通用类型名，而不要使用语言特有的别名——如果除了类型之外，标识符没有其他的语义。

    例如，一个把类型转换为 `System.Int64` 的方法应该被命名为 `ToInt64`，而不是 `ToLong`。

*表 1-3 语言特有的类型名及对应的 CLR 类型名*

|C#  |Visual Basic |   C++ |    CLR
|----|-------------|------|-------
|sbyte |  SByte  | char            | SByte
|byte  |  Byte   | unsigned char   | Byte
|short |  Short  | short           | Int16
|ushort|  UInt16 | unsigned short  | UInt16
|int   |  Integer|     int         | Int32
|uint  |  UInt32 | unsigned int    | UInt32
|long  |  Long   | \_\_int64         | Int64
|ulong |  UInt64 | unsigned \_\_int64| UInt64
|float |  Single | float           | Single
|double|  Double | double          | Double
|bool  |  Boolean|     bool        | Boolean
|char  |  Char   | wchar\_t         | Char
|string|  String | String          | String
|object|  Object | Object          | Object

- **✓ DO** 要使用常见的名字，比如 `value` 或 `item`，而不要重复类型的名字——如果除了类型之外，标识符没有其他的语义，而且参数的类型不重要。

    下面是一个很好的例子，类提供的这些方法可以把各种不同的数据类型写入流中：

    ```cs
    void Write(double value);
    void Write(float value);
    void Write(short value);
    ```

### 1.2.4 为已有 API 的新版本命名

- **✓ DO** 要在创建已有 API 的新版本时使用与旧 API 相似的名字。

    这有助于突出 API 之间的关系。

    ```cs
    class AppDomain
    {
        [Obsolete("AppDomain.SetCachePath has been deprecated. Please use AppDomainSetup.CachePath instead.")]
        public void SetCachePath(string path) { ... }
    }
    
    class AppDomainSetup
    {
        public string CachePath { get { ... } set { ... } }
    }
    ```

- **✓ DO** 要优先使用后缀而不是前缀来表示已有 API 的新版本。

    这有助于在浏览文档或使用 Intellisense 时发现新版本。由于大多数浏览器和 Intellisense 按字母的顺序显示标识符，因此旧 API  与新 API 在位置上会非常接近。

- **✓ CONSIDER** 考虑使用全新但有意义的标识符，而不是简单地给已有标识符添加后缀或前缀。

- **✓ DO** 要使用数字来表示已有 API 的新版本——如果已有 API 的名字是唯一有意义的名字（也就是说，它是一个工业标准），不适宜添加后缀（或改名）。

    ```cs
    // old API
    [Obsolete("This type is obsolete. Please use the new version of the same class X509Certificate2.")]
    class X509Certificate { ... }
    // new API
    class X509Certificate2 { ... }
    ```
 
- **X DO NOT** 不要在标识符使用“Ex”（或类似的）后缀来区分相同 API 的不同版本。

    ```cs
    // old API
    [Obsolete("This type is obsolete. ...")]
    public class Car { ... }
    
    // new API
    public class CarEx      { ... }     // the wrong way
    public class CarNew     { ... }     // the wrong way
    public class Car2       { ... }     // the wrong way
    public class Automobile { ... }     // the wrong way
    ```

## 1.3 程序集和 DLL 的命名

程序集是一个部署单元，同时还代表托管代码程序的身份。虽然程序集可以分布在同一个或多个文件中，但一般来说一个程序集仅与一个 DLL 相对应。

要记住，名字空间与 DLL 和程序集是不同的概念。名字空间对开发人员来说是一组逻辑实体，而 DLL 和程序集则是在打包和部署时的一个单元。 DLL 可以因产品的组织以及其他原因而包含多个名字空间。由于名字空间的组织方式与 DLL 不同，因此应该单独设计。例如，如果决定把 DLL 命名为 `MyCompany.MyTechnology`，这并意味着 DLL 必须包含名为 `MyCompany.MyTechnology` 的名字空间。

- **✓ DO** 要为程序集和 DLL 选择提示性的名字，比如 `System.Data`，这样很容易就知道它的大致功能。程序集和 DLL 的名字不一定要和名字空间相对应，但在给程序集命名时遵循名字空间的名字也是合情合理的。

- **✓ CONSIDER** 考虑按照下面的模式给 DLL 命名：

    ```
    <Company>.<Component>.[<Subcomponent>.]dll
    ```

## 1.4 名字空间的命名

与其他的命名规范一样，为名字空间命名的目标是清晰，这样对使用的程序员来说，他们就能够立刻知道一个名字空间中大概有些什么。下面的模板给出了名字空间的一般规则：

```none
<Company>.(Product>|<Technology>)[.<Feature>][.<Subnamespace>]
```

下面是一些例子：

```none
System.Collections;
System.Collections.Generic;
System.Linq;
System.Text;
System.Text.RegularExpressions;
System.Threading;
System.Threading.Tasks;

MyCompany.MyProduct;
MyCompany.MyProduct.MyComponent;
```

- **✓ DO** 要用公司名称作为名字空间的前缀，这样就可以避免与另一家公司使用相同的名字。

- **✓ DO** 要用稳定的、与版本无关的产品名称作为名字空间的第二层。

- **X DO NOT** 不要根据公司的组织架构来决定名字空间的层次结构，因为公司内部组织的名字一般来说不会持续太长的时间。

- **✓ DO** 要使用 PascalCasing 大小写风格，并用点号来分隔名字空间中的各部分。如果商标使用了非传统的大小写风格，那么即使该风格与常规的大小写风格相背，也应该遵循商标的大小写风格。

- **✓ CONSIDER** 考虑在适当的时候在名字空间中使用复数形式。

    例如，要使用 `System.Collections`，而不要用 `System.Collection`。但是，商标名称和首字母缩写词除外。例如，要用 `System.IO`, 而不要用 `System.IOs`。

- **X DO NOT** 不要用相同的名字来命名名称空间与位于该名字空间中的类型。

    例如，不要先将名字空间命名为 `Debug`，然后又在名字空间中提供一个名为 `Debug` 的类。许多编译器都要求用户在使用这样的类型时要加上完整的限定符。

**名字空间和类型名的冲突**

名字空间用来把类型组织成一个逻辑、易于浏览的层次结构。对解决在导入多个名字空间是可能引起的类型名的二义性，它们同样是不可或缺的。但即便如此，对那些通常会在一起使用的不同名字空间来说，仍不应该以此为借口在类型之间引入二义性。在常见的场景中，开发人员应该不需要给类型名加上限定符。

- **X DO NOT** 不要引入太一般的类型名，比如 `Element`、`Node`、`Log` 以及 `Message`。

    这样的名字很可能会在常见的场景中引起类型名的冲突。应该给这些一般化的类型名加上修饰语（`FormElement`、`XmlNode`、`EventLog`、`SoapMessage`）。

## 1.5 类、结构和接口的命名

- **✓ DO** 要用名词或者名词词组来给类型命名，在少数情况下也可以用形容词来给类型命名。在命名时要使用 PascalCasing 大小写风格。

- **X DO NOT** 不要给类名加前缀（例如 “C”）。唯一的前缀是用于接口的 `I`（如 `ICollection`）。

- **✓ CONSIDER** 考虑让派生类的名字以基类的名字结尾。

    这样可读性会非常好，而且请清晰地解释它们之间的关系。 例子有：`ArgumentOutOfRangeException`, 它是一种 `Exception`；`SerializableAttribute` ，它是一种 `Attribute`。但是，在运用这一条时，很重要的一点是要做出合理的判断；例如，即使 `Button` 类的名字没有出现 `Control` 字样，它仍然是一种 `Control` 实体。下面是一些正确的命名的例子：

    ```cs
    public class FileStream : Stream { ... }
    public class Button : Control { ... }
    ```

- **✓ DO** 要让接口的名字以字母 `I` 开头，这样可以显示出该类型是一个接口。

    例如，`IComponent` （描述性名称）、`ICustomAttributeProvider` （名词短语）以及 `IPersistable （形容词）都是恰当的接口名字。

- **✓ DO** 要确保一对类/接口的名字只相差一个 `I` 前缀，如果该类是该接口的标准实现。例如：

    ```cs
    public interface IComponent { ... }
    public class Component { ... }
    ```

### 1.5.1 泛型类型参数的命名

- **✓ DO** 要用描述性的名字来命名泛型类型参数——除非一个字母就足够了，而且描述性的名字并不能添加什么价值。

    ```cs
    public interface ISerssionChannel<TSession> { ... }
    public delegate TOutput Converter<TInput, TOutput>(TInput from);
    public class List<T> { ... }
    ```

- **✓ CONSIDER** 考虑用 `T` 来命名参数类型——如果类型只有一个类型参数，而且类型参数只有一个字母。

    ```cs
    public int ICompare<T> { ... }
    public delegate bool Predicate<T>(T item);
    public struct Nullable<T> where T : struct { ... }
    ```

- **✓ DO** 要给描述性的类型参数加上 `T` 前缀。

    ```cs
    public interface ISessionChannel<TSession> whre TSession : ISession
    {
        TSession Session { get; }
    }
    ```

- **✓ CONSIDER** 考虑在类型参数名中显示出施加于该类型参数上的限制。

    例如，可以把一个被限制为`ISession`的类型参数命名为`TSession`。

### 1.5.2 常用类型的命名

如果要从 .NET 框架所包含的类型派生新类型，或者要实现 .NET 框架中的类型，那么遵循本节中的规范是非常重要的。

- **`System.Attribute`**

    - **✓ DO** 要给自定义的标记（attribute） 类添加 `Attribute` 后缀

- **`System.Delegate`**

    - **✓ DO** 要给用于事件处理的委托添加 `EventHandler` 后缀
    - **✓ DO** 要给用于事件处理之外的那些委托添加 `Callback` 后缀
    - **X DO NOT** 不要给委托添加 `Delegate` 后缀

- **`System.EventArgs`**

    - **✓ DO** 要添加 `EventArgs` 后缀

- **`System.Enum`**

    - **X DO NOT** 不要派生自该类：要用编程语言提供的关键字来代替。例如在 C# 中，要用 `enum` 关键字
    - **X DO NOT** 不要添加 `Enum` 或 `Flag` 后缀

- **`System.Exception`**

    - **✓ DO** 要添加 `Exception` 后缀

- **`System.Collections.IDictionary`** 和 **`System.Collections.Generic.IDictionary<TKey, TValue>`**
    - **✓ DO** 要添加 `Dictionary` 后缀。

- **`System.Collections.IEnumerable`**、<br />**`System.Collections.ICollection`**、<br />**`System.Collections.IList`**、<br />**`System.Collections.Generic.IEnumerable<T>`**、<br />**`System.Collections.Generic.ICollection<T>`** 和 <br />**`System.Collections.Generic.IList<T>`**
    - **✓ DO** 要添加 `Collection` 后缀

- **`System.IO.Stream`**

    - **✓ DO** 要添加 `Stream` 后缀

- **`System.Security.CodeAccessPermission`** 和 **`System.Security.IPermision`**

    - **✓ DO** 要添加 `Permission` 后缀

### 1.5.3 枚举类型的命名

- **✓ DO** 要遵循标准的 PascalCasing 大小写的命名规则
- **✓ DO** 要用单数名词来命名枚举类型，除非他表示的是位域（`bit field`）。

    ```cs
    public enum ConsoleColor
    {
        Black,
        Blue,
        Cyan,
        ...
    }
    ```

- **✓ DO** 要用复数名词来命名表示位域的枚举类型，这样的枚举类型也称为标记枚举（`flag enum`）。

    ```cs
    [Flags]
    public enum ConsoleModifiers
    {
        Alt,
        Control,
        Shift
    }
    ```
- **X DO NOT** 不要给枚举类型的名字添加 `Enum` 后缀。

    ```cs
    // bad naming
    public enum ColorEnum
    {
    ...
    }
    ```

- **X DO NOT** 不要给枚举类型的名字添加 `Flag` 或 `Flags` 后缀。

    ```cs
    // Bad naming
    [Flags]
    public enum ColorFlags
    {
    ...
    }
    ```

- **X DO NOT** 不要给枚举类型值的名字添加前缀（例如，给 ADO 枚举类型添加“ad”前缀，给 rich text 枚举类型添加 “rtf”前缀）。

    ```cs
    public enum ImageMode
    {
        ImageModeBitmap = 0, // Image prefix is not necessary
        ImageModeGrayScale = 1,
        ...
    }
    ```

    下面的命名会更好：

    ```cs
    public enum ImageMode
    {
        Bitmap = 0,
        GrayScale = 1,
        ...
    }
    ```

## 1.6 类成员的命名

### 1.6.1 方法的命名

- **✓ DO** 要用动词或动词词组来命名方法。

    ```cs
    public class String
    {
        public int CompareTo(...);
        public string[] Split(...);
        public string Trim(...);
    }
    ```

- **✓ DO** 要使用 `Async` 作为异步方法的后缀。

    ```cs
    public Task<HttpResponseMessage> GetAsync(...) { ... }
    ```

### 1.6.2 属性（Property）的命名

- **✓ DO** 要用名词、名词词组或形容词来命名属性。

    ```cs
    public class String
    {
        public int Length { get; }
    }
    ```
- **X DO NOT** 不要让属性看起来与 "Get" 方法的名字相似，如下面的例子所示。

    ```cs
    public string TextWriter { get { ... } set { ... } }
    public string GetTextWriter(int value) { ... }
    ```

- **✓ DO** 要用肯定的短语 (`CanSeek` 而不是 `CantSeek`）来命名布尔属性。如果有帮助，还可以有选择的给布尔属性添加“Is”、“Can”或“Has”等前缀。

    例如，`CanRead` 要比 `Readable` 更容易理解，但 `Created` 却比 `IsCreated` 的可读性更好。前缀通常是多余的，也没有必要，尤其是在有 Intellisense 的代码编辑器中。输入 `MyObject.Enalbed =` 与输入 `MyObject.IsEanbled =`一样清楚，两种情况下 Intellisense 都会提示你选择 `true` 或 `false`，但后缀更为冗长一些。

    ```cs
    if (collections.Contains(item))     // better
    if (collections.IsContains(item))   // bad
    ```

    ```cs
    if (stream.CanSeek)     // better
    if (stream.IsSeekable)  // bad
    ```

- **✓ CONSIDER** 考虑用属性的类型名来命名属性。

    ```cs
    public enum Color { ... }
    public class Control
    {
        public Color Color { get { ... } set { ... } }
    }
    ```

### 1.6.3 事件的命名

- **✓ DO** 要用动词或动词词组短语来命名事件。

    这样的例子包括 `Clicked`、`Painting`、`DroppedDown` 等等。

- **✓ DO** 要用现在时和过去时来赋予事件名以之前和之后的概念。

- **X DO NOT** 不要用“Before”或“After”前缀或后缀来区分前缀事件或后置事件。

- **✓ DO** 要在命名事件函数（用作事件类型的委托）时加上“EventHandler”后缀，如下面的例子所示：

    ```cs
    public delegate void ClickedEventHandler(object sender, ClickedEventArgs e);
    ```

- **✓ DO** 要在事件函数中用 `sender` 和 `e` 作为两个参数的名字。

    ```cs
    public delegate void <EventName>EventHandler(object sender, <EventName>EventArgs e);
    ```

- **✓ DO** 要在命名事件的参数类是加上“EventArgs”后缀。

    ```cs
    public class ClickedEventArgs: EventArgs
    {
        private readonly int _x;
        private readonly int _y;
    
        public ClickedEventArgs(int x, int y)
        {
            this._x = x;
            this._y = y;
        }
        
        public int X { get { return _x; } }
    
        public int Y { get { return _y; } }
    }
    ```

### 1.6.4 字段的命名

- **✓ DO** 要用名词或名词短语来命名字段。

- **✓ DO** 要在命名常量字段、静态公有字段和静态受保护字段时使用 PascalCasing 大小写风格。

    ```cs
    public class String
    {
        public static readonly string Empty;
    }
    ```

- **✓ DO** 要在命名私有字段时使用 _camelCasing 大小写风格。

    ```cs
    public Coder
    {
        private int _age;
    
        public int Age { get { return _age; } }
    }
    ```

- **X DO NOT** 不要给字段添加前缀。

    例如，不要用“g_”或 “s_”来区分静态或非静态字段。

## 1.7 参数的命名

- **✓ DO** 要在命名参数时使用 camelCasing 大小写风格。

    ```cs
    public class String
    {
        public bool Contains(string value);
        public string Remove(int startIndex, int count);
    }
    ```

- **✓ DO** 要使用具有描述性的参数名。

    参数名应该具备足够的描述性，使得在大多数情况下，用户根据参数的名字和类型就能够确定他的意思。

- **✓ CONSIDER** 考虑根据参数的意思而不是参数的类型命名参数。

## 1.8 JSON 的命名

- **✓ DO** 要在命名 JSON 的属性名时使用 camelCasing 大小写风格。

    ```cs
    public class Coder
    {
        public int Age { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        ...
    }
    ```
    
    ```json
    {
      "age": 18,
      "firstName": "ROY",
      "lastName": "XU",
      ...
    }
    ```

## 1.9 版本号的命名

- **✓ DO** 要按照下面的语义化版本的格式命名程序集、DLL、NuGet 以及软件的发行版本号等等。

    ```
    MAJOR.MINOR.PATCH
    ```

    - **MAJOR** version 非兼容性修改
        > when you make incompatible API changes,
    - **MINOR** version 兼容性修改
        > when you add functionality in a backwards-compatible, and
    - **PATH** version 兼容性的缺陷修复
        > when you make backwards-compatible bug fixes.

    其他可选的标签用于对 MAJOR.MINOR.PATCH 格式的一些信息补充，比如 aplha, beta, preview 等等

    > Additional lablels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

    > For more information, see [https://semver.org/](https://semver.org/).
