#!/bin/bash 

function get_test_cases {
init ;
local my_list=( testcase2 testcase1 )
echo "${my_list[@]}"
clear ;
}

function init {
    cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v1
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
ls -ll
}

function testcase1 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v1/mashling-custom
./mashling-gateway -c ../customized-rest-conditional-gateway.json > /tmp/rest1.log 2>&1 &
pId=$!
sleep 15
./mashling-gateway -c ../customized-rest-conditional-gateway.json
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
cd $GOPATH/src/github.com/TIBCOSoftware/mashling/examples/recipes/v1/mashling-custom
./mashling-gateway -c ../customized-rest-conditional-gateway.json > /tmp/rest2.log 2>&1 &
pId=$!
sleep 15
response=$(curl -X PUT "http://localhost:9096/pets" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category":{"id":2,"name":"Animals"},"id":2,"name":"SPARROW","photoUrls":["string"],"status":"sold","tags":[{"id":0,"name":"string"}]}' --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if ([ $response -eq 403 ] || [ $response -eq 200 ]) && [[ "echo $(cat /tmp/rest2.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}