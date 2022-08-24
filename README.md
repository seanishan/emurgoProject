# emurgoVM
## A Simple Bytecode Evaluation Machine written in Haskell

This is a simple bytecode machine written in Haskell that takes a list of bytecode instructions for a stack machine, and executes 
executes them while also continuously logging state of the Stack Machine.

## The Instructions

There are some simple memory and arithmetic instructions that are supported in this bytecode machine.
The instructions are:
1. LOAD_VAL Int: Loads a value into the stack
2. READ_VAR Char: Reads a variable value and pushes it into the stack
3. WRITE_VAR Char: Pops top value from stack and writes to variable (0 by default)
4. ADD : Pops top 2 values, adds them, and pushes them to stack.
5. MULTIPLY : Pops top 2 values, multiplies them, and pushes them to stack.
6. DIVIDE : Pops top 2 values, divides them, and pushes them to stack.
7. SUBTRACT : Pops top 2 values, subtracts them, and pushes them to stack.
8. RETURN_VALUE : Pops top value and pushes it to stack.
9. HALT : This halts to program

## Implementation

The bytecode is implemented using a Sum Data type which defines all the required instructions.

Another helper datatype called StateP is defined that stores the state of the stack machine after each instruction is executed.

The bytecode is fed into the machine as a list of instructions of type [ByteCode]

This list is then evaluated by the function runByteCode.
This is its type signature:
runByteCode :: [ByteCode] -> StateP -> Maybe [StateP]

It returns Maybe [StateP]. I used Maybe as a method of error handling.
This is a log of all the changes in state to the stack machine throughout the execution of the program.

While the State Monad can be used to implement something similar.
I wanted to try doing the whole implementation using nothing but Maybe as a challenge.

The runByteCode function evaluates each instruction and considers the different possible failure cases for each.

## Example Code

I initialize the StateP as emptySP and store the Bytecode in bcList. The State logs are stored in the valt variable.

## Display function formattedLogs

I also wrote a function called formattedLogs that prints the Logs in a much more readable way.
We can examine the State log valt by running main in the repl.

## Conclusion

This is how I implemented a simple stack machine in Haskell. While this is a fairly naive implementation of said machine,
it definitely helped me get a better grasp of how to handle errors in complex programs while not introducing too much impurity to the 
code. It also helped me realize the amount of convenience offered by the State Monad. It was fun doing this project and also has helped me in thinking in the functional paradigm.