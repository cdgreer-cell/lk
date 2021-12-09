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
check_compiler_flag = $(shell $(CC) -c -xc /dev/null -o /dev/null $(1) 2>/dev/null && echo yes || echo no)
ifeq ($(LINKER_TYPE),lld)
# TODO: Add a clang version check once https://reviews.llvm.org/D107280 lands.
ifeq ($(COMPILER_TYPE),clang)
ARCH_COMPILEFLAGS += -fPIE
_have_direct_access := $(call check_compiler_flag,-fdirect-access-external-data)
$(info -fdirect-access-external-data supported = $(_have_direct_access))
ifeq ($(_have_direct_access),yes)
ARCH_COMPILEFLAGS += -fdirect-access-external-data
endif
endif
endif
