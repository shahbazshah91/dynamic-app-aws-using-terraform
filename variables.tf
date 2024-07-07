#default global tags
variable "region" {
    type        = string
    description = "regions where resources will be created"
}

variable "project_name" {
    type        = string
    description = "name of the project"
}

variable "environment" {
    type        = string
    description = "environment of the project"
}