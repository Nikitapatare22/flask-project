provider "google" {
  project = var.project_id
  region  = var.region
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  network    = "default"
  subnetwork = "default"
  initial_node_count = 1
  deletion_protection = false
  node_config {
    machine_type = var.node_machine_type
    service_account = "910142583198-compute@developer.gserviceaccount.com"
    disk_size_gb = 10
    disk_type = "pd-ssd"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Compute instance
resource "google_compute_instance" "instance_with_all_ports" {
  name         = "slave"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["flask-server"] 

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}  
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y python3-pip
      pip3 install flask
      python3 /path/to/your/app.py &  # Adjust the path as needed
    EOT
  }
}

# Firewall rule for instance
resource "google_compute_firewall" "allow_flask" {
  name    = "allow-flask"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["flask-server"]  # Updated: target the correct tag
}
