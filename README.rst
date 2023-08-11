
hancock
=======

PyPI stopped accepting signatures for uploaded artifacts.
Hancock downloads all signatures for all releases for a project from PyPI.

One use-case for this is to commit all past signatures to source-control.


Using hancock
-------------

Example::

```shell
$ hancock --signatures ~/src/magic-wormhole/signatures magic-wormhole
```

This will use the PyPI Legacy API in JSON mode (as recommended by their documentation) to find all the releases and artifacts for "magic-wormhole".
It will then download any missing signatures; ``--signatures`` (defaults to ``.``) says where to cache the signatures (and skips any already found locally).
