
import click
import treq
from twisted.python.filepath import FilePath
from twisted.internet.task import react
from twisted.internet.defer import ensureDeferred
from twisted.web.http_headers import Headers


@click.command()
@click.option(
    "--signatures",
    default=".",
    help="The directory where signatures will be written to (and read from)",
    type=click.Path(file_okay=False, writable=True, resolve_path=True, exists=True),
)
@click.argument("package")
def pypiratzzi(*args, **kw):
    react(
        lambda reactor: ensureDeferred(
            _run_pypiratzzi(reactor, *args, **kw)
        )
    )


async def _run_pypiratzzi(reactor, signatures, package):
    """
    Download all signatures for the given ``package`` that aren't
    already in the directory of ``signatures``.
    """
    signatures = FilePath(signatures)
    existing = _load_existing_signatures(signatures)
    result = await treq.get(
        f"https://pypi.org/simple/{package}",
        headers=Headers({"accept": ["application/vnd.pypi.simple.v1+json"]}),
    )
    content = await result.json()
    files = [
        tuple((js["filename"], js["url"]))
        for js in content["files"]
        if not js["yanked"]
    ]
    for fname, url in files:
        asc_url = url + ".asc"
        local_child = signatures.child(fname + ".asc")
        print(f"{fname}.asc:", end="", flush=True)
        if local_child.exists():
            print(" cached")
            continue
        result = await treq.get(asc_url)
        if result.code >= 300:
            print(f" failed {result.code}")
            continue
        print(" .", end="", flush=True)
        data = await result.content()
        print(f". {len(data)} bytes")
        with local_child.open("wb") as f:
            f.write(data)


def _load_existing_signatures(fp):
    """
    :returns: sequence of FilePath instances of all existing
        signature-looking files in ``fp``.
    """
    return [
        child
        for child in fp.children()
        if child.splitext()[1] == ".asc"
    ]


def _entry():
    pypiratzzi()
