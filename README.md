yasic
=====
yet another symbolic instruction code is a programming language (yeah, yet another programing language. again! (spoiler: there will be a project called *yapla* :-))) and transcompiler to flatassembly, which is written entirely in the macro-language of [flatassembler](http://flatassembler.net/), so do not worry if it is slowly (about 0.9s for the provided example). this is the nature of interpreted languages :-/
the compiled form is an `.sba`-executable which could be loaded with yalave.

nevertheless it is awes0me.

usage and key files
-------------------
you need [flatassembler](http://flatassembler.net/download.php "click here to download flatassembler"),
[yalave](https://github.com/sivizius/yalave "yet another loader and virtual environment"),
[yalib](https://github.com/sivizius/yalib "yet another libraries, includes, blueprints"),
[cookies](https://github.com/sivizius/cookies "o0oOO0o0oOo <- for free") and
[sasha](https://github.com/sivizius/sasha "sivican absorption and squeezing hash algorithm")
to build and run it.
* *edit.sh* - edit repository with system-editor (nano, vim, etc)
* *make.sh* - build repository
* *exec.sh* - run repository, this may launch teh nukes
* *conf.sh* - perhaps useful sometime later
* code/*.sba - example input for the yasic-compiler
* stat/parser.finc - actual compiler in fasm-macros

Getting started
---------------
First of all some terms should be defined:
* »source« or »code«: the code you write in yasic
* »output«: the output this compiler produce or the compiled form of it
* »input«: the input for your compiled program

A source file must start with this header:
```bash
#!sba:yasic
```
and a newline character.

Then you could write some code, e.g.:
```assembly
label
{
  'hello world'
  {
    #print some text
    echo('hello my friend')
    jump('label')
  }
}
```
`label {}` defines a new label in the output. You could refer to it e.g. with `jump('label')`, which creates `jmp label` in the output. After a label a block (`{ [...] }`) have to follow.

To compare the input with a regular expression, you could use `'something' {}`. This compares the input with the string »something«. If this comparison is true, the block would be executed, if not, the output jumps to the end of the block. I go into detail later.

If you just want to remark or just do not want something in the output, you could use comments:
```bash
#comment from »#« to the end of the line.
```
There are also some predefined functions like `echo('text')` to let the output call an echo-function to print _'text'_ or `jump('label')` to jump to _label_.
The end of a function-call is a `;` or a newline character, so if you want everything on one line, you have to use `;` at the end:
```c
'hello world' { echo('hello my friend'); }
```
It is time to compile this piece of code!
Yasic is written in flatassembler so you need to [download](http://flatassembler.net/download.php) it, if not already done so far.
I also provided an [shell-script](https://github.com/sivizius/yasic/blob/master/sba.sh), but you could compile your source with:
```shell
fasm -m 512000 "yasic.fcfg" "output.fasm"
```
But before you compile `yasic.fcfg`, you need to adjust the name of your source-file in this line of [`yasic.fcfg`](https://github.com/sivizius/yasic/blob/master/yasic.fcfg):
```assembly
yasic_parse 'source-file.sba'
```
There are some examples in the _code_-directory.

There are also some other options for the compiler in this file:
* to define the name of the echo-function in output:
```assembly
yasic.OpEcho          equ 'echo_put'
```
* call this to get a new character:
```assembly
yasic.GetChar         equ 'files.getChar'
```
* if `echo` should called like this: `echo_put qword [ msg_0000000000000000 ]`, set this option
```assembly
yasic.IndirectString  equ false
```

* set the structure of strings (e.g. `db`):
```assembly
yasic.Symbol          equ 'str'
```
* where is the return-value of getChar? (e.g. `rax`)
```assembly
yasic.TheChar         equ 'my_char'
```
* if this option is true, the output is smaller, but less readable
```assembly
yasic.MagicNumbers    equ false
```
* set the indentation (not the indentation-size!)
```assembly
yasic.Depth           equ 0
```

Regular Expressions
-------------------
Well, the regex I used in yasic are similar to PCRE, but not the same!
Yasic does not support quantifiers yet, character-classes and ranges are a bit different and groups are only implemented very thin.
To define a regular expression you just had to write:
```c
'regex' {}
```
Yasic supports the wildcard `.` for any character and escape sequences for some special characters and even some character-classes with `\`:
```c
'regex..\.\W\n' {}
```
To compare the input with a class of characters, you just put the name of the class in `<` and `>`:
```c
'<alnum><A><B><C>' {}
```
If you just put one character into this brackets, e.g. `<A>`, the regular expression match _a_ and _A_, if you do not put them into brackets, the regex is case-sensitive!

To define a range, you have to put the start and the end into `[` and `]`:
```c
'[09][AZ|az]' {}
```
This also allows multiple ranges, seperated with `|`, so this regular expression match _1a_, _9Z_, but not _a9_.
But note that the characters must be sorted to their ascii values!
This would match _A_, _Z_, but never _0_:
```c
'[AZ|09]' {}
```

