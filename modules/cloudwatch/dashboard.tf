data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "service_health" {
  dashboard_name = "${var.name_prefix}-operations"

  dashboard_body = jsonencode({
    start          = "-PT3H"
    periodOverride = "inherit"

    widgets = [
      # ------------------------------------------------------------------
      # Alarm status
      # ------------------------------------------------------------------
      {
        type   = "alarm"
        x      = 0
        y      = 0
        width  = 24
        height = 4

        properties = {
          title = "Service Health — Alarm Status"

          alarms = [
            aws_cloudwatch_metric_alarm.ecs_cpu_high.arn,
            aws_cloudwatch_metric_alarm.ecs_memory_high.arn,
            aws_cloudwatch_metric_alarm.alb_no_healthy_targets.arn,
            aws_cloudwatch_metric_alarm.alb_target_5xx.arn,
            aws_cloudwatch_metric_alarm.alb_elb_5xx.arn,
            aws_cloudwatch_metric_alarm.alb_latency_high.arn,
            aws_cloudwatch_metric_alarm.rds_cpu_high.arn,
            aws_cloudwatch_metric_alarm.rds_free_storage_low.arn,
            aws_cloudwatch_metric_alarm.rds_freeable_memory_low.arn,
            aws_cloudwatch_metric_alarm.rds_cpu_surplus_credits_charged.arn
          ]
        }
      },

      # ------------------------------------------------------------------
      # Service availability
      # ------------------------------------------------------------------
      {
        type   = "metric"
        x      = 0
        y      = 4
        width  = 8
        height = 5

        properties = {
          title     = "Healthy ALB Targets"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 60
          sparkline = true

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix,
              {
                stat = "Minimum"
              }
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 8
        y      = 4
        width  = 8
        height = 5

        properties = {
          title     = "Unhealthy ALB Targets"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 60
          sparkline = true

          metrics = [
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix,
              {
                stat = "Maximum"
              }
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 16
        y      = 4
        width  = 8
        height = 5

        properties = {
          title     = "ECS Live Tasks"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 60
          sparkline = true

          metrics = [
            [
              "AWS/ECS",
              "LiveTaskCount",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name,
              {
                stat = "Minimum"
              }
            ]
          ]
        }
      },

      # ------------------------------------------------------------------
      # Traffic & performance
      # ------------------------------------------------------------------
      {
        type   = "metric"
        x      = 0
        y      = 9
        width  = 12
        height = 6

        properties = {
          title  = "Traffic — Requests"
          view   = "timeSeries"
          region = data.aws_region.current.region
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix,
              {
                stat  = "Sum"
                label = "Requests"
              }
            ]
          ]

          legend = {
            position = "bottom"
          }
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 9
        width  = 12
        height = 6

        properties = {
          title  = "Performance — p95 Response Time"
          view   = "timeSeries"
          region = data.aws_region.current.region
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix,
              {
                stat  = "p95"
                label = "p95 response time"
              }
            ]
          ]

          legend = {
            position = "bottom"
          }

          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },

      # ------------------------------------------------------------------
      # HTTP errors
      # ------------------------------------------------------------------
      {
        type   = "metric"
        x      = 0
        y      = 15
        width  = 12
        height = 5

        properties = {
          title     = "Errors — Vaultwarden Target 5xx"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 300
          sparkline = true

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix,
              {
                stat  = "Sum"
                label = "Target 5xx"
              }
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 15
        width  = 12
        height = 5

        properties = {
          title     = "Errors — ALB 5xx"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 300
          sparkline = true

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              {
                stat  = "Sum"
                label = "ALB 5xx"
              }
            ]
          ]
        }
      },

      # ------------------------------------------------------------------
      # ECS resources
      # ------------------------------------------------------------------
      {
        type   = "metric"
        x      = 0
        y      = 20
        width  = 12
        height = 6

        properties = {
          title  = "ECS — Resource Utilization"
          view   = "timeSeries"
          region = data.aws_region.current.region
          period = 60

          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name,
              {
                stat  = "Average"
                label = "CPU"
              }
            ],
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name,
              {
                stat  = "Average"
                label = "Memory"
              }
            ]
          ]

          legend = {
            position = "bottom"
          }

          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },

      # ------------------------------------------------------------------
      # RDS health
      # ------------------------------------------------------------------
      {
        type   = "metric"
        x      = 12
        y      = 20
        width  = 12
        height = 6

        properties = {
          title     = "RDS — Health"
          view      = "singleValue"
          region    = data.aws_region.current.region
          period    = 300
          sparkline = true

          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.db_instance_identifier,
              {
                stat  = "Average"
                label = "CPU utilization"
              }
            ],
            [
              "AWS/RDS",
              "FreeableMemory",
              "DBInstanceIdentifier",
              var.db_instance_identifier,
              {
                stat  = "Average"
            label = "Freeable memory"
          }
        ],
        [
          "AWS/RDS",
          "DatabaseConnections",
          "DBInstanceIdentifier",
          var.db_instance_identifier,
          {
            stat  = "Average"
            label = "DB connections"
          }
        ],
        [
          "AWS/RDS",
          "FreeStorageSpace",
          "DBInstanceIdentifier",
          var.db_instance_identifier,
          {
            stat  = "Minimum"
            label = "Free storage"
          }
        ],
        [
          "AWS/RDS",
          "SwapUsage",
          "DBInstanceIdentifier",
          var.db_instance_identifier,
          {
            stat  = "Average"
            label = "Swap usage"
          }
        ]
      ]
    }
  },

  {
    type   = "log"
    x      = 0
    y      = 26
    width  = 24
    height = 6

    properties = {
      title  = "Vaultwarden — Recent WARN / ERROR Logs"
      region = data.aws_region.current.region
      view   = "table"

      query = join("\n", [
        "SOURCE '/ecs/vaultwarden-prod'",
        "| fields @timestamp, @message, @logStream",
        "| filter @message like /(?i)(error|warn|warning|fatal|panic)/",
        "| sort @timestamp desc",
        "| limit 50"
      ])
    }
  },
  {
    type   = "log"
    x      = 0
    y      = 32
    width  = 24
    height = 6

    properties = {
      title  = "PostgreSQL — Recent Errors"
      region = data.aws_region.current.region
      view   = "table"

      query = join("\n", [
        "SOURCE '/aws/rds/instance/vaultwarden-prod-postgres/postgresql'",
        "| fields @timestamp, @message",
        "| filter @message like /(?i)(error|fatal|panic|deadlock|out of memory)/",
        "| sort @timestamp desc",
        "| limit 50"
      ])
    }
  }
]
  })
}