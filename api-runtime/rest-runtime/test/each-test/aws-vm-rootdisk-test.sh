
echo "####################################################################"
echo "## VM RootDisk Type and Resize Test Scripts for CB-Spider - 2022.02.11."
echo "####################################################################"

#### RootDiskType / RootDiskSize
#### "" / ""
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
	'{
		"ConnectionName": "'${CONN_CONFIG}'", 
		"ReqInfo": { 
			"Name": "vm-01", 
			"ImageName": "'${IMAGE_NAME}'", 
			"VPCName": "vpc-01", 
			"SubnetName": "subnet-01", 
			"SecurityGroupNames": [ "sg-01" ], 
			"VMSpecName": "'${SPEC_NAME}'", 
			"KeyPairName": "keypair-01"
		} 
	}' |json_pp

#### RootDiskType / RootDiskSize
#### default / default
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": {
                        "Name": "vm-01-default-default",
                        "ImageName": "'${IMAGE_NAME}'",
                        "VPCName": "vpc-01",
                        "SubnetName": "subnet-01",
                        "SecurityGroupNames": [ "sg-01" ],
                        "VMSpecName": "'${SPEC_NAME}'",
                        "KeyPairName": "keypair-01",
			"RootDiskType": "default",
			"RootDiskSize": "default"
                }
        }' |json_pp

#### RootDiskType / RootDiskSize
#### standard / ""
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": { 
			"Name": "vm-01-standard-default",
			"ImageName": "'${IMAGE_NAME}'",
			"VPCName": "vpc-01",
			"SubnetName": "subnet-01",
			"SecurityGroupNames": [ "sg-01" ],
			"VMSpecName": "'${SPEC_NAME}'",
			"RootDiskType": "standard",
			"KeyPairName": "keypair-01"
		}
        }' |json_pp

#### RootDiskType / RootDiskSize
#### default / 7
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": {
                        "Name": "vm-01-default-7GB",
                        "ImageName": "'${IMAGE_NAME}'",
                        "VPCName": "vpc-01",
                        "SubnetName": "subnet-01",
                        "SecurityGroupNames": [ "sg-01" ],
                        "VMSpecName": "'${SPEC_NAME}'",
                        "RootDiskType": "default",
                        "RootDiskSize": "7",
                        "KeyPairName": "keypair-01"
                }
        }' |json_pp

#### RootDiskType / RootDiskSize
#### default / 12
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": {
                        "Name": "vm-01-default-12GB",
                        "ImageName": "'${IMAGE_NAME}'",
                        "VPCName": "vpc-01",
                        "SubnetName": "subnet-01",
                        "SecurityGroupNames": [ "sg-01" ],
                        "VMSpecName": "'${SPEC_NAME}'",
                        "RootDiskType": "default",
                        "RootDiskSize": "12",
                        "KeyPairName": "keypair-01"
                }
        }' |json_pp


#### RootDiskType / RootDiskSize
#### TYPE1 / default
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": {
                        "Name": "vm-01-type1-default",
                        "ImageName": "'${IMAGE_NAME}'",
                        "VPCName": "vpc-01",
                        "SubnetName": "subnet-01",
                        "SecurityGroupNames": [ "sg-01" ],
                        "VMSpecName": "'${SPEC_NAME}'",
                        "KeyPairName": "keypair-01",
                        "RootDiskType": "TYPE1",
                        "RootDiskSize": "default"
                }
        }' |json_pp


#### RootDiskType / RootDiskSize
#### gp3 / 24
curl -sX POST http://localhost:1024/spider/vm -H 'Content-Type: application/json' -d \
        '{
                "ConnectionName": "'${CONN_CONFIG}'",
                "ReqInfo": {
                        "Name": "vm-01-gp3-24GB",
                        "ImageName": "'${IMAGE_NAME}'",
                        "VPCName": "vpc-01",
                        "SubnetName": "subnet-01",
                        "SecurityGroupNames": [ "sg-01" ],
                        "VMSpecName": "'${SPEC_NAME}'",
                        "KeyPairName": "keypair-01",
                        "RootDiskType": "gp3",
                        "RootDiskSize": "24"
                }
        }' |json_pp

