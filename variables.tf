variable "nginx_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "image_tag" {
  description = "The image that will be used in the application"
  type        = string
  default     = "nginx:1.7.8"
}
