#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 testcase3 )
    echo "${my_list[@]}"
}
function testcase1 {
mashling-gateway -c examples/recipes/v2/simple-synchronous-pattern.json > /tmp/rest1.log 2>&1 & pId=$!
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
mashling-gateway -c examples/recipes/v2/simple-synchronous-pattern.json > /tmp/rest2.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/8 --write-out '%{http_code}' --silent --output /dev/null)
kill -9 $pId
if [ $response -eq 403  ] && [[ "echo $(cat /tmp/rest2.log)" =~ "Completed" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}

function testcase3 {
mashling-gateway -c examples/recipes/v2/simple-synchronous-pattern.json > /tmp/rest3.log 2>&1 & pId=$!
sleep 15
response=$(curl --request GET http://localhost:9096/pets/13 --write-out '%{http_code}' --silent --output /dev/null)
curl --request GET http://localhost:9096/pets/13 > /tmp/test3.log
kill -9 $pId
if [ $response -eq 404  ] && [[ "echo $(cat /tmp/rest3.log)" =~ "Completed" ]] && [[ "echo $(cat /tmp/test3.log)" =~ "petId is invalid" ]]
    then 
        echo "PASS"
    else
        echo "FAIL"
fi
}

