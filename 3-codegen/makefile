CXXFLAGS += -std=c++11 -w -Wall -g
CXXFLAGS += -I include

bin/% : src/%.cpp 
	mkdir -p bin
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

bin/interpreter : src/ast_parse.o src/ast_pretty_print.o src/ast_interpret.o

bin/compiler : src/ast_parse.o src/ast_pretty_print.o src/ast_compile.o

bin/pretty_print : src/ast_parse.o src/ast_pretty_print.o


clean :
	-rm bin/*
	-rm src/*.o
	-rm working/*/*.txt
