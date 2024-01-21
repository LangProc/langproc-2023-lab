#include "histogram.hpp"

#include <vector>
#include <unordered_map>
#include <algorithm>
#include <cassert>
#include <iostream>
#include <iomanip>

// Use a hash-table to maintain a word -> count mapping.
// This deliberately uses std::unordered_map rather than std::map,
// because we don't need to enumerate the entries in key order.
// This allows us to use a hash-table, so we get O(1) operations
// rather than O(log n).
typedef std::unordered_map<std::string,unsigned> histogram_type;


// Define the instance of the variable that is declared in the histogram.hpp header
TokenValue yylval;

int main()
{
    histogram_type histogram; // Create the hash-table instance
    double sum=0; // Our running sum

    while(1){
        TokenType type=(TokenType)yylex();

        if(type==None){
            break; // No more tokens

        }else if(type==Number){
            // We have a number. The value will be
            // in yylval.numberValue

            // TODO: add to sum
            
        }else if(type==Word){
            // We have a string. The value is in a string
            // _pointed to_ by yylval.wordValue. Note that
            // the string is allocated by the lexer, but
            // deallocated by us.

            // TODO: add yylval.wordValue to histogram

            // TODO: Free the pointer yylval.wordValue to stop leaks
        }else{
            assert(0); // There are only three token types.
            return 1;
        }
    }


    // TODO: print out `sum` to std::cout with three decimal digits
    

    // Build a vector of (word,count) entries based on the hash-table
    std::vector<std::pair<std::string,unsigned> > sorted(histogram.begin(), histogram.end());

    // Create a custom sort order which orders by count first, then by string
    auto sort_order=[](const std::pair<std::string,unsigned> &a, const std::pair<std::string,unsigned> &b){
        if(a.second > b.second)
            return true;
        if(a.second < b.second)
            return false;
        return a.first < b.first;
    };

    // Sort the array using our custom sort order
    std::sort(sorted.begin(), sorted.end(), sort_order);

    auto it=sorted.begin();
    while(it!=sorted.end()){
        std::string name=it->first;
        unsigned count=it->second;
        // TODO: Print out `name` and `count` to std::cout
        
        
        ++it;
    }

    return 0;
}
