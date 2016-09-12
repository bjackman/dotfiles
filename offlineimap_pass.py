# Ridiculous nonsense to get offlineimap to use a password that isn't plaintext
# in .offlineimaprc.

# i t ' s .-~-. t h e .-~-. u n i x .-~-. w a y

# In your .offlineimaprc, under [general] add:
# pythonfile = /path/to/this/file.py

import sys
import os
import getpass
import gnomekeyring

from subprocess import check_output

# Using `pass`:

# You need to add your password to 'pass', say its name is X.
# Under the [Repository Foo] section (for the remote), add
# remotepasseval = get_password_from_pass("X")
def get_password_from_pass(pass_name):
    return check_output(["pass", pass_name]).splitlines()[0]


# Using Gnome Keyring:

# First, run this script from a shell so that we can add the relevant password
# to Gnome Keyring. Then,
# Under the [Repository Foo] section (for the remote), add
# remotepasseval = get_gnome_keyring_password(<repository>)

def set_gnome_keyring_credentials(repo, user, pw):
    KEYRING_NAME = "offlineimap"
    attrs = { "repo": repo, "user": user }
    keyring = gnomekeyring.get_default_keyring_sync()
    gnomekeyring.item_create_sync(keyring, gnomekeyring.ITEM_NETWORK_PASSWORD,
        KEYRING_NAME, attrs, pw, True)

def get_gnome_keyring_password(repo):
    keyring = gnomekeyring.get_default_keyring_sync()
    attrs = {"repo": repo}
    items = gnomekeyring.find_items_sync(gnomekeyring.ITEM_NETWORK_PASSWORD, attrs)
    return items[0].secret

def set_credentials(repo, user, pw):
    KEYRING_NAME = "offlineimap"
    attrs = { "repo": repo, "user": user }
    keyring = gnomekeyring.get_default_keyring_sync()
    gnomekeyring.item_create_sync(keyring, gnomekeyring.ITEM_NETWORK_PASSWORD,
        KEYRING_NAME, attrs, pw, True)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print "Usage: %s <repository> <username>" \
            % (os.path.basename(sys.argv[0]))
        sys.exit(1)
    repo, username = sys.argv[1:]
    password = getpass.getpass("Enter password for user '%s': " % username)
    password_confirmation = getpass.getpass("Confirm password: ")
    if password != password_confirmation:
        print "Error: password confirmation does not match"
        sys.exit(1)
    set_credentials(repo, username, password)
