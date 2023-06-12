terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

# Configure the TencentCloud Provider
provider "tencentcloud" {
  secret_id  = "AKIDM*******"
  secret_key = "Tlut********"
  region     = "ap-shanghai"
}

resource "tencentcloud_vpc" "foo" {
  name         = "ci-temp-test-updated"
  cidr_block   = "10.0.0.0/16"
  dns_servers  = ["119.29.29.29", "8.8.8.8"]
  is_multicast = false

  tags = {
    "test" = "test"
  }
}


variable "availability_zone" {
  default = "ap-shanghai-4"
}

resource "tencentcloud_subnet" "foo" {
  vpc_id            = tencentcloud_vpc.foo.id
  availability_zone = var.availability_zone
  name              = "awesome_app_subnet"
  cidr_block        = "10.0.1.0/24"
}


data "tencentcloud_instance_types" "foo" {
  availability_zone = "ap-shanghai-4"
  cpu_core_count    = 2
  memory_size       = 4
}

// Create 2 CVM instances to host awesome_app
resource "tencentcloud_instance" "my_awesome_app" {
  instance_name     = "awesome_app"
  availability_zone = var.availability_zone
  image_id          = "img-eb30mz89"
  instance_type     = data.tencentcloud_instance_types.foo.instance_types.0.instance_type
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "user"
  project_id        = 0
  vpc_id            = tencentcloud_vpc.foo.id
  subnet_id         = tencentcloud_subnet.foo.id
  count             = 2

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
}