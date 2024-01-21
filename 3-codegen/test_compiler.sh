#!/bin/bash

mkdir -p working

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
echo " Force building vm (just in case)"
make -B bin/vm
if [[ "$?" -ne "0" ]]; then
    echo "Error while building vm."
    exit 1;
fi

echo "========================================"
echo " Force building compiler"
make -B bin/compiler
if [[ "$?" -ne "0" ]]; then
    echo "Error while building compiler."
    exit 1;
fi

echo "========================================="

PASSED=0
CHECKED=0

for i in test/programs/*; do
    b=$(basename ${i});
    mkdir -p working/$b

    PARAMS=$(head -n 1 $i/in.params.txt | ${DOS2UNIX} );

    echo "==========================="
    echo ""
    echo "Input file : ${i}"
    echo "Testing $b"
    echo "  params : ${PARAMS}"

    bin/compiler $i/in.code.txt \
        > working/$b/compiled.txt

    bin/vm working/$b/compiled.txt ${PARAMS}  \
      < $i/in.input.txt \
      > working/$b/compiled.output.txt \
      2> working/$b/compiled.stderr.txt

    GOT_RESULT=$?;

    echo "${GOT_RESULT}" > working/$b/compiled.result.txt

    OK=0;

    REF_RESULT=$(head -n 1 $i/ref.result.txt | ${DOS2UNIX} );

    if [[ "${GOT_RESULT}" -ne "${REF_RESULT}" ]]; then
        echo "  got result : ${GOT_RESULT}"
        echo "  ref result : ${REF_RESULT}"
        echo "  FAIL!";
        OK=1;
    fi

    GOT_OUTPUT=$(echo $(cat working/$b/compiled.output.txt | ${DOS2UNIX} ))
    REF_OUTPUT=$(echo $(cat $i/ref.output.txt | ${DOS2UNIX} ))

    if [[ "${GOT_OUTPUT}" != "${REF_OUTPUT}" ]]; then
        echo "  got output : ${GOT_OUTPUT}"
        echo "  ref output : ${REF_OUTPUT}"
        echo "  FAIL!";
        OK=1;
    fi

    if [[ "$OK" -eq "0" ]]; then
        PASSED=$(( ${PASSED}+1 ));
    fi

    CHECKED=$(( ${CHECKED}+1 ));

    echo ""
done

echo "########################################"
echo "Passed ${PASSED} out of ${CHECKED}".
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
