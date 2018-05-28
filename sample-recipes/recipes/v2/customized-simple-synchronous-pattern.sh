#!/bin/bash 

function get_test_cases {
    init ;
    local my_list=( testcase1 testcase2 testcase3 testcase4 )
    echo "${my_list[@]}"
    clear ;
}

function init {
    cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v2
    mashling-cli create -c "${RECIPE[$k]}".json
    if [[ "$OSTYPE" == "darwin"* ]] ;then
        mv mashling-custom/mashling-gateway-darwin-amd64 mashling-custom/mashling-gateway
    elif [[ "$OSTYPE" == "msys"* ]] ;then
        mv mashling-custom/mashling-gateway-windows-amd64.exe mashling-custom/mashling-gateway.exe
    elif [[ "$OSTYPE" == "linux-gnu"* ]] ;then
        mv mashling-custom/mashling-gateway-linux-amd64 mashling-custom/mashling-gateway
    fi  
}

function clear {
    rm -rf mashilng-custom
}

function testcase1 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v2/mashling-custom
./mashling-gateway -c ../customized-simple-synchronous-pattern.json > /tmp/rest1.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/2 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if ([ $response -eq 403 ] || [ $response -eq 200 ]) && [[ "echo $(cat /tmp/rest1.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}
function testcase2 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v2/mashling-custom
./mashling-gateway -c ../customized-simple-synchronous-pattern.json > /tmp/rest2.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/18 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if ([ $response -eq 403 ] || [ $response -eq 200 ]) && [[ "echo $(cat /tmp/rest2.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}

function testcase3 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v2/mashling-custom
./mashling-gateway -c ../customized-simple-synchronous-pattern.json > /tmp/rest3.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/13 --write-out '%{http_code}' --silent --output /dev/null)
curl --request GET http://localhost:9096/pets/13 > /tmp/test3.log
kill -9 $pId
if ([ $response -eq 404 ] || [ $response -eq 200 ]) && [[ "echo $(cat /tmp/rest3.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/test3.log)" =~ "petId is invalid" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}


function testcase4 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v2/mashling-custom
./mashling-gateway -c ../customized-simple-synchronous-pattern.json > /tmp/rest4.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/8 --write-out '%{http_code}' --silent --output /dev/null)
curl --request GET http://localhost:9096/pets/15 > /tmp/test4.log
kill -9 $pId
if ([ $response -eq 403 ] || [ $response -eq 200 ]) && [[ "echo $(cat /tmp/rest4.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}