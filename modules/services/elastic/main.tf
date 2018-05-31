#jaarsv2/modules/services/elastic/main.tf

data "aws_ecs_task_definition" "app_task" {
  task_definition       = "${aws_ecs_task_definition.app_task.family}"
  depends_on            = ["aws_ecs_task_definition.app_task"]
}

resource "aws_ecs_task_definition" "app_task" {
  family                = "${var.app_name}-${var.app_env}"
  container_definitions = "${file("${path.module}/elasticsearch.json")}"
  volume {
    name                = "elastic-container-vol"
    host_path           = "/data"
  }
}

resource "aws_ecs_service" "app_svc" {
  name                  = "svc-${var.app_name}-${var.app_env}"
  cluster               = "${var.cluster}"
  task_definition       = "${aws_ecs_task_definition.app_task.arn}"
  desired_count         = 2

  load_balancer {
    elb_name            = "${var.internal_elb_name}"
#    target_group_arn    = "${var.target_group_arn}"
    container_name      = "elasticsearch"
    container_port      = 9200
    }
}
