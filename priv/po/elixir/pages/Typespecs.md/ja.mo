Þ    #      4  /   L        W   	  F  a     ¨     ´     Ð     ã     ì               )     6     ?  µ   P  9    -  @  ª   n  û     h    Q   ~     Ð     e  L   ì     9     Ù  >   [  W     7   ò  s   *  Ã     O  b  |   ²  7   /  t   g  ü   Ü  J  Ù  W   $  k  |     è     ô       	        !     7     E     Y     j     x  ª     {  7  '  ³  ò   Û#  e  Î$    4&  `   Ô'  Á   5(     ÷(  X   )  ½   à)  {   *  W   +  d   r+  @   ×+     ,    £,  Ô  §-     |0  0   1  ·   51    í1                     
                                                   #              !            "                                                       	      * `@type`
  * `@opaque`
  * `@typep`
  * `@spec`
  * `@callback`
  * `@macrocallback`   * they provide documentation (for example, tools such as [ExDoc](https://github.com/elixir-lang/ex_doc) show type specifications in the documentation)
  * they're used by tools such as [Dialyzer](http://www.erlang.org/doc/man/dialyzer.html), that can analyze code with typespec to find type inconsistencies and possible bugs # Typespecs ## Defining a specification ## Defining a type ## Notes ## Types and their syntax ### Basic types ### Built-in types ### Literals ### Maps ### Remote types A type defined with `@typep` is private. An opaque type, defined with `@opaque` is a type where the internal structure of the type will not be visible, but the type is still public. Any module is also able to define its own types and the modules in Elixir are no exception. For example, the `Range` module defines a `t/0` type that represents a range: this type can be referred to as `t:Range.t/0`. In a similar fashion, a string is `t:String.t/0`, any enumerable can be `t:Enum.t/0`, and so on. Built-in type           | Defined as
:---------------------- | :---------
`term()`                | `any()`
`arity()`               | `0..255`
`as_boolean(t)`         | `t`
`binary()`              | `<<_::_*8>>`
`bitstring()`           | `<<_::_*1>>`
`boolean()`             | `false` \| `true`
`byte()`                | `0..255`
`char()`                | `0..0x10FFFF`
`charlist()`            | `[char()]`
`fun()`                 | `(... -> any)`
`identifier()`          | `pid()` \| `port()` \| `reference()`
`iodata()`              | `iolist()` \| `binary()`
`iolist()`              | `maybe_improper_list(byte() \| binary() \| iolist(), binary() \| [])`
`keyword()`             | `[{atom(), any()}]`
`keyword(t)`            | `[{atom(), t}]`
`list()`                | `[any()]`
`nonempty_list()`       | `nonempty_list(any())`
`maybe_improper_list()` | `maybe_improper_list(any(), any())`
`nonempty_maybe_improper_list()` | `nonempty_maybe_improper_list(any(), any())`
`mfa()`                 | `{module(), atom(), arity()}`
`module()`              | `atom()`
`no_return()`           | `none()`
`node()`                | `atom()`
`number()`              | `integer()` \| `float()`
`struct()`              | `%{:__struct__ => atom(), optional(atom()) => any()}`
`timeout()`             | `:infinity` \| `non_neg_integer()` Callbacks are used to define the callbacks functions of behaviours (see the ["Behaviours"](behaviours.html) page in the documentation for more information on behaviours). Elixir comes with a notation for declaring types and specifications. Elixir is a dynamically typed language, and as such, type specifications are never used by the compiler to optimize or modify code. Still, using type specifications is useful because Elixir discourages the use of type `t:string/0` as it might be confused with binaries which are referred to as "strings" in Elixir (as opposed to character lists). In order to use the type that is called `t:string/0` in Erlang, one has to use the `t:charlist/0` type which is a synonym for `string`. If you use `string`, you'll get a warning from the compiler. Guards can be used to restrict type variables given as arguments to the function. If you want to denote that keys that were not previously defined in the map are allowed,
it is common to end a map type with `optional(any) => any`. If you want to refer to the "string" type (the one operated on by functions in the `String` module), use `t:String.t/0` type instead.
 If you want to specify more than one variable, you separate them by a comma. Notice that the syntactic representation of `map()` is `%{optional(any) => any}`, not `%{}`. The notation `%{}` specifies the singleton type for the empty map. See the "Defining a type" and "Defining a specification" sub-sections below for more information on defining types and typespecs. Specifications can be overloaded just like ordinary functions. The `@type`, `@typep`, and `@opaque` module attributes can be used to define new types: The following literals are also supported in typespecs: The following types are also provided by Elixir as shortcuts on top of the basic and literal types described above. The key types in maps are allowed to overlap, and if they do, the leftmost key takes precedence.
A map value does not belong to this type if it contains a key that is not in the allowed map keys. The syntax Elixir provides for type specifications is similar to [the one in Erlang](http://www.erlang.org/doc/reference_manual/typespec.html). Most of the built-in types provided in Erlang (for example, `pid()`) are expressed in the same way: `pid()` (or simply `pid`). Parametrized types (such as `list(integer)`) are supported as well and so are remote types (such as `Enum.t`). Integers and atom literals are allowed as types (e.g., `1`, `:atom`, or `false`). All other types are built out of unions of predefined types. Some shorthands are allowed, such as `[...]`, `<<>>`, and `{...}`. Type specifications (sometimes referred to as *typespecs*) are defined in different contexts using the following attributes: Type variables with no restriction can also be defined. Types can be parameterized by defining variables as parameters; these variables can then be used to define the type. You can also name your arguments in a typespec using `arg_name :: arg_type` syntax. This is particularly useful in documentation as a way to differentiate multiple arguments of the same type (or multiple elements of the same type in a type definition): Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-27 12:24+0900
Last-Translator: å°ç° ç§æ¬ <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
   * `@type`
  * `@opaque`
  * `@typep`
  * `@spec`
  * `@callback`
  * `@macrocallback`   * ãã­ã¥ã¡ã³ããæä¾ããï¼ãã¨ãã°ã[ExDoc](https://github.com/elixir-lang/ex_doc) ã®ãããªãã¼ã«ã¯ãã­ã¥ã¡ã³ãä¸­ã®åä»æ§ãè¡¨ç¤ºãã¾ãï¼
  * åä»æ§ãä½¿ã£ã¦ã³ã¼ããåæããåã®ä¸æ´åããã°ãçºè¦ãã[Dialyzer](http://www.erlang.org/doc/man/dialyzer.html)ã®ãããªãã¼ã«ã«ä½¿ç¨ããã # åä»æ§ ## ä»æ§ã®å®ç¾© ## åã®å®ç¾© ## æ³¨è¨ ## åã¨ãã®æ§æ ### åºæ¬å ### çµã¿è¾¼ã¿å ### ãªãã©ã« ### ããã ### ãªã¢ã¼ãå `@typep`ã§å®ç¾©ãããåã¯ãã©ã¤ãã¼ãã§ãã`@opaque`ã§å®ç¾©ãããopaqueåã¯ãåã®åé¨æ§é ã¯ä¸å¯è¦ã§ãããåã¯å¬éããã¾ãã ãã¹ã¦ã®ã¢ã¸ã¥ã¼ã«ã¯ç¬èªã®åãå®ç¾©ãããã¨ãã§ããElixirã®ã¢ã¸ã¥ã¼ã«ãä¾å¤ã§ã¯ããã¾ããããã¨ãã°ã`Range`ã¢ã¸ã¥ã¼ã«ã¯ç¯å²ãè¡¨ã`t/0`åãå®ç¾©ãã¦ãã¾ãããã®åã¯`t:Range.t/0`ã§åç§ã§ãã¾ããåæ§ã«ãæå­åã¯`t:String.t/0`ããã¹ã¦ã®enumerableã¯`t:Enum.t/0`ãªã©ã§åç§ã§ãã¾ãã åè¾¼ã¿å          | å®ç¾©
:---------------------- | :---------
`term()`                | `any()`
`arity()`               | `0..255`
`as_boolean(t)`         | `t`
`binary()`              | `<<_::_*8>>`
`bitstring()`           | `<<_::_*1>>`
`boolean()`             | `false` \| `true`
`byte()`                | `0..255`
`char()`                | `0..0x10FFFF`
`charlist()`            | `[char()]`
`fun()`                 | `(... -> any)`
`identifier()`          | `pid()` \| `port()` \| `reference()`
`iodata()`              | `iolist()` \| `binary()`
`iolist()`              | `maybe_improper_list(byte() \| binary() \| iolist(), binary() \| [])`
`keyword()`             | `[{atom(), any()}]`
`keyword(t)`            | `[{atom(), t}]`
`list()`                | `[any()]`
`nonempty_list()`       | `nonempty_list(any())`
`maybe_improper_list()` | `maybe_improper_list(any(), any())`
`nonempty_maybe_improper_list()` | `nonempty_maybe_improper_list(any(), any())`
`mfa()`                 | `{module(), atom(), arity()}`
`module()`              | `atom()`
`no_return()`           | `none()`
`node()`                | `atom()`
`number()`              | `integer()` \| `float()`
`struct()`              | `%{:__struct__ => atom(), optional(atom()) => any()}`
`timeout()`             | `:infinity` \| `non_neg_integer()` ã³ã¼ã«ããã¯ã¯ããã¤ãã¢ã®ã³ã¼ã«ããã¯é¢æ°ã®å®ç¾©ã«ä½¿ç¨ããã¾ãï¼ããã¤ãã¢ã®è©³ç´°ã«ã¤ãã¦ã¯ãã­ã¥ã¡ã³ãã®[âããã¤ãã¢â](behaviours.html) ã®ãã¼ã¸ãåç§ãã¦ãã ããï¼ã Elixirã«ã¯åã¨ä»æ§ãå®£è¨ããããã®è¨æ³ãããã¾ããElixirã¯åçã«åä»ããããè¨èªã§ãããããã£ã¦ãã³ã³ãã¤ã©ãåä»æ§ãä½¿ã£ã¦æé©åãè¡ã£ãããã³ã¼ããå¤æ´ããããããã¨ã¯æ±ºãã¦ããã¾ãããããã§ããåä»æ§ã®ä»æ§ã¯æ¬¡ã®ãããªçç±ã§å½¹ã«ç«ã¡ã¾ãã Elixirã§ã¯`t:string/0`ã®ä½¿ç¨ã¯æ¨å¥¨ããã¾ãããElixirã§ã¯ï¼æå­ãªã¹ãã§ã¯ãªãï¼ãæå­åãå¼ã°ãããã¤ããªã¨æ··åãããå¯è½æ§ãããããã§ããErlangã§`t:string/0`ã¨å¼ã°ããåãä½¿ç¨ããã«ã¯`string`ã®åç¾©èªã§ãã`t:charlist/0`åãä½¿ç¨ããå¿è¦ãããã¾ãã `string`ãä½¿ç¨ããã¨ãã³ã³ãã¤ã©ããè­¦åãåãã¾ãã ã¬ã¼ãã¯é¢æ°ã¸ã®å¼æ°ã¨ãã¦ä¸ããããåå¤æ°ã®å¶éã«ä½¿ç¨ã§ãã¾ãã ä»¥åã«ãããã§å®ç¾©ããã¦ããªãã£ãã­ã¼ãè¨±ããã¦ãããã¨ãç¤ºãããå ´åã¯ããããåã`optional(any) => any`ã§çµãããããã¨ãä¸è¬çã§ãã ï¼`String`ã¢ã¸ã¥ã¼ã«ã®é¢æ°ã§æä½ãããï¼ãæå­åãåãåç§ãããå ´åã¯ã`t:String.t/0`åãä½¿ç¨ãã¾ãã
 2ã¤ä»¥ä¸ã®å¤æ°ãæå®ãããå ´åã¯ãå¤æ°ãã«ã³ãã§åå²ãã¾ãã `map()`ã®æ§æè¡¨ç¾ã¯ã`%{}`ã§ã¯ãªã`%{optional(any) => any)`ã§ãããã¨ã«æ³¨æãã¦ãã ããã`%{}`è¡¨è¨ã¯ç©ºã®ãããã®ããã®ç¹ç°åãç¤ºããã®ã§ãã åã¨åä»æ§ã®å®ç¾©ã«é¢ããè©³ç´°ã¯ä¸ã®ãåã®å®ç¾©ãã¨ãä»æ§ã®å®ç¾©ããåç§ãã¦ãã ããã ä»æ§ã¯æ®éã®é¢æ°ã®ããã«ãªã¼ãã¼ã­ã¼ããããã¨ãã§ãã¾ãã æ°ããåã®å®ç¾©ã«ã¯ã¢ã¸ã¥ã¼ã«å±æ§ `@type`, `@typep`,, `@opaque`ãä½¿ç¨ã§ãã¾ã: åä»æ§ã§ã¯ä»¥ä¸ã®ãªãã©ã«ããµãã¼ãããã¾ã: ä¸ã§è¿°ã¹ãåºæ¬åã¨ãªãã©ã«åã«å ãã¦ã·ã§ã¼ãã«ããã¨ãã¦æ¬¡ã®æ¹ãElixirã«ããæä¾ããã¦ãã¾ãã ãããã®ã­ã¼åã¯éè¤ãè¨±ããã¦ãã¾ãããã®å ´åããã£ã¨ãå·¦ã®ã­ã¼ãåªåããã¾ãã
ãããã®å¤ã¯ããããããããã­ã¼ã«è¨±ããã¦ããªãã­ã¼ãå«ãã§ããå ´åã¯ãã®åã«ã¯å±ãã¾ããã Elixirãåæå®ã®ããã«æä¾ããæ§æã¯ [Erlangã®æ§æ](http://www.erlang.org/doc/reference_manual/typespec.html)ã¨ä¼¼ã¦ãã¾ããErlangã§æä¾ããã¦ããçµã¿è¾¼ã¿åã®å¤§é¨åï¼ãã¨ãã°ãpid()ï¼ã¯ãåãæ¹æ³ã§è¡¨ç¾ããã¾ã: `pid()`ï¼ã¾ãã¯åç´ã«`pid`ï¼ããã©ã¡ã¿ã©ã¤ãºãããåï¼`list(integer)`ãªã©ï¼ããªã¢ã¼ãåï¼Enum.tãªã©ï¼ããµãã¼ãããã¦ãã¾ãã æ´æ°ã¨ã¢ãã ãªãã©ã«ã¯åã¨ãã¦è¨±ããã¾ãï¼ãã¨ãã°ã`1`, `:atom`, `false`ï¼ã ä»ã®ãã¹ã¦ã®åã¯ããããããå®ç¾©ããã¦ããåã®åéåã§æ§ç¯ããã¾ãã`[â¦]`, `<<>>`, `{â¦}`ãªã©ã®ç°¡ç¥è¡¨è¨ãè¨±ããã¦ãã¾ãã åä»æ§ï¼æã«ã¯*typespecs*ã¨å¼ã°ãã¾ãï¼ã¯æ¬¡ã®å±æ§ãä½¿ããã¨ã§ç°ãªãã³ã³ãã­ã¹ãã§å®ç¾©ããã¾ã: å¶ç´ãªãã®åå¤æ°ãå®ç¾©ã§ãã¾ãã åã¯å¤æ°ããã©ã¡ã¿ã¨ãã¦å®ç¾©ãããã¨ã«ãããã©ã¡ã¿ã©ã¤ãºãããã¨ãã§ãã¾ãããããã®å¤æ°ã¯ãã®å¾ãåã®å®ç¾©ã«ä½¿ç¨ã§ãã¾ãã `arg_name :: arg_type`æ§æãä½¿ç¨ãã¦åä»æ§ã®å¼æ°ã«ååãä»ãããã¨ãã§ãã¾ãã ããã¯ãåãåã®è¤æ°ã®å¼æ°ï¼ã¾ãã¯åå®ç¾©åã®åãåã®è¤æ°ã®è¦ç´ ï¼ãåºå¥ããæ¹æ³ã¨ãã¦ããã­ã¥ã¡ã³ãã§ç¹ã«å½¹ã«ç«ã¡ã¾ãã 