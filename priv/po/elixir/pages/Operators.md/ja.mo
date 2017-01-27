Þ    (      \  5         p  Í   q  }   ?  ?   ½     ý     	  "   !  (   D     m       !        ¼     Î  X  ï  <   H  K     J   Ñ    	  O   ¡  <   ñ     .  r   Â  «   5  t   á  ð   V  Î   G  w          W   +  ÿ        C     Z   `     »  w   A  $   ¹  5   Þ  A        V  T   ç  I  <  Û     }   b   ?   à       !     ,!  0   ?!  *   p!  "   !     ¾!  "   Ò!     õ!    "    #  K   %  Z   ë%  `   F&  w  §&     /  C   ®/  ·   ò/  ~   ª0  Ï   )1  x   ù1  S  r2    Æ3  Ì   ß4  Á   ¬5     n6  Ü  õ6  U  Ò8  E   (;  Z   n;     É;  y   N<  $   È<  5   í<  A   #=     e=  T   ö=                  (                  '                  $               "                                              #   
            	       &         !             %                   * `==` - equality
  * `===` - strict equality
  * `!=` - inequality
  * `!==` - strict inequality
  * `>` - greater than
  * `<` - less than
  * `>=` - greater than or equal
  * `<=` - less than or equal   * `|`
  * `|||`
  * `&&&`
  * `<<<`
  * `>>>`
  * `~>>`
  * `<<~`
  * `~>`
  * `<~`
  * `<~>`
  * `<|>`
  * `^^^`
  * `~~~`   def a ~> b, do: max(a, b)
  def a <~ b, do: min(a, b)
end
``` # Operators ## Comparison operators ## Custom and overridden operators ## Operator precedence and associativity ### Defining custom operators ### Final note ### Redefining existing operators ### Term ordering * Tuples are compared by size then element by element.
* Maps are compared by size then by keys in ascending term order then by values in key order. In the specific case of maps' key ordering, integers are always considered to be less than floats.
* Lists are compared element by element. Elixir is capable of parsing a predefined set of operators; this means that it's not possible to define new operators (like one could do in Haskell, for example). However, not all operators that Elixir can parse are *used* by Elixir: for example, `+` and `||` are used by Elixir for addition and boolean *or*, but `<~>` is not used (but valid). Elixir provides the following built-in comparison operators: In Elixir, different data types can be compared using comparison operators: Now, we will get an error if we try to use this operator "out of the box": Operator                                                                                 | Associativity
---------------------------------------------------------------------------------------- | -------------
`@`                                                                                      | Unary
`.`                                                                                      | Left to right
`+` `-` `!` `^` `not` `~~~`                                                              | Unary
`*` `/`                                                                                  | Left to right
`+` `-`                                                                                  | Left to right
`++` `--` `..` `<>`                                                                      | Right to left
`in`                                                                                     | Left to right
`\|>` `<<<` `>>>` `~>>` `<<~` `~>` `<~` `<~>` `<\|>`                                     | Left to right
`<` `>` `<=` `>=`                                                                        | Left to right
`==` `!=` `=~` `===` `!==`                                                               | Left to right
`&&` `&&&` `and`                                                                         | Left to right
`\|\|` `\|\|\|` `or`                                                                     | Left to right
`=`                                                                                      | Right to left
`=>`                                                                                     | Right to left
`\|`                                                                                     | Right to left
`::`                                                                                     | Right to left
`when`                                                                                   | Right to left
`<-`, `\\`                                                                               | Left to right
`&`                                                                                      | Unary So, as mentioned above, we need to explicitly *not* import `+/2` from `Kernel`: The collection types are compared using the following rules: The following is a list of all operators that Elixir is capable of parsing, ordered from higher to lower precedence, alongside their associativity: The following is a table of all the operators that Elixir is capable of parsing, but that are not used by default: The following operators are used by the `Bitwise` module when imported: `&&&`, `^^^`, `<<<`, `>>>`, `|||`, `~~~`. See the documentation for `Bitwise` for more information. The only difference between `==` and `===` is that `===` is stricter when it comes to comparing integers and floats: The operators that Elixir uses (for example, `+`) can be defined by any module and used in place of the ones defined by Elixir, provided they're specifically not imported from `Kernel` (which is imported everywhere by default). For example: The reason we can compare different data types is pragmatism. Sorting algorithms donât need to worry about different data types in order to sort. For reference, the overall sorting order is defined below: This document covers operators in Elixir, how they are parsed, how they can be defined, and how they can be overridden. To define an operator, you can use the usual `def*` constructs (`def`, `defp`, `defmacro`, and so on) but with a syntax similar to how the operator is used: To use the newly defined operators, we **have to** import the module that defines them: When comparing two numbers of different types (a number is either an integer or a float), a conversion to the type with greater precision will always occur, unless the comparison operator used is either `===` or `!==`. A float will be considered more precise than an integer, unless the float is greater/less than +/-9007199254740992.0, at which point all the significant figures of the float are to the left of the decimal point. This behavior exists so that the comparison of large numbers remains transitive. While it's possible to defined unused operators (such as `<~>`) and to "override" predefined operators (such as `+`), the Elixir community generally discourages this. Custom-defined operators can be really hard to read and even more to understand, as they don't have a descriptive name like functions do. That said, some specific cases or custom domain specific languages (DSLs) may justify these practices.
 `!=` and `!==` act as the negation of `==` and `===`, respectively. ```
number < atom < reference < function < port < pid < tuple < map < list < bitstring
``` ```elixir
defmodule MyOperators do
  # We define ~> to return the maximum of the given two numbers,
  # and <~ to return the minimum. ```elixir
defmodule WrongMath do
  # Let's make math wrong by changing the meaning of +:
  def a + b, do: a - b
end
``` ```elixir
iex> 1 < :an_atom
true
``` ```elixir
iex> 1 == 1.0
true
iex> 1 === 1.0
false
``` ```elixir
iex> import MyOperators
iex> 1 ~> 2
2
iex> 1 <~ 2
1
``` ```elixir
iex> import WrongMath
iex> 1 + 2
** (CompileError) iex:11: function +/2 imported from both WrongMath and Kernel, call is ambiguous
``` ```elixir
iex> import WrongMath
iex> import Kernel, except: [+: 2]
iex> 1 + 2
-1
``` Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-27 11:09+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
  * `==` - ç­ãã
  * `===` - å³å¯ã«ç­ãã
  * `!=` - ç­ãããªã
  * `!==` - å³å¯ã«ç­ãããªãstrict inequality
  * `>` - ããå¤§ãã
  * `<` - ããå°ãã
  * `>=` - ä»¥ä¸
  * `<=` - ä»¥ä¸   * `|`
  * `|||`
  * `&&&`
  * `<<<`
  * `>>>`
  * `~>>`
  * `<<~`
  * `~>`
  * `<~`
  * `<~>`
  * `<|>`
  * `^^^`
  * `~~~`   def a ~> b, do: max(a, b)
  def a <~ b, do: min(a, b)
end
``` # æ¼ç®å­ ## æ¯è¼æ¼ç®å­ ## ã«ã¹ã¿ã æ¼ç®å­ã¨æ¼ç®å­ã®ä¸æ¸ã ## æ¼ç®å­ã®åªåé ä½ã¨çµåè¦å ### ã«ã¹ã¿ã æ¼ç®å­ã®å®ç¾© ### æå¾ã®æ³¨æ ### æ¢å­ã®æ¼ç®å­ã®åå®ç¾© ### é ã®é åº * ã¿ãã«ã¯ã¾ããµã¤ãºã§æ¯è¼ãããæ¬¡ã«è¦ç´ ãã¨ã«æ¯è¼ããã¾ãã
* ãããã¯ã¾ããµã¤ãºã§æ¯è¼ãããæ¬¡ã«ã­ã¼ãæé ã«ãæ¬¡ã«ã­ã¼é ã«ãã®å¤ã§æ¯è¼ããã¾ãããããã®ã­ã¼ã®é åºã«ãããç¹ä¾ã¨ãã¦ãæ´æ°ã¯å¸¸ã«æµ®åå°æ°ããå°ããã¨ã¿ãªããã¾ãã
* ãªã¹ãã¯è¦ç´ ãã¨ã«æ¯è¼ããã¾ãã Elixirã¯ãããããå®ç¾©ãããæ¼ç®å­ã®ã»ãããè§£æãããã¨ãã§ãã¾ããããã¯ï¼ãã¨ãã°ãHaskelã§ã¯ã§ãããããªï¼æ°ããæ¼ç®å­ãå®ç¾©ã§ããªããã¨ãæå³ãã¾ããããããElixirãè§£æãããã¨ãã§ããæ¼ç®å­ã®ãã¹ã¦ãElixirã«ãã*ä½¿ããã¦ãã*ããã§ã¯ããã¾ããããã¨ãã°ã`+`ã¨`||`ã¯Elxirã§ã¯å¯ç®ããã³è«çæ¼ç®å­`or`ã¨ãã¦ä½¿ããã¦ãã¾ããã`<~>`ã¯ï¼æå¹ã§ããï¼ä½¿ããã¦ãã¾ããã Elixirã¯ä»¥ä¸ã®ãã«ãã¤ã³æ¯è¼æ¼ç®å­ãæä¾ãã¦ãã¾ãã Elixirã§ã¯ç°ãªããã¼ã¿åãæ¯è¼æ¼ç®å­ã§æ¯è¼ãããã¨ãã§ãã¾ãã ããã§ã¯ãã®æ¼ç®å­ãããã®ã¾ã¾ãä½¿ããã¨ããã¨ã¨ã©ã¼ã«ãªãã¾ãã æ¼ç®å­                                                                                 | çµåè¦å
---------------------------------------------------------------------------------------- | -------------
`@`                                                                                      | åé 
`.`                                                                                      | å·¦ããå³
`+` `-` `!` `^` `not` `~~~`                                                              | åé 
`*` `/`                                                                                  | å·¦ããå³
`+` `-`                                                                                  | å·¦ããå³
`++` `--` `..` `<>`                                                                      | å³ããå·¦
`in`                                                                                     | å·¦ããå³
`\|>` `<<<` `>>>` `~>>` `<<~` `~>` `<~` `<~>` `<\|>`                                     | å·¦ããå³
`<` `>` `<=` `>=`                                                                        | å·¦ããå³
`==` `!=` `=~` `===` `!==`                                                               | å·¦ããå³
`&&` `&&&` `and`                                                                         | å·¦ããå³
`\|\|` `\|\|\|` `or`                                                                     | å·¦ããå³
`=`                                                                                      | å³ããå·¦
`=>`                                                                                     | å³ããå·¦
`\|`                                                                                     | å³ããå·¦
`::`                                                                                     | å³ããå·¦
`when`                                                                                   | å³ããå·¦
`<-`, `\\`                                                                               | å·¦ããå³
`&`                                                                                      | åé  ããã§ãä¸ã§è¿°ã¹ãããã«ãæç¤ºçã«`+/2`ã`Kernel`ããã¤ã³ãã¼ã*ããªã*ããã«ããã²ã¤ãããããã¾ã: ã³ã¬ã¯ã·ã§ã³åã¯æ¬¡ã®è¦åãä½¿ã£ã¦æ¯è¼ããã¾ã: ä»¥ä¸ã®ãªã¹ãã¯Elixirãè§£æã§ãããã¹ã¦ã®æ¼ç®å­ã®ä¸è¦§ã§ããåªåé ä½ã®é«ããã®ããä½ããã®é ã«ãçµåè¦åã¨ã¨ãã«ä¸¦ãã§ãã¾ãã ä»¥ä¸ã¯ãElixirãè§£æã§ãããããã©ã«ãã§ã¯ä½¿ç¨ããã¦ããªããã¹ã¦ã®æ¼ç®å­ã®ãªã¹ãã§ãã æ¬¡ã®æ¼ç®å­ã¯`Bitwise`ã¢ã¸ã¥ã¼ã«ãã¤ã³ãã¼ãããã¨ä½¿ç¨ããã¦ãã¾ã:` &&&`, `^^^`, `<<<`, `>>>`, `|||`, `~~~`ãè©³ç´°ã¯`Bitwise`ã®ãã­ã¥ã¡ã³ããåç§ãã¦ãã ããã `==`ã¨`===`ã®å¯ä¸ã®éãã¯ãæ´æ°ã¨æµ®åå°æ°ãæ¯è¼ããéã«`===`ã¯ããå³å¯ã§ãããã¨ã§ã: Elixirãä½¿ç¨ããæ¼ç®å­ï¼ãã¨ãã°ã`+`ï¼ã¯ãããã`Kernel`ããã¤ã³ãã¼ããããªããã¨ãæç¢ºã«ããã°ï¼ããã©ã«ãã§ãã¹ã¦ã®å ´æã«ã¤ã³ãã¼ãããã¦ãã¾ãï¼ãä»»æã®ã¢ã¸ã¥ã¼ã«ã§å®ç¾©ãã¦ãElixirãå®ç¾©ããæ¼ç®å­ã®ä»£ããã«ä½¿ç¨ã§ãã¾ãããã¨ãã°: ç°ãªããã¼ã¿åãæ¯è¼ã§ããçç±ã¯å®ç¨ä¸»ç¾©ã«ããã¾ããã½ã¼ãã¢ã«ã´ãªãºã ã§ç°ãªããã¼ã¿åã®ã½ã¼ãé ã«ã¤ãã¦æ°ã«ããå¿è¦ã¯ããã¾ãããåèã®ããã«ãã¹ã¦ã®ã½ã¼ãé ã¯æ¬¡ã®ããã«å®ç¾©ããã¦ãã¾ã: ãã®ãã­ã¥ã¡ã³ãã¯Elixirã®æ¼ç®å­ãæ±ããæ¼ç®å­ãã©ã®ããã«è§£æãããããã©ã®ããã«å®ç¾©ã§ããã®ããã©ã®ããã«ä¸æ¸ãã§ããã®ããèª¬æãã¾ãã æ¼ç®å­ãå®ç¾©ããã«ã¯ãéå¸¸ã®`def*`æ§æå­ï¼`def`, `defp`, `defmacro`ãªã©ï¼ãä½¿ç¨ã§ãã¾ããããã®æ§æã¯æ¼ç®å­ã®ä½¿ç¨æ¹æ³ã¨ä¼¼ããã®ã«ãªãã¾ãã æ°ããå®ç¾©ããæ¼ç®å­ãä½¿ç¨ããã«ã¯ãå®ç¾©ããã¢ã¸ã¥ã¼ã«ãã¤ã³ãã¼ãããªããã°*ãªãã¾ãã*ã ç°ãªãåã®2ã¤ã®æ°ï¼æ°ã¯æ´æ°ãæµ®åå°æ°ã®ããããï¼ãæ¯è¼ããéã`===`ã`!==`ã®ããããã®æ¯è¼æ¼ç®å­ãä½¿ããã¦ããªãã¨ãããé«ãç²¾åº¦ã®åã¸ã®å¤æãå¸¸ã«è¡ããã¾ããæµ®åå°æ°ã+/-9007199254740992.0ããå¤§ãããå°ãããªãå ´åãé¤ãã¦ãæµ®åå°æ°ã¯æ´æ°ããé«ãç²¾åº¦ã§ããã¨ã¿ãªããã¾ãããã®å ´åãæµ®åå°æ°ã®æå¹æ°å­ã¯å°æ°ç¹ã®å·¦å´ã«ãªãã¾ãã æªä½¿ç¨ã®æ¼ç®å­ï¼ `<ã>`ãªã©ï¼ãå®ç¾©ãããããããããå®ç¾©ãããæ¼ç®å­ï¼ `+`ãªã©ï¼ããä¸æ¸ããããããããã¨ã¯å¯è½ã§ãããä¸è¬çã«Elixirã³ãã¥ããã£ã¯ãããå«ã£ã¦ãã¾ãã ã«ã¹ã¿ã å®ç¾©ã®æ¼ç®å­ã¯ãé¢æ°ã®ããã«ããããããååãæããªããããå®éã«ã¯èª­ã¿ã«ãããããçè§£ãã«ãããã®ã«ãªãå¯è½æ§ãããã¾ãã ã¤ã¾ããç¹å®ã®ã±ã¼ã¹ãã«ã¹ã¿ã ãã¡ã¤ã³åºæã®è¨èªï¼DSLï¼ããããã®æ¹æ³ãæ­£å½åããå¯è½æ§ãããã¾ãã\ n
 `!=`ã¨`!==`ã¯åã`==`ã¨`===`ã®å¦å®ã¨ãã¦ä½ç¨ãã¾ãã ```
number < atom < reference < function < port < pid < tuple < map < list < bitstring
``` ```elixir
defmodule MyOperators do
  # ~> ã¯æå®ããã2ã¤ã®æ°ã®æå¤§å¤ã
  # <~ ã¯æå°å¤ãè¿ãã¨å®ç¾©ããã ```elixir
defmodule WrongMath do
  # +ã®æå³ãå¤æ´ãã¦è¨ç®ãééãããã:
  def a + b, do: a - b
end
``` ```elixir
iex> 1 < :an_atom
true
``` ```elixir
iex> 1 == 1.0
true
iex> 1 === 1.0
false
``` ```elixir
iex> import MyOperators
iex> 1 ~> 2
2
iex> 1 <~ 2
1
``` ```elixir
iex> import WrongMath
iex> 1 + 2
** (CompileError) iex:11: function +/2 imported from both WrongMath and Kernel, call is ambiguous
``` ```elixir
iex> import WrongMath
iex> import Kernel, except: [+: 2]
iex> 1 + 2
-1
``` 