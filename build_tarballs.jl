using BinaryBuilder

# Collection of sources required to build libRmath
sources = [
    "https://github.com/JuliaLang/Rmath-julia/archive/v0.2.0.tar.gz" =>
    "087ada2913c5401c5772cde1606f9924dcb159f1c9d755630dcce350ef8036ac",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd Rmath-julia-*/

# The Rmath-julia makefile is kind of silly
MAKEVARS="fPIC=-fPIC prefix=$prefix"
libdir=$prefix/lib

# It needs to be told it's on Windows
if [[ ${target} == *mingw* ]]; then
    MAKEVARS="${MAKEVARS} OS=Windows_NT"
    libdir=$prefix/bin
fi

# Build it
make ${MAKEVARS} CC="$CC" CXX="$CXX" -j${nproc}

# Install it
mkdir -p $libdir $prefix/include
mv src/libRmath-julia*.${dlext} $libdir/
mv include/* $prefix/include/
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libRmath", :libRmath)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libRmath", sources, script, platforms, products, dependencies)
