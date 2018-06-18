.PHONY: all
all:

.PHONY: publish-web
publish-web:
	aws s3 cp --acl public-read --recursive --exclude '.*' public/ s3://www.frklft.tires/
	aws s3 cp --acl public-read public/team.html s3://www.frklft.tires/team
	aws s3 cp --acl public-read public/contact/sales.html s3://www.frklft.tires/contact/sales
	aws s3 cp --acl public-read public/contact/careers.html s3://www.frklft.tires/contact/careers

.PHONY: lint
lint:
	$$(yarn bin)/eslint .
