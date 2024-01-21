#include "ast.hpp"

#include <fstream>

int main(int argc, char *argv[])
{
    if(argc < 2){
        fprintf(stderr, "usage : compiler sourceCode\n");
        exit(1);
    }
    
    std::ifstream src(argv[1]);
    if(!src.is_open()){
        fprintf(stderr, "Couldn't open '%s'\n", argv[1]);
        exit(1);
    }
    
    TreePtr tree=Parse(src);
    
    Compile(tree);
    
    return 0;
}
