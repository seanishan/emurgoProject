module Main where

--QUESTION 1: BYTECODE STACK MACHINE


import Data.List ()   --List is imported to use common functions like head and tail if necessary
import Data.Maybe ( fromMaybe , isJust , fromJust )  --Maybe is imported so that we can handle errors in an easy manner


--DATATYPE SECTION

--This datatype stores a single bytecode instruction and its arguments

data ByteCode = LOAD_VAL Int    --Loads a value into the stack
 | READ_VAR Char                --Reads a variable value and pushes it into the stack
 | WRITE_VAR Char               --Pops the top value from the stack and writes it to the variable
 | ADD                          --Pops the top 2 values,adds them and pushes to stack 
 | MULTIPLY                     --Pops the top 2 values, multiplies them and pushes to stack 
 | DIVIDE                       --Pops the top 2 values, divides them and pushes to stack
 | SUBTRACT                     --Pops the top 2 values, subtracts them and pushes to stack
 | RETURN_VALUE                 --Pops the top value and pushes it to stack
 | HALT                         --Signals end of operation
 deriving (Show)                --Derives Show typeclass



--This is a helper datatype that stores the state of the processor at any given time. Specifically, it shows the stack and the stored variables.

data StateP = StateP { stack :: [Int] , vars :: [(Char,Int)] }
 deriving (Show)                                               --Deriving Show is particularly important for this datatype as we will see later.






--BYTECODE INTERPRETER SECTION
-- My runByteCode function outputs a "Maybe" State of the CPU. This is handy if the student wants to debug.
-- It is also a record of all the states our virtual processor went through.


runByteCode :: [ByteCode] -> StateP -> Maybe [StateP]


runByteCode [] sp = Just []  --This means it is the end of the bytecode program.


runByteCode ((LOAD_VAL x):bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP (x:stack sp) (vars sp)


runByteCode ((WRITE_VAR c):bcs) sp  = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP vs ((c,v):newvars)
        where newvars = [(x,y) | (x,y) <- vars sp , x/=c]              --This is to avoid variables with same name and different values.
              (v:vs) = if not (null (stack sp)) then stack sp else [0] --This pops the top value from stack and writes to variable name c.
--Sidenote: The indentation of the where bindings is extremely important. Also the default value of a variable is set to 0 if stack is empty.


runByteCode ((READ_VAR c):bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP (stackvar++stack sp) (vars sp)
        where stackvar = [y | (x,y) <- vars sp , x==c] -- This ensures existence of the variable


runByteCode (ADD:bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP ((v1+v2):vs2) (vars sp)
        where (v1:vs1) = if not (null (stack sp)) then stack sp else [0] --Checking for exception and giving default value 0
              (v2:vs2) = if not (null vs1) then vs1 else [0]


runByteCode (MULTIPLY:bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP ((v1*v2):vs2) (vars sp)
        where (v1:vs1) = if not (null (stack sp)) then stack sp else [0] --Checking for exception and giving default value 0
              (v2:vs2) = if not (null vs1) then vs1 else [1] --Here, we give default value one since we would like to keep the value in the stack :P.


runByteCode (DIVIDE:bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP (div v1 v2:vs2) (vars sp)
        where (v1:vs1) = if not (null (stack sp)) then stack sp else [0]
              (v2:vs2) = if not (null vs1) then vs1 else [1]  --Again, we assign default values that ensure no data from stack is lost


runByteCode (SUBTRACT:bcs) sp = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
 where sp_new = StateP ((v1-v2):vs2) (vars sp)
        where (v1:vs1) = if not (null (stack sp)) then stack sp else [0]
              (v2:vs2) = if not (null vs1) then vs1 else [0]


runByteCode (HALT:bcs) sp = Just []


runByteCode (RETURN_VALUE:bcs) sp  = Just (sp_new : fromMaybe [] (runByteCode bcs sp_new))
  where sp_new = StateP vs (('r',v):newvars)
         where newvars = [(x,y) | (x,y) <- vars sp , x/='r']
               (v:vs) = if not (null (stack sp)) then stack sp else [0] --The return value is saved in as the variable 'r'.



--This is an example of code running on this bytecode interpreter.

emptySP = StateP [] []
bcList = [WRITE_VAR 'x', LOAD_VAL 4, LOAD_VAL 3, LOAD_VAL 2, WRITE_VAR 'x', READ_VAR 'x', READ_VAR 'x', READ_VAR 'y', ADD, MULTIPLY, DIVIDE, RETURN_VALUE]
valt = runByteCode bcList emptySP

helperLogs :: [StateP] -> [Char]
helperLogs [] = "END\n"
helperLogs (x:xs) = "Stack:" ++ show (stack x) ++ "   Variables:" ++ show (vars x) ++ "\n" ++ (helperLogs xs)

formattedLogs :: Maybe [StateP] -> [Char]
formattedLogs x = case (isJust x) of
                  True -> helperLogs (fromJust x) 
                  False -> "END\n"

main = putStr (formattedLogs valt)