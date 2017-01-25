Þ          4      L       `   æ  a   Ð  H  I    6  c  `                      A protocol to traverse data structures.

The `Enum.into/2` function uses this protocol to insert an
enumerable into a collection:

    iex> Enum.into([a: 1, b: 2], %{})
    %{a: 1, b: 2}

## Why Collectable?

The `Enumerable` protocol is useful to take values out of a collection.
In order to support a wide range of values, the functions provided by
the `Enumerable` protocol do not keep shape. For example, passing a
map to `Enum.map/2` always returns a list.

This design is intentional. `Enumerable` was designed to support infinite
collections, resources and other structures with fixed shape. For example,
it doesn't make sense to insert values into a range, as it has a fixed
shape where just the range limits are stored.

The `Collectable` module was designed to fill the gap left by the
`Enumerable` protocol. `into/1` can be seen as the opposite of
`Enumerable.reduce/3`. If `Enumerable` is about taking values out,
`Collectable.into/1` is about collecting those values into a structure.
 Returns a function that collects values alongside
the initial accumulation value.

The returned function receives a collectable and injects a given
value into it for every `{:cont, term}` instruction.

`:done` is passed when no further values will be injected, useful
for closing resources and normalizing values. A collectable must
be returned on `:done`.

If injection is suddenly interrupted, `:halt` is passed and it can
return any value, as it won't be used.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-23 12:05+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 ãã¼ã¿æ§é ããã©ãã¼ã¹ãããã­ãã³ã«ã§ãã

`Enum.into/2`é¢æ°ã¯ã³ã¬ã¯ã·ã§ã³ã«enumerableãæ¿å¥ããããã«
ãã®ãã­ãã³ã«ãä½¿ç¨ãã¾ãã

    iex> Enum.into([a: 1, b: 2], %{})
    %{a: 1, b: 2}

## ãªãCollectableãå¿è¦ã

`Enumerable` ãã­ãã³ã«ã¯å¹åºãå¤ããµãã¼ãããããã«ã³ã¬ã¯ã·ã§ã³ãã
å¤ãå¾ãã®ã«å½¹ç«ã¡ã¾ãã`Enumerable`ãã­ãã³ã«ã«ããæä¾ãããé¢æ°ã¯
å½¢ãä¿å­ãã¾ããããã¨ãã°ã`Enum.map/2`ã«ããããæ¸¡ãã¨å¸¸ã«ãªã¹ããè¿ãã¾ãã

ãã®è¨­è¨ã¯æå³çãªãã®ã§ãã`Enumerable`ã¯ç¡éã®ã³ã¬ã¯ã·ã§ã³ããªã½ã¼ã¹ã¨
åºå®ããå½¢ãæã¤æ§é å¤ããµãã¼ãããããã«è¨­è¨ããã¾ããããã¨ãã°ã
å¤ãç¯å²ã«æ¿å¥ãããã¨ã¯æå³ããªãã¾ãããç¯å²ã¯ç¯å²ã®éçãæ ¼ç´ãã
åºå®ã®å½¢ãæã£ã¦ããã ãã ããã§ãã

`Collectable`ã¢ã¸ã¥ã¼ã«ã¯`Enumerable` ãã­ãã³ã«ã«ããæ®ãããã®ã£ãããåãã
ããã«è¨­è¨ããã¾ããã`into/1`ã¯`Enumerable.reduce/3`ã®æ­£åå¯¾ã®ãã®ã¨è¦ã
ãã¨ãã§ãã¾ãã`Enumerable`ãå¤ãåãåºãããã®ãã®ã ã¨ããã°ã
`Collectable.into/1`ã¯ãã®ãããªå¤ãæ§é ä½ã«éããããã®ãã®ã§ãã

 åæèç©å¤ã¨å±ã«å¤ãéãã
é¢æ°ãè¿ãã¾ãã

è¿ãããé¢æ°ã¯collectableãååãã å½ä»¤`{:cont, term}`ã
åãåããã¨ã«æå®ãããå¤ãããã«æ¿å¥ãã¾ãã

ããä»¥ä¸æ¿å¥ããå¤ããªããªãã¨`:done`ãæ¸¡ããã¾ããããã¯
ãªã½ã¼ã¹ãéããå¤ãæ­£è¦åããã®ã«å½¹ç«ã¡ã¾ããcollectableã¯
`:done`ã§è¿ããªããã°ãªãã¾ããã

æ¿å¥ãçªç¶ä¸­æ­ãããå ´åã¯ã`:halt`ãæ¸¡ããã¾ãããã®å ´åã¯
ä»»æã®å¤ãè¿ããã¨ãã§ãã¾ããããã¯æ±ºãã¦ä½¿ç¨ãããªãããã§ãã
 