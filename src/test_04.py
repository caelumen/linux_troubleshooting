import sys
sys.setrecursionlimit(1<<30)
f = lambda f:f(f)
f(f)
