resource "oci_core_instance" "vm-b" {
  depends_on = [oci_core_subnet.hb_subnet]
  availability_domain = data.oci_identity_availability_domain.ad-b.name
  compartment_id      = var.compartment_ocid
  display_name        = "vm-b"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.mgmt_subnet.id
    display_name     = "vm-b"
    assign_public_ip = true
    hostname_label   = "vmb"
    private_ip       = var.mgmt_private_ip_primary_b
  }

  source_details {
    source_type = "image"
    source_id   = var.vm_image_ocid

    //for PIC image: source_id   = var.vm_image_ocid

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true


  //required for metadata setup via cloud-init
    metadata = {
      ssh_authorized_keys = var.ssh_public_key
      user_data           = base64encode(data.template_file.vm-b_userdata.rendered)
    }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_vnic_attachment" "vnic_attach_untrust_b" {
  depends_on = [oci_core_instance.vm-b]
  instance_id  = oci_core_instance.vm-b.id
  display_name = "vnic_untrust_b"

  create_vnic_details {
    subnet_id              = oci_core_subnet.untrust_subnet.id
    display_name           = "vnic_untrust_b"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.untrust_private_ip_primary_b
  }
}


resource "oci_core_vnic_attachment" "vnic_attach_trust_b" {
  depends_on = [oci_core_vnic_attachment.vnic_attach_untrust_b]
  instance_id  = oci_core_instance.vm-b.id
  display_name = "vnic_trust"

  create_vnic_details {
    subnet_id              = oci_core_subnet.trust_subnet.id
    display_name           = "vnic_trust_b"
    assign_public_ip       = false
    skip_source_dest_check = true
    private_ip             = var.trust_private_ip_primary_b
  }
}


resource "oci_core_vnic_attachment" "vnic_attach_hb_b" {
  depends_on = [oci_core_vnic_attachment.vnic_attach_trust_b]
  instance_id  = oci_core_instance.vm-b.id
  display_name = "vnic_hb_b"

  create_vnic_details {
    subnet_id              = oci_core_subnet.hb_subnet.id
    display_name           = "vnic_hb_b"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.hb_private_ip_primary_b
  }
}


data "template_file" "vm-b_userdata" {
  template = file(var.bootstrap_vm-b)
  
  vars = {
    localip = var.ipsec_vm_b_localip
    leftid = var.ipsec_vm_b_leftid
    leftsubnet = var.ipsec_vm_b_leftsubnet
    right = var.ipsec_vm_b_right
    rightid = var.ipsec_vm_b_rightid
    rightsubnet = var.ipsec_vm_b_rightsubnet
    P1props = var.ipsec_vm_b_P1props
    P1life = var.ipsec_vm_b_P1life
    P2props = var.ipsec_vm_b_P2props
    P2life = var.ipsec_vm_b_P2life
    PSK = var.ipsec_vm_b_PSK
  }
}
