#jaarsv2/modules/services/with-elb-no-volume/main.tf

data "aws_ecs_task_definition" "app_task" {
  task_definition       = "${aws_ecs_task_definition.app_task.family}"
  depends_on            = ["aws_ecs_task_definition.app_task"]
}

resource "aws_ecs_task_definition" "app_task" {
  family                = "${var.app_name}-${var.app_env}"
  container_definitions = "${var.container_def_json}"
  }

resource "aws_ecs_service" "app_svc" {
  name                  = "svc-${var.app_name}-${var.app_env}"
  cluster               = "${var.cluster}"
  task_definition       = "${aws_ecs_task_definition.app_task.arn}"
  desired_count         = "${var.desired_count}"

  load_balancer {
    elb_name            = "${var.elb_name}"
    container_name      = "${var.container_name}"
    container_port      = "${var.container_port}"
    }
}
