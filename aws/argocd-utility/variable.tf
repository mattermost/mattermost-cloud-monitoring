variable "utilities" {
  description = "The list of utilities"
  type = map(object({
    name = string
    type = string
  }))
}