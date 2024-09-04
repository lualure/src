import sys,ast

def coerce(s):
    try: return ast.literal_eval(s)
    except Exception:return s

def arg(i): return coerce(sys.argv[i] if i <= len(sys.argv)-1 else "")
def noop(*l): return l

#For mode colors, exec
# https://gist.github.com/rene-d/9e584a7dd2935d0f461904b9f2950007
def red(s):    return f"\033[0;31m{s}\033[0m"
def green(s):  return f"\033[0;32m{s}\033[0m"
def yellow(s): return f"\033[1;33m{s}\033[0m"

print("red",red("red"))
print("green",green("green"))
print("yellow",yellow("yellow"))

class go:
    def noop(_): 
        "do nothong"
        pass
    def ok(i):  
        "do pass"
        sys.exit(0)
    def fail(i): 
        "do fail"
        sys.exit(1)
    def arg(i): 
        "cli arg type coercion"
        print(">>",i,type(i))

for i,s in enumerate(sys.argv):
    fun = getattr(go, s[1:], None)
    if fun:
        print(fun.__doc__)
        fun( arg(i+1) ) 