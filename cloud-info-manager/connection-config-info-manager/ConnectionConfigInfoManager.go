// Cloud ConnectionConfig Info. Manager of CB-Spider.
// The CB-Spider is a sub-Framework of the Cloud-Barista Multi-Cloud Project.
// The CB-Spider Mission is to connect all the clouds with a single interface.
//
//      * Cloud-Barista: https://github.com/cloud-barista
//
// by powerkim@etri.re.kr, 2019.09.

package connectionconfiginfomanager

import (
	"fmt"

	"github.com/sirupsen/logrus"
	"github.com/cloud-barista/cb-store/config"
)

var cblog *logrus.Logger

func init() {
        cblog = config.Cblogger
}

//====================================================================
type ConnectionConfigInfo struct {
	ConfigName	string	// ex) "config01"
	ProviderName	string	// ex) "AWS"
	DriverName	string	// ex) "AWS-Test-Driver-V0.5"
	CredentialName	string	// ex) "credential01"
	RegionName	string	// ex) "region01"
}
//====================================================================


// 1. check params
// 2. check driver files
// 3. insert them into cb-store
// You should copy the driver library into ~/libs before.
func CreateConnectionConfig(configName string, providerName string, driverName string, credentialName string, regionName string) (*ConnectionConfigInfo, error) {
	cblog.Info("call CreateConnectionConfig()")

	cblog.Debug("check params")
	err := checkParams(configName, providerName, driverName, credentialName, regionName)
	if err != nil {
		return nil, err
	
	}

	cblog.Debug("insert metainfo into store")

	err = insertInfo(configName, providerName, driverName, credentialName, regionName)
	if err != nil {
		cblog.Error(err)
		return nil, err
	}

	cncInfo := &ConnectionConfigInfo{configName, providerName, driverName, credentialName, regionName}
	return cncInfo, nil
}

func ListConnectionConfig() ([]*ConnectionConfigInfo, error) {
	cblog.Info("call ListConnectionConfig()")

        configInfoList, err := listInfo()
        if err != nil {
                return nil, err
        }

        return configInfoList, nil
}

// 1. check params
// 2. get DriverInfo from cb-store
func GetConnectionConfig(configName string) (*ConnectionConfigInfo, error) {
	cblog.Info("call GetConnectionConfig()")

	if configName == "" {
                return nil, fmt.Errorf("configName is empty!")
        }
	
	cncInfo, err := getInfo(configName)
	if err != nil {
                cblog.Error(err)
                return nil, err
        }

	return cncInfo, err
}

func DeleteConnectionConfig(configName string) (bool, error) {
	cblog.Info("call DeleteConnectionConfig()")

        if configName == "" {
                return false, fmt.Errorf("configName is empty!")
        }

        result, err := deleteInfo(configName)
        if err != nil {
                cblog.Error(err)
                return false, err
        }

        return result, nil
}

//----------------

func checkParams(configName string, providerName string, driverName string, credentialName string, regionName string) error {
        if configName == "" {
                return fmt.Errorf("configName is empty!")
        }
        if providerName == "" {
                return fmt.Errorf("providerName is empty!")
        }
        if driverName == "" {
                return fmt.Errorf("driverName is empty!")
        }
        if credentialName == "" {
                return fmt.Errorf("credentialName is empty!")
        }
        if regionName == "" {
                return fmt.Errorf("regionName is empty!")
        }
	return nil
}

