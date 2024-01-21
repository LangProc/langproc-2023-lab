#!/bin/bash

# Try to find a portable way of getting rid of
# any stray carriage returns
if which dos2unix ; then
    DOS2UNIX="dos2unix"
elif which fromdos ; then
    DOS2UNIX="fromdos"
else
    >&2 echo "warning: dos2unix is not installed."
    # This should work on Linux and MacOS, it matches all the carriage returns with sed and removes
    # them.  `tr` is used instead of `sed` because some versions of `sed` don't recognize the
    # carriage return symbol.  Something similar could be implemented with `sed` if necessary or
    # worst case it could be disabled by substituting it with `cat`.  One other thing to note is
    # that there are no quotes around the \r, which is so that it gets converted by bash.
    DOS2UNIX="tr -d \r"
    # DOS2UNIX="sed -e s/\r//g"
    # DOS2UNIX="cat"
fi

echo "========================================"
echo " Cleaning the temporaries and outputs"
make clean
echo " Force building bin/print_canonical"
make bin/print_canonical bin/eval_expr -B
if [[ "$?" -ne 0 ]]; then
    echo "Build failed.";
fi
echo ""

echo "========================================="
echo "Checking that good expressions are parsed"

PASSED=0
CHECKED=0

if [[ -f test/valid_expressions.got.txt ]]; then
    rm test/valid_expressions.got.txt
fi
while IFS=, read -r INPUT_LINE REF_LINE BINDINGS REF_VALUE; do
    echo "==========================="
    echo ""
    echo "Input : ${INPUT_LINE}"
    GOT_LINE=$( echo -n "${INPUT_LINE}" | bin/print_canonical )
    echo "Output : ${GOT_LINE}"
    if [[ "${GOT_LINE}" != "${REF_LINE}" ]]; then
        echo ""
        echo "ERROR"
    else
        PASSED=$(( ${PASSED}+1 ));
    fi
    CHECKED=$(( ${CHECKED}+1 ));

    echo ""
    echo "Evaluating with : $BINDINGS"
    GOT_VALUE=$( echo -n "${INPUT_LINE}" | bin/eval_expr ${BINDINGS} )
    echo "Value : ${GOT_VALUE}"
    if [[ "${GOT_VALUE}" != "${REF_VALUE}" ]]; then
        echo ""
        echo "ERROR"        
    else
        PASSED=$(( ${PASSED}+1 ));
    fi
    CHECKED=$(( ${CHECKED}+1 ));
    
    echo "${INPUT_LINE},${GOT_LINE},${BINDINGS},${GOT_VALUE}" >> test/valid_expressions.got.txt

done < <( cat test/valid_expressions.input.txt | ${DOS2UNIX})

echo ""
echo "============================================"
echo "Checking that bad expressions are not parsed"
echo ""

while IFS=, read -r INPUT_LINE; do
    # Strip carriage return if necessary (replace dos2unix)
    INPUT_LINE=$(echo "${INPUT_LINE}")
    echo "==========================="
    echo ""
    echo "Input : ${INPUT_LINE}"
    GOT_LINE=$( echo -n "${INPUT_LINE}" | bin/print_canonical )
    CODE=$?;
    echo "Output : ${GOT_LINE}"
    if [[ ${CODE} -eq "0" ]]; then
        echo ""
        echo "ERROR"
        PASSED=$(( ${PASSED}-1 ));        
    fi
done < <( cat test/invalid_expressions.input.txt | ${DOS2UNIX} )


echo "########################################"
echo "Passed ${PASSED} out of ${CHECKED} checks".
echo ""

RELEASE=$(lsb_release -d)
if [[ $? -ne 0 ]]; then
    echo ""
    echo "Warning: This appears not to be a Linux environment"
    echo "         Make sure you do a final run on a lab machine or an Ubuntu VM"
else
    grep -q "Ubuntu 22.04" <(echo $RELEASE)
    FOUND=$?

    if [[ $FOUND -ne 0 ]]; then
        echo ""
        echo "Warning: This appears not to be the target environment"
        echo "         Make sure you do a final run on a lab machine or an Ubuntu VM"
    fi
fi
