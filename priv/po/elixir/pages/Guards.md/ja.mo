Þ    -        =   ì      à     á      ù         .
  v   D
  v   »
  |   2     ¯  $   ¸     Ý     ý       %   .     T     p  w  ~  º   ö  Z   ±          ©  ^   8  ý          S    :   p  1  «  t   Ý  "   R  }   u     ó  5  ~      ´  s   U  v   É     @  i   Ð  ¤   :  ²   ß  D     .   ×  	           ,   1  D   ^  I  £     í     ý         ³%  u   Â%  v   8&  {   ¯&     +'  $   7'     \'     r'  !   '  $   ª'     Ï'     î'  Ü  (  Þ   ê)  |   É*    F+     O,     ç,  >  s-  ¬   ².  Ñ  _/  I   11  	  {1     4  =   5  }   F5  À   Ä5  À  6  á   F8  s   (9  v   9     :  i   £:  ¤   ;  ²   ²;  D   e<  .   ª<  (   Ù<  .   =  ,   1=  D   ^=           )       %   $            	                        *         (   '   "   -                        ,       &                           +      
             #             !                                        * `case` expressions:   * anonymous functions (`fn`s):   * comparison operators (`==`, `!=`, `===`, `!==`, `>`, `>=`, `<`, `<=`)
  * strictly boolean operators (`and`, `or`, `not`) (the `&&`, `||`, and `!` sibling operators are not allowed as they're not *strictly* boolean - meaning they don't require both sides to be booleans)
  * arithmetic binary operators (`+`, `-`, `*`, `/`)
  * arithmetic unary operators (`+`, `-`)
  * binary concatenation operator (`<>`)
  * `in` operator (as long as the right-hand side is a list or a range)
  * the following "type-check" functions (all documented in the `Kernel` module):
    * `is_atom/1`
    * `is_binary/1`
    * `is_bitstring/1`
    * `is_boolean/1`
    * `is_float/1`
    * `is_function/1`
    * `is_function/2`
    * `is_integer/1`
    * `is_list/1`
    * `is_map/1`
    * `is_nil/1`
    * `is_number/1`
    * `is_pid/1`
    * `is_port/1`
    * `is_reference/1`
    * `is_tuple/1`
  * the following guard-friendly functions (all documented in the `Kernel` module):
    * `abs/1`
    * `binary_part/3`
    * `bit_size/1`
    * `byte_size/1`
    * `div/2`
    * `elem/2`
    * `hd/1`
    * `length/1`
    * `map_size/1`
    * `node/0`
    * `node/1`
    * `rem/2`
    * `round/1`
    * `self/0`
    * `tl/1`
    * `trunc/1`
    * `tuple_size/1`
  * the following handful of Erlang bitwise operations, if imported from the `Bitwise` module:
    * `band/2` or the `&&&` operator
    * `bor/2` or the `|||` operator
    * `bnot/1` or the `~~~` operator
    * `bsl/1` or the `<<<` operator
    * `bsr/1` or the `>>>` operator
    * `bxor/2` or the `^^^` operator   * function clauses:   ```elixir
  case x do
    1 -> :one
    2 -> :two
    n when is_integer(n) and n > 2 -> :larger_than_two
  end
  ```   ```elixir
  def foo(term) when is_integer(term), do: term
  def foo(term) when is_float(term), do: round(term)
  ```   ```elixir
  larger_than_two? = fn
    n when is_integer(n) and n > 2 -> true
    n when is_integer(n) -> false
  end
  ``` # Guards ## Defining custom guard expressions ## Expressions in guard clauses ## Failing guards ## List of allowed expressions ## Multiple guards in the same clause ## Where guards can be used ## Why guards As mentioned before, only the expressions listed in this page are allowed in guards. However, we can take advantage of macros to write custom guards that can simplify our programs or make them more domain-specific. At the end of the day, what matters is that the *output* of the macros (which is what will be compiled) boils down to a combinations of the allowed expressions. Errors in guards do not result in a runtime error, but in the erroring guard fail. For example, the `length/1` function only works with lists, and if we use it on anything else it fails: For reference, the following is a comprehensive list of all expressions allowed in guards: Guards are a way to augment pattern matching with more complex checks; they are allowed in a predefined set of constructs where pattern matching is allowed. Guards start with the `when` keyword, which is followed by a boolean expression (we will define the grammar of guards more formally later on). However, when used in guards, it simply makes the corresponding clause fail (i.e., not match): In many cases, we can take advantage of this: in the code above, for example, we can use `length/1` to both check that the given thing is a list *and* check some properties of its length (instead of using `is_list(something) and length(something) > 0`). In the example above, we show how guards can be used in function clauses. There are several constructs that allow guards; for example: Let's look at a quick case study: we want to check that a function argument is an even or odd integer. With pattern matching, this is impossible to do since there are infinite integers, and thus we can't pattern match on the single even/odd numbers. Let's focus on checking for even numbers since checking for odd ones is almost identical. Let's see an example of a guard used in a function clause: Not all expressions are allowed in guard clauses, but only a handful of them. This is a deliberate choice: only a predefined set of side-effect-free functions are allowed. This way, Elixir (and Erlang) can make sure that nothing bad happens while executing guards and no mutations happen anywhere. This behaviour is also coherent with pattern match, which is a naturally a side-effect-free operation. Finally, keeping expressions allowed in clauses to a close set of predefined ones allows the compiler to optimize the code related to choosing the right clause. Other constructs are `for`, `with`, `try`/`rescue`/`catch`/`else`/, and the `match?/2` macro in the `Kernel` module. Such a guard would look like this: The two forms are exactly the same semantically but there are cases where the latter one may be more aesthetically pleasing.
 There exists an additional way to simplify a chain of `or`s in guards: Elixir supports writing "multiple guards" in the same clause. This: This would be repetitive to write everytime we need this check, so, as mentioned at the beginning of this section, we can abstract this away using a macro. Remember that defining a function that performs this check wouldn't work because we can't use custom functions in guards. Our macro would look like this: Writing the `empty_map?/1` function by only using pattern matching would not be possible (as pattern matching on `%{}` would match *every* map, not empty maps). ```elixir
def empty_map?(map) when map_size(map) == 0, do: true
def empty_map?(map) when is_map(map), do: false
``` ```elixir
def foo(term)
    when is_integer(term)
    when is_float(term)
    when is_nil(term) do
  :maybe_number
end ```elixir
def foo(term) when is_integer(term) or is_float(term) or is_nil(term),
  do: :maybe_number
def foo(_other),
  do: :something_else
``` ```elixir
def my_function(number) when is_integer(number) and rem(number, 2) == 0 do
  # do stuff
end
``` ```elixir
defmodule MyInteger do
  defmacro is_even(number) do
    quote do
      is_integer(unquote(number)) and rem(unquote(number), 2) == 0
    end
  end
end
``` ```elixir
iex> case "hello" do
...>   something when length(something) > 0 ->
...>     :length_worked
...>   _anything_else ->
...>     :length_failed
...> end
:length_failed
``` ```elixir
iex> length("hello")
** (ArgumentError) argument error
``` ```elixir
import MyInteger, only: [is_even: 1] and then: can be alternatively written as: def foo(_other) do
  :something_else
end
``` def my_function(number) when is_even(number) do
  # do stuff
end
``` Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-26 16:35+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
   * `case` å¼:   * ç¡åé¢æ° (`fn`s):   * æ¯è¼æ¼ç®å­ (`==`, `!=`, `===`, `!==`, `>`, `>=`, `<`, `<=`)
  * å³æ ¼ãªãã¼ã«æ¼ç®å­ (`and`, `or`, `not`) (`&&`, `||`, `!` ã®å§å¦¹æ¼ç®å­ã¯*å³æ ¼ãª*ãã¼ã«å¤ã§ã¯ãªãã®ã§è¨±ããã¦ãã¾ãã - ãããã®æ¼ç®å­ã¯ä¸¡è¾ºããã¼ã«å¤ã§ãããã¨ãå¿è¦ã¨ãã¦ããªããã¨ãæå³ãã¾ã)
  * ç®è¡2é æ¼ç®å­ (`+`, `-`, `*`, `/`)
  * ç®è¡åé æ¼ç®å­ (`+`, `-`)
  * ãã¤ããªé£çµæ¼ç®å­ (`<>`)
  * `in` æ¼ç®å­ ï¼å·¦è¾ºããªã¹ãã¾ãã¯ç¯å²ã§ããå ´åï¼
  * æ¬¡ã® âåãã§ãã¯" é¢æ° ï¼ãã­ã¥ã¡ã³ãã¯ãã¹ã¦`Kernel`ã¢ã¸ã¥ã¼ã«ã«ããã¾ãï¼:
    * `is_atom/1`
    * `is_binary/1`
    * `is_bitstring/1`
    * `is_boolean/1`
    * `is_float/1`
    * `is_function/1`
    * `is_function/2`
    * `is_integer/1`
    * `is_list/1`
    * `is_map/1`
    * `is_nil/1`
    * `is_number/1`
    * `is_pid/1`
    * `is_port/1`
    * `is_reference/1`
    * `is_tuple/1`
  * æ¬¡ã®ã¬ã¼ããã¬ã³ããªãªé¢æ°ï¼ãã­ã¥ã¡ã³ãã¯ãã¹ã¦`Kernel`ã¢ã¸ã¥ã¼ã«ã«ããã¾ãï¼:
    * `abs/1`
    * `binary_part/3`
    * `bit_size/1`
    * `byte_size/1`
    * `div/2`
    * `elem/2`
    * `hd/1`
    * `length/1`
    * `map_size/1`
    * `node/0`
    * `node/1`
    * `rem/2`
    * `round/1`
    * `self/0`
    * `tl/1`
    * `trunc/1`
    * `tuple_size/1`
  * `Bitwise`ã¢ã¸ã¥ã¼ã«ããã¤ã³ãã¼ãããå ´åãæ¬¡ã®ããããªErlangã®ãããæ¼ç®å­:
    * `band/2` or the `&&&` operator
    * `bor/2` or the `|||` operator
    * `bnot/1` or the `~~~` operator
    * `bsl/1` or the `<<<` operator
    * `bsr/1` or the `>>>` operator
    * `bxor/2` or the `^^^` operator   * é¢æ°ç¯:  ```elixir
  case x do
    1 -> :one
    2 -> :two
    n when is_integer(n) and n > 2 -> :larger_than_two
  end
  ```   ```elixir
  def foo(term) when is_integer(term), do: term
  def foo(term) when is_float(term), do: round(term)
  ```  ```elixir
  larger_than_two? = fn
    n when is_integer(n) and n > 2 -> true
    n when is_integer(n) -> false
  end
  ``` # ã¬ã¼ã ## ã«ã¹ã¿ã ã¬ã¼ãå¼ã®å®ç¾© ## ã¬ã¼ãç¯ã®å¼ ## ã¬ã¼ãã®å¤±æ ## å©ç¨ã§ããå¼ã®ãªã¹ã ## ä¸ã¤ã®ç¯ã«è¤æ°ã®ã¬ã¼ã ## ã¬ã¼ããä½¿ããå ´æ ## ãªãã¬ã¼ããå¿è¦ã ä»¥åã«è¿°ã¹ãããã«ããã®ãã¼ã¸ã«ãªã¹ãããå¼ããã¬ã¼ãã«ã¯ä½¿ç¨ã§ãã¾ãããããããªããããã¯ã­ããã¾ãå©ç¨ãã¦ããã­ã°ã©ã ãç°¡åã«ãããã¾ãã¯ããããã¡ã¤ã³åºæãªãã®ã«ããã«ã¹ã¿ã ã¬ã¼ããæ¸ããã¨ãã§ãã¾ããçµå±ã¯ãåé¡ã¨ãªãã®ã¯ãã¯ã­ã®*åºå*ï¼ãããã³ã³ãã¤ã«ããããã®ã§ãï¼ãè¨±ãããå¼ã®çµåãã«è¦ç´ããããã§ãã ã¬ã¼ãã«ãããã¨ã©ã¼ã¯å®è¡æã¨ã©ã¼ã§ã¯ãªããã¬ã¼ãå¤±æã®ã¨ã©ã¼ã¨ãªãã¾ãããã¨ãã°ãé¢æ°`length/1` ã¯ãªã¹ãã§ã®ã¿åä½ããä½ãä»ã®ãã®ã«ä½¿ãã¨å¤±æãã¾ã: åèã®ããã«ãä»¥ä¸ã«ã¬ã¼ãã«ä½¿ç¨ãè¨±ããã¦ãããã¹ã¦ã®å¼ã®åæ¬çãªãªã¹ããç¤ºãã¾ã: ã¬ã¼ãã¨ã¯ãããè¤éãªãã§ãã¯ã§ãã¿ã¼ã³ããããå¢å¼·ããæ¹æ³ã§ãããã¿ã¼ã³ããããç½®ããã¨ãè¨±ããã¦ããå ´æã§ãããããå®ç¾©ãããæ§æç©ã®ã»ããã¨ãã¦ç½®ããã¨ãè¨±ããã¦ãã¾ãã ã¬ã¼ãã¯ã­ã¼ã¯ã¼ã`where`ã§å§ã¾ããæ¬¡ã«è«çå¼ãç¶ãã¾ãï¼å¾ã»ã©ãããæ­£å¼ãªã¬ã¼ãã®ææ³ãå®ç¾©ãã¾ãï¼ã ããããã¬ã¼ãã®ä¸­ã§ä½¿ç¨ããå ´åã¯ãåã«å¯¾å¿ããç¯ãå¤±æããã¾ãï¼ããªãã¡ãããããã¾ããï¼: å¤ãã®å ´åãããã¯å©ç¹ã§ãããã¨ãã°ãä¸ã®ã³ã¼ãã§ã¯ãï¼`is_list(something) and length(something) > 0`ãä½¿ãä»£ããã«ï¼`length/1`ãä½¿ã£ã¦æå®ããããã®ããªã¹ãã§ãããã®ãã§ãã¯ã¨ãã®é·ãã®ä½ããã®å±æ§ã®ãã§ãã¯ã®2ã¤ãè¡ã£ã¦ãã¾ãã ä¸ã®ä¾ã§ã¯ã¬ã¼ããã©ã®ããã«é¢æ°ç¯ã§ä½¿ç¨ã§ããããç¤ºãã¦ãã¾ããã¬ã¼ããä½¿ããæ§æè¦ç´ ãããã¤ãããã¾ãããã¨ãã°: ç°¡åãªã±ã¼ã¹ã¹ã¿ãã£ãè¦ã¦ã¿ã¾ããããé¢æ°ã®å¼æ°ãå¶æ°ãå¥æ°ãããã§ãã¯ãããã¨ãã¾ãããã¿ã¼ã³ãããã§ã¯ãããè¡ããã¨ã¯ä¸å¯è½ã§ããç¡éã®æ´æ°ãããããã§ãããã®ãããåä¸ã®å¶æ°ã¾ãã¯å¥æ°ã®æ°ã«ãã¿ã¼ã³ããããè¡ããã¨ã¯ã§ãã¾ãããå¶æ°ã®ãã§ãã¯ã«ç¦ç¹ãçµãã¾ããããå¥æ°ã®ãã§ãã¯ã¯ã»ã¨ãã©åãã ããã§ãã é¢æ°ç¯ã§ä½¿ç¨ããã¦ããã¬ã¼ãã®ä¾ãè¦ã¦ã¿ã¾ããã: ãã¹ã¦ã®å¼ãã¬ã¼ãç¯ã§ã®ä½¿ç¨ãè¨±ããã¦ããããã§ã¯ããã¾ãããã»ãã®ä¸æ¡ãã®å¼ã ãã§ããããã¯æå³çãªé¸æã§ãããããããå®ç¾©ãããä¸é£ã®å¯ä½ç¨ã®ãªãé¢æ°ã®ã¿ãè¨±ããã¦ãã¾ãããã®ããã«ãã¦ãElixirï¼ã¨Erlangï¼ã¯ãã¬ã¼ãã®å®è¡ä¸­ã«ä½ãæªããã¨ãèµ·ããªããã¨ãã©ãã§ãå¤åãçããªããã¨ãç¢ºå®ã«ãããã¨ãã§ãã¾ãããã®ãµãã¾ãã¯ãå½ç¶å¯ä½ç¨ã®ãªãæä½ã§ãããã¿ã¼ã³ãããã¨ãæ´åãã¦ãã¾ããæå¾ã«ãç¯ã®ãªãã§è¨±ãããå¼ããããããå®ç¾©ãããééåã«ãããã¨ã«ãããã³ã³ãã¤ã©ã¯æ­£ããç¯ã®é¸æã«é¢é£ããæé©åãå¯è½ã«ãªãã¾ãã ãã®ä»ã«ã¯ã`for`, `with`, `try`/`rescue`/`catch`/`else`/, `Kernel` ã¢ã¸ã¥ã¼ã«ã®`match?/2` ãã¯ã­ãããã¾ãã ãã®ãããªã¬ã¼ãã¯æ¬¡ã®ããã«ãªãã§ããã: 2ã¤ã®å½¢ã¯æå³çã«ã¯ã¾ã£ããåãã§ãããå¾èã®æ¹ãè¦ãç®ãããç¾ããå ´åãããã¾ãã
 ã¬ã¼ãã«ãããä¸é£ã®`or`ãç°¡ç¥åãããããªãæ¹æ³ãããã¾ããElixirã¯1ã¤ã®ç¯ã«ãè¤æ°ã®ã¬ã¼ãããæ¸ããã¨ããµãã¼ããã¦ãã¾ããä»¥ä¸ã¯: ãã®ãã§ãã¯ãå¿è¦ãªåº¦ã«ãããç¹°ãè¿ãæ¸ããã¨ã«ãªãã§ããããããã§ããã®ã»ã¯ã·ã§ã³ã®åãã§è¿°ã¹ãããã«ããã¯ã­ãä½¿ã£ã¦ãããæ½è±¡åãããã¨ãã§ãã¾ãããã®ãã§ãã¯ãå®è¡ããé¢æ°ãå®ç¾©ãããã¨ã¯ã§ããªããã¨ãæãåºãã¦ãã ãããã«ã¹ã¿ã é¢æ°ã¯ã¬ã¼ãã§ä½¿ããªãããã§ãããã¯ã­ã¯æ¬¡ã®ããã«ãªãã§ããã: é¢æ°`empty_map?/1`ããã¿ã¼ã³ãããã®ä½¿ç¨ã ãã§æ¸ããã¨ã¯ä¸å¯è½ã§ãããï¼`%{}`ã®ãã¿ã¼ã³ãããã¯ç©ºã®ãããã ãã§ãªã*ãã¹ã¦ã®*ã®ãããã«ãããããããã§ãï¼ã ```elixir
def empty_map?(map) when map_size(map) == 0, do: true
def empty_map?(map) when is_map(map), do: false
``` ```elixir
def foo(term)
    when is_integer(term)
    when is_float(term)
    when is_nil(term) do
  :maybe_number
end ```elixir
def foo(term) when is_integer(term) or is_float(term) or is_nil(term),
  do: :maybe_number
def foo(_other),
  do: :something_else
``` ```elixir
def my_function(number) when is_integer(number) and rem(number, 2) == 0 do
  # do stuff
end
``` ```elixir
defmodule MyInteger do
  defmacro is_even(number) do
    quote do
      is_integer(unquote(number)) and rem(unquote(number), 2) == 0
    end
  end
end
``` ```elixir
iex> case "hello" do
...>   something when length(something) > 0 ->
...>     :length_worked
...>   _anything_else ->
...>     :length_failed
...> end
:length_failed
``` ```elixir
iex> length("hello")
** (ArgumentError) argument error
``` ```elixir
import MyInteger, only: [is_even: 1] ããã¦ãæ¬¡ã®ããã«ä½¿ãã¾ã: æ¬¡ã®ããã«ãæ¸ããã¨ãã§ãã¾ã: def foo(_other) do
  :something_else
end
``` def my_function(number) when is_even(number) do
  # do stuff
end
``` 