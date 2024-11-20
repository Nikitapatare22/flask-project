
# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "nikita1-441604"
}

variable "region" {
  description = "GCP region for the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the instance"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "node_machine_type" {
  description = "Machine type for the GKE node pool"
  type        = string
  default     = "e2-medium"
}
