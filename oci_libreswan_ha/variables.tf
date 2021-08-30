provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
    region           = var.region
    version          = 3.66
}
    
variable "tenancy_ocid" {
  default = "ocid1.tenancy.oc1..aaaaaaaa"
}
variable "compartment_ocid" {
  default = "ocid1.compartment.oc1..aaaaaaaa"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAA"
}
variable "region" {
  default = "uk-london-1"
}


##VCN and SUBNET ADDRESSESS
variable "vcn_cidr" {
  default = "192.168.111.0/24"
}

variable "mgmt_subnet_cidr" {
  default = "192.168.111.80/28"
}

variable "mgmt_subnet_gateway" {
  default = "192.168.111.81"
}


variable "untrust_subnet_cidr" {
  default = "192.168.111.0/27"
}

variable "untrust_subnet_gateway" {
  default = "192.168.111.1"
}

variable "untrust_public_ip_lifetime" {
  default = "RESERVED"
  //or EPHEMERAL
}


variable "trust_subnet_cidr" {
  default = "192.168.111.32/27"
}

variable "trust_subnet_gateway" {
  default = "192.168.111.33"
}

variable "hb_subnet_cidr" {
  default = "192.168.111.64/28"
}


#FIREWALL IPs

#FLOATING/FAILOVER
variable "untrust_floating_private_ip" {
  default = "192.168.111.10"
}

variable "trust_floating_private_ip" {
  default = "192.168.111.40"
}


#ACTIVE NODE
variable "mgmt_private_ip_primary_a" {
  default = "192.168.111.85"
}

variable "untrust_private_ip_primary_a" {
  default = "192.168.111.5"
}

variable "trust_private_ip_primary_a" {
  default = "192.168.111.35"
}

variable "hb_private_ip_primary_a" {
  default = "192.168.111.75"
}

#PASSIVE NODE
variable "mgmt_private_ip_primary_b" {
  default = "192.168.111.86"
}

variable "untrust_private_ip_primary_b" {
  default = "192.168.111.6"
}

variable "trust_private_ip_primary_b" {
  default = "192.168.111.36"
}

variable "hb_private_ip_primary_b" {
  default = "192.168.111.76"
}




variable "vm_image_ocid" {
	//Marketplace Image 6.2.5: ocid1.image.oc1..aaaaaaaar23fvwn7vie6lnwbdpqhohsiojj4oeqdmqpdvpdjm7glncxailxa
	//Marketplace Image 6.4.4: ocid1.image.oc1..aaaaaaaauxqbpkvj3uabe7efecnk75mmaui7lvzif6yckhplblm4sfirygwq
	//Or Replace OCID with custom Image OCID
  //Default = Marketplace Image 6.2.5
  // default = "ocid1.image.oc1..aaaaaaaar23fvwn7vie6lnwbdpqhohsiojj4oeqdmqpdvpdjm7glncxailxa"//
	
  //Oracle-Linux-8.4-2021.07.27-0
	
   default = "ocid1.image.oc1.uk-london-1.aaaaaaaa7fgs4dpcjkkeemyfzyo3yo5lezqfskac45dblmgnfq5az4jmgcza"
}

// variable "vm_image_ocid" {
//  type = "map"

//  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // FortiGate-6.0.3-emulated"
	// Example:
//    us-ashburn-1="ocid1.image.oc1.iad.aaaaaaaawp3jbcejr5w7mgeuodeotmvwm36g7csiymvxd6nfesz2dj4hpq4q"
//  }
//}

variable "instance_shape" {
  default = "VM.Standard2.4"
}

# Choose an Availability Domain (1,2,3)
variable "availability_domain-a" {
  default = "1"
}

variable "availability_domain-b" {
  default = "2"
}

variable "volume_size" {
  default = "50" //GB
}

variable "bootstrap_vm-a" {
  default = "./userdata/bootstrap_vm-a.sh"
}

variable "bootstrap_vm-b" {
 default = "./userdata/bootstrap_vm-a.sh"
}
### IPSEC LIBRESWAN CONFIG VM A  ###

variable "ipsec_vm_a_localip" {
 default = "192.168.111.5"
}

variable "ipsec_vm_a_leftid" {
 default = "9.8.7.6"
}

variable "ipsec_vm_a_leftsubnet" {
 default = "192.168.111.0/24"
}

variable "ipsec_vm_a_right" {
 default = "1.2.3.4"
}

variable "ipsec_vm_a_rightid" {
 default = "1.2.3.4"
}

variable "ipsec_vm_a_rightsubnet" {
 default = "10.0.0.0/8"
}
variable "ipsec_vm_a_P1props" {
 default = "aes_cbc256-sha2_384;modp1536"
}
variable "ipsec_vm_a_P1life" {
 default = "28800s"
}
variable "ipsec_vm_a_P2props" {
 default = "aes256-sha1-modp1536"
}
variable "ipsec_vm_a_P2life" {
 default = "3600s"
}
variable "ipsec_vm_a_PSK" {
 default = "'Cem6mIexuYuXQRIYnZ9jLue'"
}

### IPSEC LIBRESWAN CONFIG VM B  ###
variable "ipsec_vm_b_localip" {
 default = "192.168.111.6"
}
variable "ipsec_vm_b_leftid" {
 default = "9.8.7.6"
}
variable "ipsec_vm_b_leftsubnet" {
 default = "192.168.111.0/24"
}
variable "ipsec_vm_b_right" {
 default = "5.6.7.8"
}
variable "ipsec_vm_b_rightid" {
 default = "5.6.7.8"
}
variable "ipsec_vm_b_rightsubnet" {
 default = "10.0.0.0/8"
}
variable "ipsec_vm_b_P1props" {
 default = "aes_cbc256-sha2_384;modp1536"
}
variable "ipsec_vm_b_P1life" {
 default = "28800s"
}
variable "ipsec_vm_b_P2props" {
 default = "aes256-sha1-modp1536"
}
variable "ipsec_vm_b_P2life" {
 default = "3600s"
}
variable "ipsec_vm_b_PSK" {
 default = "'Cem6thxghfghfghfghxfgnZ9jLue'"
}
