#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}
function testcase1 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
mashling-gateway -c examples/recipes/v1/rest-conditional-gateway.json > /tmp/rest1.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/2 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 200  ] && [[ "echo $(cat /tmp/rest1.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}
function testcase2 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
mashling-gateway -c examples/recipes/v1/rest-conditional-gateway.json > /tmp/rest2.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/375 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 404  ] && [[ "echo $(cat /tmp/rest2.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}