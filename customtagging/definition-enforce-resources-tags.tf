resource "azurerm_policy_definition" "enforce_resource_group_tags" {
    name         = "Require Mandatory Tags on Resources "
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "Indexed"
    display_name = "Require Mandatory Tags on Resources "

    lifecycle {
        ignore_changes = [
            metadata
        ]
    }

    metadata = <<METADATA
    {
        "category": "Tags",
        "createdBy": "",
        "createdOn": "",
        "updatedBy": "",
        "updatedOn": ""    
    }
    METADATA

    parameters = <<PARAMETERS
    {
        "Project": {
          "type": "String",
          "metadata": {
            "displayName": "Project",
            "description": "Project Name the resources belongs to. "
          }
        },
        "ASKID": {
          "type": "String",
          "metadata": {
            "displayName": "ASKID",
            "description": "ASK ID tied to the project for reporting and analytics. "
          }
        },
        "Environment": {
          "type": "String",
          "metadata": {
            "displayName": "Environment",
            "description": "Provides information on which Environment the resource group is used for. Example: NonProd, Production"
          }
        },
        "Owner": {
          "type": "String",
          "metadata": {
            "displayName": "Owner",
            "description": "The Business app owner to contact."
          }
        },
        "Terraform": {
          "type": "String",
          "metadata": {
            "displayName": "Terraform",
            "description": "Indicate if the resource group is spun up through Terraform scripts. Example: True/False"
          }
        }
      }
    PARAMETERS

    policy_rule = <<POLICY_RULE
    {
        "if": {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Resources/subscriptions/resource"
            },
            {
              "anyOf": [
                {
                  "field": "[concat('tags[', parameters('Project'), ']')]",
                  "exists": false
                },
                {
                  "field": "[concat('tags[', parameters('Project'), ']')]",
                  "equals": ""
                },
                {
                  "field": "[concat('tags[', parameters('ASKID'), ']')]",
                  "exists": false
                },
                {
                  "field": "[concat('tags[', parameters('ASKID'), ']')]",
                  "equals": ""
                },
                {
                  "field": "[concat('tags[', parameters('Environment'), ']')]",
                  "exists": false
                },
                {
                  "field": "[concat('tags[', parameters('Environment'), ']')]",
                  "equals": ""
                },
                {
                  "field": "[concat('tags[', parameters('Owner'), ']')]",
                  "exists": false
                },
                {
                  "field": "[concat('tags[', parameters('Owner'), ']')]",
                  "equals": ""
                },
                {
                  "field": "[concat('tags[', parameters('Terraform'), ']')]",
                  "exists": false
                },
                {
                  "field": "[concat('tags[', parameters('Terraform'), ']')]",
                  "equals": ""
                }
              ]
            }
          ]
        },
        "then": {
          "effect": "deny"
        }
      }
    POLICY_RULE
}