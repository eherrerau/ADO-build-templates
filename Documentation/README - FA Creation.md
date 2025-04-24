<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://miro.medium.com/v2/resize:fit:523/1*aOLvNQiCMaTg9803VcK0Ug.png" 
 alt="Function Apps"></a>
 <img width=200px height=200px src="https://pnghq.com/wp-content/uploads/terraform-logo-png-png-download-86079.png" 
 alt="Terraform"></a>
</p>

<h3 align="center">Function App with Terraform</h3>

<div align="center">


</div>

---

<p align="center"> The following document describes how to start using the templates with terraform to set up Azure Function Apps. 
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Usage](#usage)
- [Built Using](#built_using)
- [Contributing](../CONTRIBUTING.md)
- [Authors](#authors)

## 🧐 About <a name = "about"></a>

Instructions on how to set up a new project using Function  App and terraform, using a default infrastructure. The project consists in a default infrastructure which is meant to be work only behind our firewalls, in our network making the function app only available internally and not reach externally throughout the Internet.
At the end you can be able to build up to two environments, meaning development and Production using a single terraform on your pipeline.


## 🏁 Getting Started <a name = "getting_started"></a>

Once you have created a function app in Azure DevOps or locally on your machine, You Will create a terraform folder inside of your project where you're going to place a template which you're going to modify later on.
```
- /YourCodeFolder
- /terraform
```
Besides the folder you just created for the terraform you will be needing an extra file for creating a pipeline which it will be described later on a charter in this document. One pipeline is used to build a code in the other pipeline is used to build and validate the infrastructure with terraform. This way the bill get agile and we build whatever we need either code or infrastructure separately which makes the process faster.

```
- /azure-pipelines-infra.yaml
- /azure-pipelines.yaml
```



### Prerequisites

- That a function app is create locally already and have a repo in Azure DevOps. 
- Access to Azure DevOps to create a pipeline.
- Access to the [Infra.Terraform.Templates](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates)


### Installing

1-Once you have your repo ready create a terraform folder in the root..
```
- /YourCodeFolder
- /terraform
```
2-Go to the [Infra.Terraform.Templates/Infra.Terraform.Templates](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates?path=/terraform_templates/function_apps) and look for a folder called "terraform_templates/function_apps" and copy the content from it into "/terraform" folder of your local repo.
It should look like this: 

```
/terraform/app_insights.tf
/terraform/app_service_plan.tf
/terraform/backend.tf
/terraform/database.tf
/terraform/... 
and so on with all files in it. 
```

3-Copy both pipelines files located in the [Infra.Terraform.Templates/terraform_templates/function_apps/pipeline](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates?path=/terraform_templates/function_apps/pipeline) in the root directory of your repo.

```
/azure-pipelines-infra.yaml  -Will be use for your Infrastructure pipeline, to create dev resources with terraform.

/azure-pipelines.yaml        -This is your regular pipeline to build the code of your Function  app.
```

Copy 
```
terraform_templates/function_apps/pipeline/azure-pipelines-infra.yaml
terraform_templates/function_apps/pipeline/azure-pipelines.yaml
```
into your repo in the root folder like this, keep the same name:
```
/azure-pipelines-infra.yaml
/azure-pipelines.yaml
```


Having all files copy, we can now proceed to modify the template as need it, with the parameters requeried, which I will explain further in the next section.

## 🔧 Configuring the pipelines <a name = "Pipeline configuration"></a>

### Configuring the code pipeline

The file has just a few parameters that you need to adjust in the top in order to use correctly by Azure DevOps.

```
### Place this template on your azure-pipelines.yaml files, then change the variables to fit every Function  App Project
variables:
  ### The highest .Net versions used by the projects in the repo ###
  coreVersion: '6.0'
  ### Application version, if new, insert 1.0 ###
  version: '1.0'
  targetFile: 'fhir.documentdownload.sln'

  ${{ if or(eq(variables['Build.SourceBranchName'], 'main'), startsWith(variables['Build.SourceBranchName'], 'hotfix-')) }}:
    version.prefix: ""
    isMasterBranch: true
  ${{ if and(ne(variables['Build.SourceBranchName'], 'main'), not(startsWith(variables['Build.SourceBranchName'], 'hotfix-'))) }}:
    version.prefix: "pr-"
    isMasterBranch: false
  ```

This is all you need to change and leave the rest as it is. The files reads from another template and run the build.

From here you will need to go to Azure DevOps, to the [pipelines section](https://dev.azure.com/CompanyName/ProjectName/_build)  in create a new build pipeline point into this file in your repo. Remember to commit the changes in the step before, so you can find the new pipeline file uploaded to the repo.

The version parameter will be used to set what will be the first number to be used as the build number. In this case starting from 1
```
version: '1.0'
```

The condition below, checks if the buils runs from the main branch, then the build name and number will remain intact, but if you are running from another branch, or you are merging it from another branch, then the name of the build will have a prefix added of "pr-" to diferenciated, and to avoid building artifacts, then in theory, should run faster, since we are just validating that the code has not broke anything before the merger.
```
${{ if or(eq(variables['Build.SourceBranchName'], 'main'), startsWith(variables['Build.SourceBranchName'], 'hotfix-')) }}:
    version.prefix: ""
    isMasterBranch: true
  ${{ if and(ne(variables['Build.SourceBranchName'], 'main'), not(startsWith(variables['Build.SourceBranchName'], 'hotfix-'))) }}:
    version.prefix: "pr-"
    isMasterBranch: false
```


### Configuring the Infra pipeline

Here you're going to repeat the same steps as before but we're going to select the other yaml pipeline, "azure-pipelines-infra.yaml".
These infrared pipeline is meant to create the infrastructure for the development environment only and not production. We will be building roduction using azure papeline releases, explain later on this document. 

On the "azure-pipelines-infra.yaml" will be changing only the variables as well, on top of the file, the rest, we will leave as it is:

On this example, I will break down each of the lines of the variables.

```
variables:
  workingDirectory: terraform   
  backendServiceArm: CompanyNameProduction
  backendAzureRmResourceGroupName: 'resourceGroupName'
  backendAzureRmStorageAccountName: 'StorageAccountName'
  backendAzureRmContainerName: 'fa-terraform-state'
  devbackendAzureRmKey: 'dev-fa-fhir-documentDownloading-website-terraform.tfstate'
  prodbackendAzureRmKey: 'prod-fa-fhir-documentDownloading-website-terraform.tfstate'
  ### Application version, if new, insert 1.0 ###
  version: '1.0'

  ${{ if or(eq(variables['Build.SourceBranchName'], 'main'), startsWith(variables['Build.SourceBranchName'], 'hotfix-')) }}:
    version.prefix: ""
    isMasterBranch: true
  ${{ if and(ne(variables['Build.SourceBranchName'], 'main'), not(startsWith(variables['Build.SourceBranchName'], 'hotfix-'))) }}:
    version.prefix: "pr-"
    isMasterBranch: false
```

workingDirectory: is the terraform you created in the early steps, where the terraform folder is in you repo. 
```
workingDirectory: terraform 
```

backendServiceArm: The name of the Service Connection from Azure DevOps to Azure. [Service Connections](https://dev.azure.com/CompanyName/ProjectName/_settings/adminservices?resourceId=70cc9a2e-9ba1-4fb0-90f4-ea267cfb691f)
```
backendServiceArm: CompanyNameProduction
```

backendAzureRmResourceGroupName: The name of the Resource group in Azure of the storage account that holds the terraform state file.
```
backendAzureRmResourceGroupName: 'resourceGroupName'
```

backendAzureRmStorageAccountName: The name of the storage account in Azure that holds the terraform state file.
```
backendAzureRmStorageAccountName: 'StorageAccountName'
```

backendAzureRmContainerName: The name of the container in the storeage for the terraform state file. This container will hold all files, from all environments for Functions Apps (Fa).
```
backendAzureRmContainerName: 'fa-terraform-state'
```

devbackendAzureRmKey: The name of the terraform state file. 
This changes depending on the environment use. 
```
devbackendAzureRmKey: 'dev-fa-fhir-documentDownloading-website-terraform.tfstate'
```

The version parameter will be used to set what will be the first humber to be used as the build number. In this case starting from 1
```
version: '1.0'
```
The condition below, checks if the buils runs from the main branch, then the build name and number will remain intact, but if you are running from another branch, or you are merging it from another branch, then the name of the build will have a prefix added of "pr-" to diferenciated, and to avoid building artifacts, then in theory, should run faster, since we are just validating that the code has not broke anything before the merge.
```
${{ if or(eq(variables['Build.SourceBranchName'], 'main'), startsWith(variables['Build.SourceBranchName'], 'hotfix-')) }}:
    version.prefix: ""
    isMasterBranch: true
  ${{ if and(ne(variables['Build.SourceBranchName'], 'main'), not(startsWith(variables['Build.SourceBranchName'], 'hotfix-'))) }}:
    version.prefix: "pr-"
    isMasterBranch: false
```

## 🎈 Usage <a name="usage"></a>

The pipeline should trigger automatically.
The infrastructure pipeline should trigger only when it detects changes inside of the Terraform folder.
Same thing happens with the pipeline code which will be triggered only if the code for the function apps its modify.
Remember that the infrared pipeline will only deploy development environment.

## 🚀 Deployment <a name = "deployment"></a>

The following instructions will let you know how to change the parameters inside of the terraform code in order to get different environments deployed.

In order to create environments we use a file for setting up different variables and across the environment.
We use ".tfvars" files to create different environments, dev, uat, prod, depending on the needs, and so we can set different environemnt variables for each file. 
Here is the explanation of the content of the 

### dev.tfvars file
Here you can see the file and all its variables, so you can change it upon the environment you are creating.
[dev.tfvars](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates?path=/terraform_templates/function_apps/dev.tfvars)

So if you want to create an environment for UAT, or PROD, then add another files in the same directory with a differen name on it as follows:

```
uat.tfvars
prod.tfvars
```

Then change the variables inside to create resources in the resources groups for your desire environment. 
Inside of the [dev.tfvars](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates?path=/terraform_templates/function_apps/dev.tfvars) you will find the file is very well documented accross all sections, describing what variables belong to what, as an example, you can here the .tfvars:

```
## Default Storage
fa_storage_name                     = "de2oastoblb06"
fa_resource_group_name              = "de2-de-rg-sto"
fa_storage_account_tier             = "Standard"
fa_storage_account_replication_type = "LRS"
fa_queue_name                       = [""] ### Queues
fa_storage_account_container_name   = [""] ### Containers

## DFS Storage Account 
dls_storage_name                     = "de2oastodls06"
dls_resource_group_name              = "de2-de-rg-sto"
dls_storage_account_tier             = "Standard"
dls_storage_account_replication_type = "LRS"
dls_queue_name                       = [""] ### Queues
dls_storage_account_container_name   = [""] ### Containers

## Keyvault
keyvault_name = "de2oaopskvt01"
keyvault_rg   = "de2-de-rg-msc"
secret_name_blob_sto_conn = "" ## The name of the secret that will be store in the keyvault for blob.
secret_name_dls_sto_conn  = "" ## The name of the secret that will be store in the keyvault for DLS.

## MSSQL Server
sql_server_name    = "devuse2odssql01"
sql_server_rg_name = "de2-de-rg-dbs"
```

Here is another example of documentation on the file, that will help you to locate variables to add, edit, to removed acording to your need in the repo. This is the [variables.tf](https://dev.azure.com/CompanyName/ProjectName/_git/Infra.Terraform.Templates?path=/terraform_templates/function_apps/variables.tf)
Here is a segment of that file:
```
### Generic ###
variable "location" {
  type        = string
  default     = "eastus2"
  description = "Region in where resources will be created"
}

### Log analytics workspace ### 
variable "log_analitics_name" {
  type        = string
  description = "The name of the Log Analytics Workspace in Azure"
}

variable "log_analitics_rg" {
  type        = string
  description = "The name of the Resource Group where Log Analytics Workspace is in Azure"
}

### Funtion App Service Plan ###
variable "app_service_rg" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}
```

## ⏬ Built Release Pipeline <a name = "built_release"></a>

The best you can do is to use one of the existing release pipelines then clone it, by export it and import it back into the release wth a new name. The following is an example that you can use as a template then you can change settings in variables to fit your need.

https://dev.azure.com/CompanyName/ProjectName/_release?definitionId=41&view=mine&_a=releases


## ⛏️ Built Using <a name = "built_using"></a>

- [Azure Pipelines](https://learn.microsoft.com/en-us/azure/DevOps/pipelines/yaml-schema/?view=azure-pipelines) - Azure Pipeline Schema
- [Terraform](https://www.terraform.io//) - Infrastructure automation

## ✍️ Authors <a name = "authors"></a>

- [userEmail@CompanyName.com](mailto:userEmail@CompanyName.com) - Creator of the templates & pipelines.
