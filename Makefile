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
	twine upload --username __token__ --password `cat PRIVATE-release-token` dist/pypiratzzi-`git describe --abbrev=0`*
	mv dist/pypiratzzi-`git describe --abbrev=0`.tar.gz.asc signatures/
	mv dist/pypiratzzi-`git describe --abbrev=0`-py3-none-any.whl.asc signatures/
	git add signatures/pypiratzzi-`git describe --abbrev=0`.tar.gz.asc
	git add signatures/pypiratzzi-`git describe --abbrev=0`-py3-none-any.whl.asc
	git commit -m "signatures for release"
