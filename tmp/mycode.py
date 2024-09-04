import random,sys,ast

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

class go:
    def _all():   return [s for s in dir(go) if  s[0] !="_"]
    def _show(s): 
        doc = getattr(go,s).__doc__ or ""
        print(f"\t-{yellow(s)}\t: {doc.replace("\n"," ")}")
    def show(_):  [go._show(s) for s in go._all()]
    
    def noop(_): 
        "do nothing"
        pass
    def passed(i):  
        "do pass"
        sys.exit(0)
    def failed(i): 
        "do fail"
        sys.exit(1)
    def arg(i): 
        """cli arg type coercion
        and stuff"""
        print(">>",i,type(i))
    def rand(seed): 
        "show random"
        random.seed(seed or SEED)
        print(random.random())

SEED=1234567891
for i,s in enumerate(sys.argv):
    s=s[1:]
    fun = getattr(go, s, None)
    if fun:
        random.seed(SEED)
        
        fun( arg(i+1) ) 