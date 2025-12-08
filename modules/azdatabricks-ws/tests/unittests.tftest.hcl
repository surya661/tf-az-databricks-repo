/*run "setup_tests" {
    module {
        source = "./tests"
    }
}*/
mock_provider "azurerm" {}
variables {
  region = "westus"
  resource_group_name = "test-rg"
}


run "rg-name"{
    command = plan
    module  {
      source = "./tests"
    }
    assert {
        condition = module.azdatabricks-ws.rg_name == "test-rg"
        error_message = "the rg name is incorrect"
    }

}
