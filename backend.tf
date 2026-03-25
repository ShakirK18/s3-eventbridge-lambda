terraform {
  backend "s3" {
    bucket       = "tfstate-shakir"
    key          = "s3-eventbridge-lambda.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}