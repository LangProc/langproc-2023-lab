Lab 1: Lexers and regular expressions
=====================================

This lab is about lexers and regular expressions. It is intended to give you enough working knowledge and experience to be able to design and implement the C lexer for your compiler.

Specification
-------------

Write a tool using Flex that reads an ASCII stream of text,

- calculates the sum of any _numbers_ in the text, and

- calculates a histogram of any _words_ in the text.

For our purposes we'll define words and numbers as follows:

- A **word** is any contiguous sequence of lower-case or upper-case alphabetic characters.

- A **word** can also be any sequence of 8-bit characters beginning with `[`, and ending at the next `]`. The word itself does not include the surrounding `[` and `]` characters. You can assume that such a sequence will never span a line-break.

- A **number** can be expressed as a decimal or as a fraction.

- A **decimal** is a sequence of one or more decimal digits, preceded by an optional `-` sign, and optionally followed by a `.` sign and zero or more decimal digits. It should be interpreted as a decimal double-precision number.

- A **fraction** consists of an optional leading `-` sign, a sequence of one or more decimal digits, a `/` sign, and another sequence of one or more decimal digits. It should be interpreted by converting the two digit sequences into decimal integers, then taking the ratio using double-precision.
  
- You can assume that fractions with zero denominators will not appear in any test inputs.

All other characters should not be counted (and should not appear in the output).

The output should be:

- One line containing the sum of the numbers. This should be printed in decimal, and include exactly three fractional digits.

- A sequence of lines for each element in the dictionary, containing the word surrounded by square brackets, a space, then the decimal count. The lines should be sorted primarily by the number of times the word occurs (from most to least), and secondarily by lexicographic order (i.e. the order the words would appear in a dictionary).

The program should be built by running the command `make histogram`.

There is already a skeleton program setup, including:

- Flex source: [histogram_lexer.flex](histogram_lexer.flex)

- C++ driver program: [histogram_main.cpp](histogram_main.cpp)

- Makefile: [makefile](makefile)

The skeleton setup contains a number of comments suggesting where
things need to be changed and edited, but these are not exhaustive.

Examples
--------

Given the input:
````
abc 40 xyz 1 xyz -2
````
The output should be:
````
39.000
[xyz] 2
[abc] 1
````

Given the input:
````
a a a aa -67 1/2  -80 -6780.0  64/8 for while
[  x],, 52x
````
The output would be:
````
-6866.500
[a] 3
[  x] 1
[aa] 1
[for] 1
[while] 1
[x] 1
````

There is also a test-bench included, which is a partial set of test vectors for the program. Passing these tests is equivalent to achieving 50% in the final assessment, with unseen tests covering the remaining 50%.

The components of the test are:

- [`test/in`](test/in): A set of input test files of increasing complexity. Notice that it tries to test for specific circumstances and possible failure modes, before moving onto more general tests.

- [`test/ref`](test/ref): The "golden" output for the given input files, which your program should match. There is one output for each input.

- [`test_lexer.sh`](test_lexer.sh): A [`bash`](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script that runs the tests. It will build your program, then apply it to each input in turn to produce a file in `test/out`. It will then use [diff](https://en.wikipedia.org/wiki/Diff_utility) to work out whether the output matches the reference output.

You can run the program via the command:
````
./test_lexer.sh
````

NB: the [unix execute permissions](https://en.wikipedia.org/wiki/Modes_(Unix))
may have been lost, in which case you can indicate the script should be
executable with:
````
chmod u+x ./test_lexer.sh
````
