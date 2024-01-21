#include "ast.hpp"

#include <cstdlib>
#include <fstream>

int main(int argc, char *argv[])
{
    if(argc<2){
        fprintf(stderr, "Usage : interpreter sourceCode [ arg0 [ arg1 [ ... ] ] ]\n");
        fprintf(stderr, "Missing sourceCode.\n");
        exit(1);
    }
    
    std::ifstream code(argv[1]);
    
    InterpretContext context;
    for(int i=2; i<argc; i++){
        context.params.push_back(atol(argv[i]));
    }
    
    TreePtr src=Parse(code);
    PrettyPrint(std::cerr, src);
    
    return Interpret(context, src);
}
