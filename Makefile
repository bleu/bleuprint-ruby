.PHONY: sorbet/update sorbet/verify

sorbet/native:
	bundle exec srb tc

sorbet/verify-ungenerated:
	bin/tapioca dsl --verify && bin/tapioca gems --verify

sorbet/update:
	bin/tapioca require
	bin/tapioca gem
	bin/tapioca annotations
	bin/tapioca dsl
	bin/tapioca todo
