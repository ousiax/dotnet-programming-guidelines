## 3.1 数组（Arrays） 

- **✓ DO** 要在公用（public）API 中优先使用集合，而不是优先使用数组。

    ```cs
    public class Order
    {
        public Collection<OrderItem> Items { get { ... } }
    }
    ```

- **X DO NOT** 不要使用只读的数组字段。虽然字段本身是只读的，用户不能对其进行修改，但用户可以修改数组的元素。

    ```cs
    public sealed class Path
    {
        public static readonly char[] InvalidPathChars =
            { '\"', '<', '>', '|' };
    
    }
    ```

    事实上用户可以修改数组中的值，就像下面这样：

    ```cs
    Path.InvalidPathChars[0] = 'A';
    ```

- **✓ CONSIDER** 考虑使用不规则数组（jagged array），不要使用多维数组。

    ```cs
    // jagged array
    int[][] jaggedArray = {
        new int[] { 1, 2, 3, 4 },
        new int[] { 5, 6, 7 },
        new int[] { 8 },
        new int[] { 9 },
    };
    
    // multidimensional arrays
    int[,] multiDimArray = {
        { 1, 2, 3, 4 },
        { 5, 6, 7, 0 },
        { 8, 0, 0, 0 },
        { 9, 0, 0, 0 },
    };
    ```

## 3.2 标记（Attributes） 

标记（attribute）是一种注解，可以用于各种编程元素，比如程序集、类型、成员、参数。它们存储在程序集的元数据中，在运行时可以通过反射 API 来访问。

- **✓ DO** 要在命名自定义 attribute 类时添加“Attribute”后缀。

- **✓ DO** 要在自定义的 attribute 时使用 `AttributeUsageAttribute`。

- **✓ DO** 要为可选参数（optional property, 或 optional argument）提供可设置的属性（Property）。

    ```cs
    public class NameAttribute : Attribute
    {
        ...
        public int Age { get { ... } set { ... } } // optional argument
    }
    ```

- **✓ DO** 要为必填参数（required property 或 required argument）提供只读属性。

    ```cs
    public class NameAttribute : Attribute
    {
        public NameAttribute(string userName) { ... } // required argument
        public string UserName { get { ... } }
        ...
    }
    ```

- **✓ DO** 要提供构造函数参数来对必填参数进行初始化。每个参数应该与相同的属性名相同（虽然大小写会不同）。

    ```cs
    public class NameAttribute : Attribute
    {
        public NameAttribute(string userName) { ... } // required argument
        public string UserName { get { ... } } // required argument
        ...
    }
    ```

- **X AVOID** 避免提供构造函数参数来对与可选参数对应的属性进行初始化。

    ```cs
    // bad design
    public class NameAttribute : Attribute
    {
        public NameAttribute(string userName) { ... } // required argument
        public string UserName { get { ... } set { ... } } // optional argument
        ...
    }
    ```

- **X AVOID** 避免对自定义 attribute 的构造函数进行重载（overload）。

    ```cs
    // bad design
    public class NameAttribute : Attribute
    {
        public NameAttribute() { ... }
        public NameAttribute(...) { ... }
        ...
    }
    ```

- **✓ DO** 要尽可能将自定义 attribute 类密封（sealed）起来。这样会使查找 attribute 更快。

    ```cs
    public sealed class NameAttribute : Attribute { ... }
    ```

## 3.3 集合（Collections）

- **X DO NOT** 不要在公用 API 中使用弱类型集合。

    如果返回值和参数表示一个集合元素，那么其类型应该与元素类型完全一致，而不应该是元素类型的任何基类（这只适合与集合的公用成员）例如，存储 `Component` 的集合不应该提供以 `object` 为参数的公用 `Add` 方法，或以 `IComponent` 为返回值的公用索引器。

    ```cs
    // bad desgin
    public class ComponentDesigner
    {
        public IList Components { get { ... } }
    }
    
    // good desgin
    public class ComponentDesigner
    {
        public Collection<Component> Components { get { ... } }
        ...
    }
    ```

- **X DO NOT** 不要在公用 API 中使用 `ArrayList` 或 `List<T>`。

    ```cs
    // bad desgin
    public class Order
    {
        public List<OrderItem> Items { get { ... } }
        ...
    }
    
    // good desgin
    public class Order
    {
        public Collection<OrderItem> Items { get { ... } }
        ...
    }
    ```

- **X DO NOT** 不要在公用 API 中使用 `HashTable` 或者 `Dictionary<TKey, TValue>`。


- **✓ DO** 要用最泛的类型（即继承层次中最靠近基类的类型）作为参数类型。大多数以集合为参数的成员都使用 `IEnumerable<T>` 接口。

    ```cs
    public void PrintNames(IEnumerable<string> names)
    {
        foreach (var name in names)
        {
            Console.WriteLine(name);
        }
    }
    ```

- **X AVOID** 避免使用 `ICollection<T>` 或 `ICollection` 来做参数，如果其目的仅仅是为了访问该接口的 `Count` 属性。

- **X DO NOT** 不要提供可设置的集合属性。

    ```cs
    // bad desgin
    public class Order
    {
        public Collection<OrderItem> Items { get { ... } set { ... } }
        ...
    }

    // good desgin
    public class Order
    {
        public Collection<OrderItem> Items { get { ... } }
        ...
    }
    ```

- **✓ DO** 要用 `Collection<T> `或其子类作为属性或返回值来表示可读写的集合。

    ```cs
    public Collection<Session> Sessions { get; }
    ```

- **✓ DO** 要用 `ReadOnlyCollection<T>` 或其子类作为属性或返回值来表示只读集合。

    ```cs
    public ReadOnlyCollection<Session> Sessions { get; }
    ```

- **X DO NOT** 不要从集合属性或者集合为返回值的方法中返回 `null`。替代方法是返回一个空集合或者空数组。

    > 一般来说，应该以相同的方式处理 `null` 和 空集合（元素数量为零）或空数组。

## 3.4 IComparable&lt;T&gt; 与 IEquatable&lt;T&gt;

`IComparable<T>` 和 `IEquatable<T>` 都能用来对对象进行比较，前提是对象必须实现这两个接口。`IComparable<T>` 比较的是顺序（小于、等于、大于），主要用于排序。`IEquatable<T>` 比较的是相等性，`IComparable<T>` 主要用于查找。

- **✓ DO** 要为值类型实现 `IEquatable<T>`。

    值类型的 `Object.Equals` 方法会导致**装箱**（boxing）操作，而且因为它的默认实现使用了反射，所以效率不高。`IEquatable<T>` 可以提供好的多的性能，而且在实现时可以完全避免装箱操作。

- **✓ DO** 要在实现 `IEquatable<T>.Equals` 时，同时遵循为覆盖（override）`Object.Equals` 而制定的自反性、对称性、传递性等规范。

- **✓ DO** 要在实现 `IEquatable<T>.Equals` 时，同时覆盖`Object.Equals`。

    ```cs
    public struct PostiveInt32 : IEquatable<PostiveInt32>
    {
        public bool Equals(PostiveInt32 other) { ... }
    
        public override bool Equals(object obj)
        {
            if (!(obj is PostiveInt32))
            {
                return false;
            }
    
            return Equals((PostiveInt32)obj);
        }
    }
    ```

- **✓ CONSIDER** 考虑在实现 `IEquatable<T>` 同时重载 `operator ==` 和 `operator !=`。

    ```cs
    public struct Decimal : IEquatable<Decimal>, ...
    {
        public bool Equals(Decimal other) { ... }
    
        public override bool Equals(object obj)
        {
            if (!(obj is Decimal))
            {
                return false;
            }
    
            return Equals((Decimal)obj);
        }
    
        public static bool operator ==(Decimal x, Decimal y)
        {
            return x.Equals(y);
        }
    
        public static bool operator !=(Decimal x, Decimal y)
        {
            return !x.Equals(y);
        }
    }
    ```

- **✓ DO** 要在实现 `IComparable<T>` 的同时实现 `IEquatable<T>`。

- **✓ DO** 要在实现 `IComparable<T>` 的同时重载比较操作符（`<`、`>`、`<=`、`>=`）。

## 3.5 对象（Object）

### 3.5.1 Object.Equals

值类型的 `Object.Equals` 的默认实现是，只有当两个对象的所有字段都相等时才返回 `true`。我们称这种相对为**值相等**（value equality）。默认实现使用了反射来访问字段，正因如此，其性能通常无法接受，因此需要覆盖。

引用类型的 `Object.Equals` 的默认实现是，只有当两个引用都指向同一个对象是才返回 `true`。我们称这种相对为**引用相等**（reference equality）。有些引用类型对默认实现进行了覆盖，以提供值相等语义。例如，由于字符串的值是由字符串中字符决定的，因此任何两个字符串实例只要包含完全相同的字符排列，`String` 类的 `Equals` 方法就会返回 `true`。

- **✓ DO** 要在覆盖`Object.Equals` 方法时，遵循它定义的协定。

    - `x.Equals(x)` 返回 `true`。   // 自反性
    - `x.Equals(y)` 的返回值与 `y.Equals(x)` 相同。 // 对称性
    - 如果 `(x.Equals(y) && y.Equals(z))` 返回 `true`，那么 `x.Equals(z)` 应该返回 `true`。 // 传递性
    - `x.Equals(null)` 应该返回 `false`。

- **✓ DO** 要在覆盖`Object.Equals` 方法的同时，覆盖 `GetHashCode` 方法。

- **✓ CONSIDER** 考虑在覆盖`Object.Equals` 方法的同时实现 `IEquatable<T>` 接口。

- **X DO NOT** 不要从 `Object.Equals` 方法中抛出异常。

### 3.5.2 Object.GetHashCode

对象的身份由它们的相等语义来决定，而散列函数则用来产生一个与对象的身份相对应的数（散列码）。由于散列码为散列表所用，因此理解散列表的工作原理是很重要的，这样才能很好地实现散列函数。

- **✓ DO** 要覆盖`Object.GetHashCode` 方法，如果覆盖了 `Object.Equals` 方法。

- **✓ DO** 要确保对任何两个对象来说，如果 `Object.Equals` 方法返回 `true`，那么它们的 `GetHashCode` 方法的返回值也应该相同。

- **✓ DO** 要尽力让类型的 `GetHashCode` 方法产生随机分布的散列码。

- **✓ DO** 要确保无论怎么更改对象，`GetHashCode` 都会返回完全相同的值。

- **X AVOID** 避免从 `GetHashCode` 方法中抛出异常。

### 3.5.3 Object.ToString

`Object.ToString` 的设计目的是为了用来显示和调试。由于其默认实现仅仅返回对象的类型名，因此不怎么有用。

- **✓ DO** 要覆盖`ToString` 方法，只要能返回既有用，又易于让人阅读的字符串。

- **✓ DO** 要尽量让 `ToString` 方法返回短小的字符串。

- **✓ CONSIDER** 考虑为每一个实例返回一个独立无二的字符串。

- **✓ DO** 要使用易于阅读的名字，而不要使用虽然独一无二，但却让人无法理解的 ID。

- **✓ DO** 要在返回与 culture 有关的信息时，根据当前线程的 culture 来对字符串进行格式化。

- **X DO NOT** 不要从 `ToString` 方法返回空字符串或 `null`。

- **X AVOID** 避免从 `ToString` 方法抛出异常。

- **✓ DO** 要确保 `ToString` 方法不会产生副作用。

- **✓ CONSIDER** 考虑让 `ToString` 方法输出的字符串能够为该类型的解析方法正确地解析。

    ```cs
    DateTime now = DateTime.Now;
    DateTime parsed = DateTime.Parse(now.ToString());
    ```

## 3.6 统一资源标识符 （Uri）

- **✓ DO** 要使用 `System.Uri` 来表示 URI 和 URL 数据。

    这适用于参数、属性、及返回值的类型。

    ```cs
    public class Navigtor
    {
        public Navigator(Uri initialLocation);
        public Uri CurrentLocation { get; }
        public Uri NavigateTo(Uri location);
    }
    ```

    > `System.Uri` 不仅提供了更多表示 URI 的方法，而且也更安全。大量的事实已经证明，用简单的字符串来操控与 URI 有关的数据会引发许多安全性和正确性问题。

- **✓ CONSIDER** 考虑为最常用的带 `System.Uri` 参数的成员提供基于字符串的重载成员。

    如果经常需要用户输入一个字符串作为 URI，那么为方便起见，应该考虑提供一个以字符串为参数的重载成员。以字符串为参数的重载成员应该通过 `System.Uri` 为参数的方法来实现。

    ```cs
    public class Navigator
    {
        public void NavigateTo(Uri location);
        public void NavigateTo(string location)
        {
            NavigateTo(new Uri(location));
        }
    }
    ```

- **X DO NOT** 不要不假思索地为所有基于 `System.Uri` 的成员提供基于字符串的重载成员。

    一般来说，更好的方法是使用 `System.Uri` 的成员，基于字符串的重载成员只是一些辅助成员，其目的是为了方便最常用的情况。

    ```cs
    public class Navigator
    {
        public void NavigateTo(Uri location);

        public void NavigateTo(string location)
        {
            NavigateTo(new Uri(location));
        }

        public void NavigateTo(Uri location, NavigationMode mode);
    }
    ```

- **X DO NOT** 不要在字符串中存储 URI/URL 数据。

    如果 URI/URL 数据是以字符串形式输入的，那么应该先把字符串转换为 `System.Uri`，然后再存储该 `System.Uri` 实例。

    ```cs
    public class SomeResoure
    {
        private readonly Uri _locaiton;

        public SomeResoure(string location)
            : this(new Uri(location))
        {
        }

        public SomeResoure(Uri location)
        {
            this._location = location;
        }
    }
    ```
