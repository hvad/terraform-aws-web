variable "aws_region" {
description = "AWS region"
default = "eu-west-3"
}

variable "own_ssh_key" {
  description = "SSH Public key."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClnHjuM7VbOPCXg2XMudpvRqYKjEpj1FoyiYARPejF86Y4pEULU8DhGkqdK4SpzH8yDSxuKG5sy/kOyS4cV3kHQP6kRpywCdTn0Z2cOdun4kHeMS/BtdL+Qd/xgbhsKVVDtA4e10oqzLmAYDvqh3O/p4kR1nwad2U1txbYNkFhY8OmEyoZNBAo3KDKLrB5aBEPyA9BnfQFUXl69olrp3ypdTMTF9w6ZhbLWRcSJFJM3S3Wyb/FSnCJMjBJXzrMB2L3+C9v99a+qjRV+ZM2ITPclB7iz4hsowFUPL62h5Sb4/wjkgKXCnGoo/RyuXebYMqimLAgLHLlifpTkpnJ23dHc7kaxf2PQtCAykUQyMkBnzEELzecRQvEmdeyPoxzh5lxonPX3JODEtMMyDl8JlrnOj5HcH0PDDPjbGNDlukKuPAoLODDSCrw5YzAbixsJSqof3elhyIzea/ymqmCatIuHOccWfqFWtlZzYpzyv/LwCsvKHHegyMaw8KepHAVpeE= davidhannequin@MacBook-Pro-de-david.local"
}

variable "security_group_name" {
  description = "The name of my security group"
  type        = string
  default     = "terraform-my-aws"
}
