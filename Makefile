.PHONY: pin

pin:
	pip-compile --upgrade --allow-unsafe --generate-hashes --resolver=backtracking --output-file requirements-pinned.txt

release: ##pin
	python update-version.py
	hatchling build
	gpg --pinentry=loopback -u meejah@meejah.ca --armor --detach-sign dist/pypiratzzi-`git describe --abbrev=0`-py3-none-any.whl
	gpg --pinentry=loopback -u meejah@meejah.ca --armor --detach-sign dist/pypiratzzi-`git describe --abbrev=0`.tar.gz
	twine check dist/pypiratzzi-`git describe --abbrev=0`-py3-none-any.whl

undo-release:
	-ls dist/pypiratzzi-`git describe --abbrev=0`*
	-rm dist/pypiratzzi-`git describe --abbrev=0`*
	git tag -d `git describe --abbrev=0`

release-upload:
	@ls dist/pypiratzzi-`git describe --abbrev=0`*
	twine upload --username __token__ dist/pypiratzzi-`git describe --abbrev=0`*
