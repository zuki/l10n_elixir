Þ          <      \       p   Ì  q      >  @   S  I      Þ  +   p  D                      Compiles stale Elixir files.

It expects a `manifest` file, the source directories, the source directories to skip,
the extensions to read in sources, the destination directory, a flag to know if
compilation is being forced or not and a callback to be invoked
once (and only if) compilation starts.

The `manifest` is written down with information including dependencies
between modules, which helps it recompile only the modules that
have changed at runtime.
 Reads the manifest.
 Returns protocols and implementations for the given `manifest`.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-24 15:54+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 å¤ãElixirãã¡ã¤ã«ãã³ã³ãã¤ã«ãã¾ãã

å¼æ°ã«ã¯ã`manifest`ãã¡ã¤ã«ãã½ã¼ã¹ãã£ã¬ã¯ããªãã¹ã­ãããã
ã½ã¼ã¹ãã£ã¬ã¯ããªãã½ã¼ã¹ã¨ãã¦èª­ã¿è¾¼ãæ¡å¼µå­ããã¹ãã£ãã¼ã·ã§ã³
ãã£ã¬ã¯ããªãã³ã³ãã¤ã«ãå¼·å¶ãããå¦ããç¤ºããã©ã°ãã³ã³ãã¤ã«ã
éå§ããæï¼ããã³ããã®æã«éãï¼èµ·åããã¹ãã³ã¼ã«ããã¯ãæ³å®ããã¦ãã¾ãã

`manifest`ã¯ã¢ã¸ã¥ã¼ã«éã®ä¾å­é¢ä¿ãå«ãæå ±ãè¨è¼ããã¦ãã¾ãã
å®è¡æã«å¤æ´ãããã¢ã¸ã¥ã¼ã«ã®ã¿ãåã³ã³ãã¤ã«ããã®ã«
å½¹ç«ã¡ã¾ãã
 ãããã§ã¹ããèª­ã¿è¾¼ã¿ã¾ãã
 æå®ãã`manifest`ã®ãã­ãã³ã«ã¨å®è£ãè¿ãã¾ãã
 