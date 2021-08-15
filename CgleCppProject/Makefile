build-target:
	cmake -S standalone -B build/standalone
	cmake --build build/standalone ./build/standalone/Greeter --help

build-test-suite:
	cmake -S test -B build/test
	cmake --build build/test
	CTEST_OUTPUT_ON_FAILURE=1 cmake -DENABLE_TEST_COVERAGE=1 --build build/test --target test

format:
	cmake -S test -B build/test
	cmake --build build/test --target format
	cmake --build build/test --target fix-format

build-docs:
	cmake -S documentation -B build/doc
	cmake --build build/doc --target GenerateDocs
	open build/doc/doxygen/html/index.html