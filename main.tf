resource "confluent_environment" "sandbox" {
  display_name = "Sandbox"
}

resource "confluent_network" "aws-peering" {
  display_name     = "AWS Peering Network"
  cloud            = "AWS"
  region           = "us-east-1"
  cidr             = "172.27.0.0/16"
  connection_types = ["TRANSITGATEWAY"]
  environment {
    id = confluent_environment.sandbox.id
  }
}

resource "confluent_peering" "aws" {
  display_name = "AWS Peering"
  aws {
    account         = "784364363154"
    vpc             = "vpc-bd6804c0"
    routes          = ["172.31.0.0/16"]
    customer_region = "us-east-1"
  }
  environment {
    id = confluent_environment.sandbox.id
  }
  network {
    id = confluent_network.aws-peering.id
  }
}

resource "confluent_kafka_cluster" "dedicated-clusters" {
  display_name = "dedicated_kafka_cluster"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = "us-east-1"
  dedicated {
    cku = 2
  }
  environment {
    id = confluent_environment.sandbox.id
  }
  network {
    id = confluent_network.aws-peering.id
  }
}

