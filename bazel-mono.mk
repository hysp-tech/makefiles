.PHONY: format-build

format-build:  ## Format Bazel BUILD file
	bazel run //:gazelle