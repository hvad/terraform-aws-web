# Terraform plan to deploy AWS instance and DNS


## Route 53 

Write route 53 configuration like below in 53.tf file :

```
resource "aws_route53_zone" "primary" {
  name ="${var.aws_web_site_name}." 
  force_destroy = false
}
```

Import id zone :

```
$ terraform import aws_route53_zone.primary <zone_id> 
```


### How to delete any resource added by terraform

List all state :
```
$ terraform state list 
```

Remove desired resource from state :
```
$ terraform state rm <name>
```
