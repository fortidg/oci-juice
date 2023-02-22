# Juice-Shop in OCI

This is a simple Terraform template to deploy a VCN and subnet in OCI, with a single Ubuntu 20.04 VM.  The VM is given a public IP address and a security list is applied allowing TCP port 3000 from whatever source IP address space you assign.  It is **NOT** recommended to deploy Juice Shop with a Public IP accessible to the entire internet.  This is for use with a SaaS WAF proxy.  You **MUST** lock down ingress traffic.  In a production deployment it is also **Highly** recommended that you pass all egress traffic through a Next Generation Firewall with appropriate security controls.

* The Source address must be given in standard CIDR notation, meaning that if you are using the Public IP assigned to your computer you you would input x.x.x.x/32.

* I am passing the required OCI credentials into Terraform using environment variables.  The process for setting that up can be found at the below link.
     <https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm>

* In order to run this, you can use

```sh
terrafrom init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

* More information about Juice Shop can be found at:
     <https://owasp.org/www-project-juice-shop/>
