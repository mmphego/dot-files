import os
import subprocess
import sys
import time


class Style:
    BOLD = "\033[1m"
    END = "\033[0m\n"
    RED = "\033[91m"
    LINE = "\n"


modulenames = ", ".join(list(set(sys.modules) & set(globals())))
msg = "---> Automagically imported these packages (if available): {}".format(modulenames)
formatted_msg = Style.LINE + Style.BOLD + Style.RED + msg + Style.END
print(formatted_msg)
