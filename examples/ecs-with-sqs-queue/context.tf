module "context" {
  source = "../.."

  environment = "testing"
  namespace   = "ecs"

  labels = {
    ecs_cluster = {
      id     = "cluster"
      region = "global"
    }
    ecs_service = {
      id     = "foxtrot"
      region = "us-east-2"
      unit   = "butterfly"
    }
  }

  tags = {
    IsTerraformed = true
    Environment   = "Testing"
    Unit          = "Containers"
  }
}