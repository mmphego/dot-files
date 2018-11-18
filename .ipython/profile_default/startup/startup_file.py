import time
import sys
import os


class Style:
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

errmsg = ''

try:
    import matplotlib.pyplot as plt
except Exception as _exp:
    errmsg += "{}ERROR:{} {}\n".format(Style.RED, Style.END, str(_exp))
try:
    import numpy as np
except Exception as _exp:
    errmsg += "{}ERROR:{} {}\n".format(Style.RED, Style.END, str(_exp))

msg = (
    "{}---> Automagically imported these packages (if available): time, sys, os, plt and np {}".format("".join([Style.BOLD, Style.RED]), Style.END))
try:
    assert errmsg
    print("\n{}\n{}".format(errmsg, msg))
except Exception:
    print(msg)
