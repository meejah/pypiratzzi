
hancock
=======

PyPI stopped accepting signatures for uploaded artifacts.
Hancock downloads all signatures for all releases for a project from PyPI.

One use-case for this is to commit all past signatures to source-control.


Using hancock
-------------

Running ``hancock magic-wormhole`` will use the PyPI Legacy API in JSON mode (as recommended by their documentation) to find all the releases and artifacts for "magic-wormhole".
It will then download any missing signatures (use option ``--signatures`` the existing signatures are not found in ".", the current directory).
