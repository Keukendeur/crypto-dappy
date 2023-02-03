import "DappyContract"

pub fun main(familyID: UInt32): [UInt32] {
  let templates = DappyContract.listFamilyTemplates(familyID: familyID)
  return templates
}

// flow scripts execute --network testnet Dappy/scripts/ListFamilyTemplates.cdc '1'