#!/usr/bin/env python3.13

import traceback,random,sys,ast # Python has many useful packages now
 
atom = str | bool | int | float # Python's type system is extensible, useful for do

def coerce(s:str) -> atom:  # safety type: coerce strings in a limited way
    "sting to atom"
    try: return ast.literal_eval(s)
    except Exception:
        assert type(s)==str, "bad type"
        return s

def arg(i:int) -> atom: # python can acess the command like via sys.argv
    "parse item 'i' from the command line"
    return coerce(sys.argv[i] if i <= len(sys.argv)-1 else "")

def noop(*l: list) -> list:  # *l means "all positional apramaters"
    return l

# Color hacking, in Python, with magic escape sequences. For more colors,  
# see https://gist.github.com/rene-d/9e584a7dd2935d0f461904b9f2950007
def red(s:str)    -> str:  return f"\033[0;31m{s}\033[0m"
def green(s:str)  -> str:  return f"\033[0;32m{s}\033[0m"
def yellow(s:str) -> str:  return f"\033[1;34m{s}\033[0m"

class go: # classes are boxes that stores names. Names can be accessed via "dir"
    def _all(): 
        "return all public actions"  
        return [s for s in dir(go) if  s[0] !="_" and s!="all" ] # under _ usually means private
    
    def _show(s:str):   # functions are boxes that store code and a __doc__ string
        "describe action 's'"
        doc = getattr(go,s).__doc__ or ""
        print(f"{yellow(s)}\t: {doc.replace("\n"," ")}")

    def _one(s): 
        passed=True; 
        if s in dir(go):
            go._show(s)
            try: passed= getattr(go,s)() # try except catches errors
            except Exception:            # never except on "base" https://realpython.com/python-built-in-exceptions/#glancing-at-the-exceptions-hierarchy
                traceback.print_stack()  # traceback shows execution stack to the try (not to the except)
                passed=False 
            if passed==False:
                print(red("FAILED " + s))
        return passed # we "fail" if our code returns fail, or if it crashes
        
    def all():
        "return to operatoring system, sum of all running tests"
        sys.exit(sum(go._one(s)==False for s in go._all())) # True, False = 1,0. So we can "sum" booleans
        # $? is the number of errors. $? is > 0 then error and we need to change flag

    def show(): 
        "describe all actions"
        [go._show(s) for s in go._all()] # list comprehensions are cool
    
    def noop(): 
        "do nothing"
        assert 3==4
        pass

    def fail(): 
        "do nothing"
        return False

    def arg(): 
        """cli arg type coercion
        and stuff"""
        i="33" 
        assert type(i)==str, "arg making float"
        
    def rand(): 
        "show random"
        random.seed(10)
        print(random.random())

    def type():
        "good and bad type"
        assert type(coerce("1")) == int
        print(coerce("os.system('sudo rm -rf /')"))

[go._one(s[1:]) for i,s in enumerate(sys.argv)] # strings can be maniupulated like lists
    
