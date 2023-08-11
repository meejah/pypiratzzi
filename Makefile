.PHONY: pin

pin:
	pip-compile --upgrade --allow-unsafe --generate-hashes --resolver=backtracking --output-file requirements-pinned.txt

release: ##pin
	python update-version.py
	hatchling build
	gpg --pinentry=loopback -u meejah@meejah.ca --armor --detach-sign dist/hancock-`git describe --abbrev=0`-py3-none-any.whl
	gpg --pinentry=loopback -u meejah@meejah.ca --armor --detach-sign dist/hancock-`git describe --abbrev=0`.tar.gz

undo-release:
	-ls dist/hancock-`git describe --abbrev=0`*
	-rm dist/hancock-`git describe --abbrev=0`*
	git tag -d `git describe --abbrev=0`

release-upload:
	@ls dist/hancock-`git describe --abbrev=0`*
	twine upload dist/hancock-`git describe --abbrev=0`*
