variable "env" {
    default = "day"
    type = string
}

variable "region" {
    default = "us-east-1"
    type = string
}

variable "instance_count" {
    default = 1
    type = number
}
variable "monitoring" {
    default = true
    type = bool
}

variable "associate_public_ip" {
    default = true
    type = bool
}

