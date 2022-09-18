variable "AWS_REGION" {
	default = "eu-central-1"
}

# If you are using diffrent region (other than eu-central-1) please find ubuntu 18.04 ami for that region and change here.
variable "ami_id" {
    type = string
    default = "ami-0f64f746a3cb9a16e"
}

variable "availability_zones" {
  type    = string
  default = "eu-central-1a"
}
variable "key_name" {
  type    = string
  default = "NeuReality"
}