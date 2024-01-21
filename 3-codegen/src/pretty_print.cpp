#include "ast.hpp"

#include <cstdlib>

int main(int argc, char *argv[])
{
    TreePtr src=Parse(std::cin);
    
    PrettyPrint(std::cout, src);
    
    return 0;
}
