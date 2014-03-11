PRJ_DIR := ..
TARGETS := XDSXql

CXX := g++

all: $(TARGETS)

$(TARGETS):	YaccParam.hpp SqlLexScan.l SqlSyntax.y YaccParam.hpp XDSXql.cpp
	bison -d SqlSyntax.y -o SqlSyntax.cpp;
	flex -o SqlLexScan.cpp SqlLexScan.l
	$(CXX) -o $@ *.cpp

install:
	cp -f $(TARGETS) $(PRJ_DIR)/bin

clean::
	rm -f $(TARGETS) *.o
	rm -f SqlSyntax.cpp SqlLexScan.cpp SqlSyntax.hpp
