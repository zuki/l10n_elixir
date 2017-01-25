Þ          t      Ì         R        d  8     q  ¼  G   .  %   v  '     #   Ä     è  7    I  =  V     *   Þ  O   	  Ò  Y  q   ,	  7   	  =   Ö	  %   
  %   :
  ±  `
            
                          	                      An implementation of the command callback that
is shared across different shells.
 Defines `Mix.Shell` contract.
 Executes the given command and returns its exit status.
 Executes the given command and returns its exit status.

## Options

  * `:print_app` - when `false`, does not print the app name
    when the command outputs something

  * `:stderr_to_stdout` - when `false`, does not redirect
    stderr to stdout

  * `:quiet` - when `true`, do not print the command output

  * `:env` - environment options to the executed command

 Prints the current application to the shell if
it was not printed yet.
 Prints the given error to the shell.
 Prints the given message to the shell.
 Prompts the user for confirmation.
 Prompts the user for input.
 Returns the printable app name.

This function returns the current application name,
but only if the application name should be printed.

Calling this function automatically toggles its value
to `false` until the current project is re-entered. The
goal is to avoid printing the application name
multiple times.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-24 18:04+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 è¤æ°ã®ã·ã§ã«ã§å±æãããã³ãã³ã
ã³ã¼ã«ããã¯ã®å®è£ã§ãã
 `Mix.Shell`ã®åå®ãå®ç¾©ãã¾ãã
 æå®ããã³ãã³ããå®è¡ããçµäºã¹ãã¼ã¿ã¹ãè¿ãã¾ãã
 æå®ããã³ãã³ããå®è¡ããçµäºã¹ãã¼ã¿ã¹ãè¿ãã¾ãã

## ãªãã·ã§ã³

  * `:print_app` - `false`ã®å ´åãã³ãã³ããä½ãããåºåããé
    ã¢ããªåãè¡¨ç¤ºãã¾ãã

  * `:stderr_to_stdout` - `false`ã®å ´åãstderrãstdoutã«
    ãªãã¤ã¬ã¯ããã¾ãã

  * `:quiet` - `true`ã®å ´åãã³ãã³ãã®åºåãè¡¨ç¤ºãã¾ãã

  * `:env` - å®è¡ãããã³ãã³ãã¸ã®ç°å¢ãªãã·ã§ã³

 ã«ã¬ã³ãã¢ããªã±ã¼ã·ã§ã³ãã¾ã è¡¨ç¤ºããã¦ããªãã£ãå ´å
ã·ã§ã«ã«è¡¨ç¤ºãã¾ãã
 æå®ããã¨ã©ã¼ãã·ã§ã«ã«è¡¨ç¤ºãã¾ãã
 æå®ããã¡ãã»ã¼ã¸ãã·ã§ã«ã«è¡¨ç¤ºãã¾ãã
 ã¦ã¼ã¶ã«ç¢ºèªãä¿ãã¾ãã
 ã¦ã¼ã¶ã«å¥åãä¿ãã¾ãã
 è¡¨ç¤ºå¯è½ãªappåãè¿ãã¾ãã

ãã®é¢æ°ã¯ãã¢ããªã±ã¼ã·ã§ã³åãè¡¨ç¤ºããã
ã¹ãå ´åã«ã®ã¿ãç¾å¨ã®ã¢ããªã±ã¼ã·ã§ã³åãè¿ãã¾ãã

ãã®é¢æ°ãå¼ã³åºãã¨ãã«ã¬ã³ããã­ã¸ã§ã¯ãã
åæå¥ãããã¾ã§ãèªåçã«ãã®å¤ã`false`ã«ãã°ã«ãã¾ãã
ãã®ç®çã¯ã¢ããªã±ã¼ã·ã§ã³åãè¤æ°åè¡¨ç¤ºããã®ã
é¿ãããã¨ã§ãã
 