# Additional architecture-specific rules that are allowed to depend on
# COMPILER_TYPE/LINKER_TYPE/etc.

# ld.lld does not support linker relaxations yet.
ifeq ($(LINKER_TYPE),lld)
ARCH_COMPILEFLAGS += -mno-relax
endif
