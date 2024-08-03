# Random Number Generator in LC-3 Assembly

## Project Overview
This project implements a pseudo-random number generator in LC-3 Assembly language. The generator is based on the linear congruential generator (LCG) algorithm, which is commonly used for generating a sequence of pseudo-randomized numbers in computer science.
Random numbers are essential in computer science for various applications, including simulations, cryptographic key generation, and gaming. This project demonstrates how to implement a pseudo-random number generator using the LCG algorithm in LC-3 Assembly. The formula used for generating the sequence is:

\[ X_n = (a \cdot X_{n-1} + b) \mod m \]

where:
- \(a\), \(b\), and \(m\) are non-negative integers.
- \(X_0\) (the seed) is derived from a provided string of characters.

## Input
The input consists of:
1. Three non-negative integers \(a\), \(b\), and \(m\), separated by spaces or new lines.
2. A string of characters used to compute the initial seed \(X_0\). Letters are treated as their index in the alphabet (starting from 0), digits are treated as their numerical values, and other characters are ignored.
3. A non-negative integer \(n\), which indicates the number of random numbers to generate.

## Output
The program outputs \(n\) pseudo-random numbers starting from \(X_1\) to \(X_n\) in hexadecimal format, prefixed with 'x'. Each number is printed on a new line.

## Usage Instructions
1. Load the provided assembly code into the LC-3 simulator.
2. Provide the input in the required format.
3. Run the program to see the generated random numbers printed in hexadecimal format.