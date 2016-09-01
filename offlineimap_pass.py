# Ridiculous nonsense to get offlineimap to use a password that isn't plaintext
# in .offlineimaprc.

# You need to add your password to 'pass', say its name is X.
# Then In your .offlineimaprc,
# Under [general] add:
# pythonfile = /path/to/this/file.py
# Under the [Repository Foo] section (for the remote), add
# remotepasseval = get_pass("X")

# i t ' s .-~-. t h e .-~-. u n i x .-~-. w a y

from subprocess import check_output

def get_pass(pass_name):
    return check_output(["pass", pass_name]).splitlines()[0]
