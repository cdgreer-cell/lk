# Additional architecture-specific rules that are allowed to depend on
# COMPILER_TYPE/LINKER_TYPE/etc.

# ld.lld does not support linker relaxations yet.
ifeq ($(LINKER_TYPE),lld)
ARCH_COMPILEFLAGS += -mno-relax
endif

# Work around out-of-range undef-weak relocations when building with clang and
# linking with ld.lld. This is not a problem with ld.bfd since ld.bfd rewrites
# the instructions to avoid the out-of-range PC-relative relocation
# See https://github.com/riscv-non-isa/riscv-elf-psabi-doc/issues/126 for more
# details. For now, the simplest workaround is to build with -fpie when using
# a version of clang that does not include https://reviews.llvm.org/D107280.
ifeq ($(LINKER_TYPE),lld)
# TODO: Add a clang version check once https://reviews.llvm.org/D107280 lands.
ifeq ($(COMPILER_TYPE),clang)
# TODO: Clang 12+ has -fdirect-access-external-data to avoid the majority of
# the performance overhead caused by -fPIE
ARCH_COMPILEFLAGS += -fPIE
endif
endif
