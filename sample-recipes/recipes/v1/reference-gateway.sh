#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {
mashling-gateway -c examples/recipes/v1/reference-gateway.json > /tmp/rest1.log 2>&1 &
pId=$!
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
