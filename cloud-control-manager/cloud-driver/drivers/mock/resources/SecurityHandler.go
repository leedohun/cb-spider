// Cloud Driver Interface of CB-Spider.
// The CB-Spider is a sub-Framework of the Cloud-Barista Multi-Cloud Project.
// The CB-Spider Mission is to connect all the clouds with a single interface.
//
//      * Cloud-Barista: https://github.com/cloud-barista
//
// This is Mock Driver.
//
// by CB-Spider Team, 2020.10.

package resources

import (
	"fmt"

	cblog "github.com/cloud-barista/cb-log"
	irs "github.com/cloud-barista/cb-spider/cloud-control-manager/cloud-driver/interfaces/resources"
)

var securityInfoMap map[string][]*irs.SecurityInfo

type MockSecurityHandler struct {
	MockName string
}

func init() {
	// cblog is a global variable.
	securityInfoMap = make(map[string][]*irs.SecurityInfo)
}

// (1) create securityInfo object
// (2) insert securityInfo into global Map
func (securityHandler *MockSecurityHandler) CreateSecurity(securityReqInfo irs.SecurityReqInfo) (irs.SecurityInfo, error) {
	cblogger := cblog.GetLogger("CB-SPIDER")
	cblogger.Info("Mock Driver: called CreateSecurity()!")

	mockName := securityHandler.MockName
	securityReqInfo.IId.SystemId = securityReqInfo.IId.NameId
	securityReqInfo.VpcIID.SystemId = securityReqInfo.VpcIID.NameId
	// (1) create securityInfo object
	securityInfo := irs.SecurityInfo{securityReqInfo.IId,
		securityReqInfo.VpcIID,
		// deprecated; securityReqInfo.Direction,
		securityReqInfo.SecurityRules,
		nil}

	// (2) insert SecurityInfo into global Map
	infoList, _ := securityInfoMap[mockName]
	infoList = append(infoList, &securityInfo)
	securityInfoMap[mockName] = infoList

	return CloneSecurityInfo(securityInfo), nil
}

func CloneSecurityInfoList(srcInfoList []*irs.SecurityInfo) []*irs.SecurityInfo {
	clonedInfoList := []*irs.SecurityInfo{}
	for _, srcInfo := range srcInfoList {
		clonedInfo := CloneSecurityInfo(*srcInfo)
		clonedInfoList = append(clonedInfoList, &clonedInfo)
	}
	return clonedInfoList
}

func CloneSecurityInfo(srcInfo irs.SecurityInfo) irs.SecurityInfo {
	/*
		type SecurityInfo struct {
			IId IID // {NameId, SystemId}
			VpcIID        IID    // {NameId, SystemId}
			Direction     string // @todo userd??
			SecurityRules *[]SecurityRuleInfo
			KeyValueList []KeyValue
		}
	*/

	// clone SecurityInfo
	clonedInfo := irs.SecurityInfo{
		IId:       irs.IID{srcInfo.IId.NameId, srcInfo.IId.SystemId},
		VpcIID:    irs.IID{srcInfo.VpcIID.NameId, srcInfo.VpcIID.SystemId},
		// deprecated; Direction: srcInfo.Direction,

		// Need not clone
		SecurityRules: srcInfo.SecurityRules,
		KeyValueList:  srcInfo.KeyValueList,
	}

	return clonedInfo
}

func (securityHandler *MockSecurityHandler) ListSecurity() ([]*irs.SecurityInfo, error) {
	cblogger := cblog.GetLogger("CB-SPIDER")
	cblogger.Info("Mock Driver: called ListSecurity()!")

	mockName := securityHandler.MockName
	infoList, ok := securityInfoMap[mockName]
	if !ok {
		return []*irs.SecurityInfo{}, nil
	}

	return CloneSecurityInfoList(infoList), nil
}

func (securityHandler *MockSecurityHandler) GetSecurity(iid irs.IID) (irs.SecurityInfo, error) {
	cblogger := cblog.GetLogger("CB-SPIDER")
	cblogger.Info("Mock Driver: called GetSecurity()!")

	infoList, err := securityHandler.ListSecurity()
	if err != nil {
		cblogger.Error(err)
		return irs.SecurityInfo{}, err
	}

	// infoList is already cloned in ListSecurity()
	for _, info := range infoList {
		if info.IId.NameId == iid.NameId {
			return *info, nil
		}
	}

	return irs.SecurityInfo{}, fmt.Errorf("%s SecurityGroup does not exist!!", iid.NameId)
}

func (securityHandler *MockSecurityHandler) DeleteSecurity(iid irs.IID) (bool, error) {
	cblogger := cblog.GetLogger("CB-SPIDER")
	cblogger.Info("Mock Driver: called DeleteSecurity()!")

	infoList, err := securityHandler.ListSecurity()
	if err != nil {
		cblogger.Error(err)
		return false, err
	}

	mockName := securityHandler.MockName
	for idx, info := range infoList {
		if info.IId.SystemId == iid.SystemId {
			infoList = append(infoList[:idx], infoList[idx+1:]...)
			securityInfoMap[mockName] = infoList
			return true, nil
		}
	}
	return false, nil
}


func (securityHandler *MockSecurityHandler) AddRules(sgIID irs.IID, securityRules *[]irs.SecurityRuleInfo) (irs.SecurityInfo, error) {
        cblogger := cblog.GetLogger("CB-SPIDER")
        cblogger.Info("Mock Driver: called AddRules()!")

        // info: cloned
        info, err := securityHandler.GetSecurity(sgIID)
        if err != nil {
                cblogger.Error(err)
                return irs.SecurityInfo{}, err
        }

	*info.SecurityRules = append(*info.SecurityRules, *securityRules...)

        return CloneSecurityInfo(info), nil
}

func (securityHandler *MockSecurityHandler) RemoveRules(sgIID irs.IID, securityRules *[]irs.SecurityRuleInfo) (bool, error) {
        cblogger := cblog.GetLogger("CB-SPIDER")
        cblogger.Info("Mock Driver: called RemoveRules()!")

        // info: cloned
        info, err := securityHandler.GetSecurity(sgIID)
        if err != nil {
                cblogger.Error(err)
		return false, err
        }
	for _, reqRuleInfo := range *securityRules {
		for idx, ruleInfo := range *info.SecurityRules {
			if isEqualRule(&ruleInfo, &reqRuleInfo) {
				*info.SecurityRules = removeRule(info.SecurityRules, idx)
			}
		}
	}

        return true, nil
}

func isEqualRule(a *irs.SecurityRuleInfo, b *irs.SecurityRuleInfo) bool {
	/*------------------------------
	type SecurityRuleInfo struct {
		Direction  string
		IPProtocol string
		FromPort   string
		ToPort     string
		CIDR       string
	}
	-------------------------------*/

	if a.Direction != b.Direction {
		return false
	}
	if a.IPProtocol != b.IPProtocol {
		return false
	}
	if a.FromPort != b.FromPort {
		return false
	}
	if a.ToPort != b.ToPort {
		return false
	}
	if a.CIDR != b.CIDR {
		return false
	}

	return true
}

func removeRule(list *[]irs.SecurityRuleInfo, idx int) []irs.SecurityRuleInfo {
	return append((*list)[:idx], (*list)[idx+1:]...)
}

