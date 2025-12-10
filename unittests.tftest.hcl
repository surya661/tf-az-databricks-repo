mock_provider "azurerm" {}

variables {
  region              = "westus"
  resource_group_name = "test-rg"
  glb_no_public_ip    = true
}


run "check_region" {
  command = plan
  module {
    source = "./."
  }
  assert {
    condition     = module.azdatabricks-ws.region == "eastus"
    error_message = "the region is incorrect"
  }

}

run "do_not_allow_pip" {
  command = plan


  assert {
    condition     = can(regex("true", module.azdatabricks-ws.no_public_ip))
    error_message = "public ip is not allowed"
  }

}

run "validate_inputs" {
  command = plan
  assert {
    condition     = module.azdatabricks-ws.no_public_ip == var.glb_no_public_ip
    error_message = "no public ip is allowed"
  }

}
run "rg_name" {
  command = plan

  assert {
    condition     = module.azdatabricks-ws.rg-name == "devdb-rg"
    error_message = "the RG name is incorrect"
  }

}

run "tag_owner" {
  command = plan
  assert {
    condition     = module.azdatabricks-ws.tags["owner"] == "surya"
    error_message = " the owner name should be surya"
  }
}
