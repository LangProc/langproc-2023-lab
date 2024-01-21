#include "ast.hpp"

void PrettyPrint(
    std::ostream &dst,
    TreePtr node,
    std::string indent
){
    dst << indent << node->type;
    
    if( node->value.size()>0 ){
        dst<<" : " <<node->value;
    }
    
    if(node->branches.size()>0){
        dst << " [" <<std::endl;
        for(unsigned i=0; i<node->branches.size(); i++){
            PrettyPrint(dst, node->branches[i], indent+"  ");
        }
        dst << indent << "]";
    }
    dst<<std::endl;
}
