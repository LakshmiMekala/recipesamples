#!/bin/bash 

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}
function testcase1 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
mashling-gateway -c examples/recipes/v2/simple-asynchronous-pattern.json > /tmp/test1.log 2>&1 & pId=$!
sleep 15
mosquitto_sub -t "put" > /tmp/test.log & pId1=$!
mosquitto_pub -m "{\"pathParams\":{\"petId\":\"10\"},\"replyTo\":\"put\"}" -t "get"
sleep 5
#killing process
kill -9 $pId
kill -9 $pId1
if [[ "echo $(cat /tmp/test.log)" =~ "10" ]] && [[ "echo $(cat /tmp/test1.log)" =~ "Completed" ]]
        then 
            echo "PASS"
            
        else
            echo "FAIL"
            
    fi
	rm -f /tmp/test1.log	
}



function testcase2 {
cd $GOPATH/src/github.com/TIBCOSoftware/mashling
mashling-gateway -c examples/recipes/v2/simple-asynchronous-pattern.json > /tmp/rest2.log 2>&1 & pId=$!
sleep 15
mosquitto_sub -t "put" > /tmp/test.log & pId1=$!
mosquitto_pub -m "{\"pathParams\":{\"petId\":\"1\"},\"replyTo\":\"put\"}" -t "get"
sleep 5
#killing process
kill -9 $pId
kill -9 $pId1
if [[ "echo $(cat /tmp/test.log)" =~ "1" ]] && [[ "echo $(cat /tmp/test1.log)" =~ "Completed" ]]
        then 
            echo "FAIL"
            
        else
            echo "PASS"
            
    fi
	rm -f /tmp/test1.log
}

