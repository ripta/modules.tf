# modules.tf

A collection of [Terraform Modules](https://www.terraform.io/docs/modules/sources.html). Modules can be imported by pointing to the source URL on github:

```terraform
module "vpc" {
  source = "github.com/ripta/modules.tf//aws/vpc/natted"
}
```

Pay attention to the double-slash in the source URL, which act as a separator of the module location inside the repository. Check out the `inputs.tf` and `outputs.tf` inside each module for documentation on the variables imported into and exported from the module. These modules are available:

* AWS VPC:
  * `aws/vpc/bare`: most basic but flexible setup of an empty VPC.
  * `aws/vpc/public-only`: single-AZ setup based on [Scenario 1](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario1.html) from the VPC User Guide, which consists of one *public subnet* and one Internet Gateway.
  * `aws/vpc/natted`: single-AZ VPC setup based on [Scenario 2](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario2.html) from the VPC User Guide, which consists of two subnets (public and private subnet), one Internet Gateway, one EC2 instance as a NAT (_not_ a dedicated gateway), and a routing table.
  * `aws/vpc/natted-dedicated`: a setup similar to `aws/vpc/natted`, with a dedicated NAT gateway instead of an EC2 instance.
