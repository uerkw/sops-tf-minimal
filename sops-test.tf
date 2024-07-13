terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

data "sops_file" "demo-secret" {
  source_file = "app-secrets/demo-secrets.enc.json"
}



output "hello" {
  # Access a variable from the map
  sensitive = true
  value = data.sops_file.demo-secret.data["hello"]
}

output "example-nested-value-1" {
  sensitive = true
  # Access a variable that is nested  via the terraform map of data
  value = data.sops_file.demo-secret.data["example_nested.example_key1"]
}

# output "example-nested-value-2" {
#   sensitive = true
#   # Access a variable that is nested  via the terraform map of data
#   value = data.sops_file.demo-secret.data["example_nested.example_key2"]
# }


output "nested-json-value-example-2" { 
  sensitive = true
  # Access a variable via the terraform object
  value = jsondecode(data.sops_file.demo-secret.raw).example_nested.example_key2
}

output "example-array-value-0" {
  sensitive = true
  value = jsondecode(data.sops_file.demo-secret.raw).example_array[0]
}

output "example-boolean" {
  sensitive = true
  value = jsondecode(data.sops_file.demo-secret.raw).example_booleans[0]
}