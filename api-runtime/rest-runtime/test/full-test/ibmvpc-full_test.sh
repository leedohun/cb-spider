echo "#### Full Test Process - Start ###"

sleep 1 

echo "####################################################################"
echo "## Full Test Scripts for CB-Spider IID Working Version - 2020.04.22."
echo "##   0. VM Image: List"
echo "##   0. VM Spec: List"
echo "##   1. VPC: Create -> List -> Get"
echo "##   2. SecurityGroup: Create -> List -> Get"
echo "##   3. KeyPair: Create -> List -> Get"
echo "##   4. VM: StartVM -> List -> Get -> ListStatus -> GetStatus -> Suspend -> Resume -> Reboot"
echo "## ---------------------------------"
echo "##   4. VM: Terminate(Delete)"
echo "##   3. KeyPair: Delete"
echo "##   2. SecurityGroup: Delete"
echo "##   1. VPC: Delete"
echo "####################################################################"

sleep 2 

echo "##   0. VM Image: List"
curl -sX GET http://localhost:1024/spider/vmimage -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5 

echo "##   0. VM Image: Get"
curl -sX GET http://localhost:1024/spider/vmimage/${IMAGE_NAME} -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5 

echo "##   0. VM Spec: List"
curl -sX GET http://localhost:1024/spider/vmspec -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5 

echo "##   0. VM Spec: Get"
curl -sX GET http://localhost:1024/spider/vmspec/${SPEC_NAME} -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp
echo "#-----------------------------"

sleep 5 

echo "####################################################################"
echo "## 1. VPC: Create -> List -> Get"
echo "####################################################################"
sleep 1 
echo "## 1. VPC: Create"
curl -sX POST http://localhost:1024/spider/vpc -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'", "ReqInfo": { "Name": "ibmvpc-vpc-01", "IPv4_CIDR": "10.240.0.0/16", "SubnetInfoList": [ { "Name": "ibmvpc-subnet-01", "IPv4_CIDR": "10.240.0.0/24"}, { "Name": "ibmvpc-subnet-02", "IPv4_CIDR": "10.240.1.0/24"} ] } }' |json_pp

sleep 5 
echo "## 1. VPC: List"
curl -sX GET http://localhost:1024/spider/vpc -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5 
echo "## 1. VPC: Get"
curl -sX GET http://localhost:1024/spider/vpc/ibmvpc-vpc-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp
echo "#-----------------------------"

echo "####################################################################"
echo "## 2. SecurityGroup: Create -> List -> Get"
echo "####################################################################"

sleep 1 
echo "## 2. SecurityGroup: Create"
curl -sX POST http://localhost:1024/spider/securitygroup -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'", "ReqInfo": { "Name": "ibmvpc-sg-01", "VPCName": "ibmvpc-vpc-01", "SecurityRules": [ {"FromPort": "22", "ToPort" : "22", "IPProtocol" : "tcp", "Direction" : "inbound"} ] } }' |json_pp

sleep 5 
echo "## 2. SecurityGroup: List"

curl -sX GET http://localhost:1024/spider/securitygroup -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5 
echo "## 2. SecurityGroup: Get"

curl -sX GET http://localhost:1024/spider/securitygroup/ibmvpc-sg-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp
echo "#-----------------------------"

echo "####################################################################"
echo "## 3. KeyPair: Create -> List -> Get"
echo "####################################################################"

sleep 1 
echo "## 3. KeyPair: Create"
curl -sX POST http://localhost:1024/spider/keypair -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'", "ReqInfo": { "Name": "ibmvpc-key-01" } }' |json_pp

sleep 5 
echo "## 3. KeyPair: List"
curl -sX GET http://localhost:1024/spider/keypair -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5
echo "## 3. KeyPair: Get"
curl -sX GET http://localhost:1024/spider/keypair/ibmvpc-key-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp
echo "#-----------------------------"

echo "####################################################################"
echo "## 4. VM: StartVM -> List -> Get -> ListStatus -> GetStatus -> Suspend -> Resume -> Reboot"
echo "####################################################################"

sleep 1
echo "## 4. VM: StartVM"
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'", "ReqInfo": { "Name": "ibmvpc-vm-01", "ImageName": "'${IMAGE_NAME}'", "VPCName": "ibmvpc-vpc-01", "SubnetName": "ibmvpc-subnet-01", "SecurityGroupNames": [ "ibmvpc-sg-01" ], "VMSpecName": "'${SPEC_NAME}'", "KeyPairName": "ibmvpc-key-01"} }' |json_pp

echo "============== sleep 50sec after start VM"
sleep 50 

echo "## 4. VM: List"
curl -sX GET http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 10sec after List VM"
sleep 10 
echo "## 4. VM: Get"
curl -sX GET http://localhost:1024/spider/vm/ibmvpc-vm-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 10sec after Get VM"
sleep 10 
echo "## 4. VM: ListStatus"
curl -sX GET http://localhost:1024/spider/vmstatus -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 2sec after List VM Status"
sleep 2 
echo "## 4. VM: GetStatus"
curl -sX GET http://localhost:1024/spider/vmstatus/ibmvpc-vm-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 10sec after Get VM Status"
sleep 10
echo "## 4. VM: Suspend"
curl -sX GET http://localhost:1024/spider/controlvm/ibmvpc-vm-01?action=suspend -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 30sec after suspend VM"
sleep 30 
echo "## 4. VM: Resume"
curl -sX GET http://localhost:1024/spider/controlvm/ibmvpc-vm-01?action=resume -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 10sec after resume VM"
sleep 10
echo "## 4. VM: Reboot"
curl -sX GET http://localhost:1024/spider/controlvm/ibmvpc-vm-01?action=reboot -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 70sec after reboot VM"
sleep 70 
echo "#-----------------------------"

echo "####################################################################"
echo "####################################################################"
echo "####################################################################"

echo "####################################################################"
echo "## 4. VM: Terminate(Delete) "
echo "####################################################################"
curl -sX DELETE http://localhost:1024/spider/vm/ibmvpc-vm-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "============== sleep 50sec after delete VM"
sleep 50


echo "####################################################################"
echo "## 3. KeyPair: Delete"
echo "####################################################################"
curl -sX DELETE http://localhost:1024/spider/keypair/ibmvpc-key-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5

echo "####################################################################"
echo "## 2. SecurityGroup: Delete"
echo "####################################################################"
curl -sX DELETE http://localhost:1024/spider/securitygroup/ibmvpc-sg-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

sleep 5

echo "####################################################################"
echo "## 1. VPC: Delete"
echo "####################################################################"
curl -sX DELETE http://localhost:1024/spider/vpc/ibmvpc-vpc-01 -H 'Content-Type: application/json' -d '{ "ConnectionName": "'${CONN_CONFIG}'"}' |json_pp

echo "#### Full Test Process - Finished ###"