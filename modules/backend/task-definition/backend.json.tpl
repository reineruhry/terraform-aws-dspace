[
  {
    "name"  : "pgcrypto",
    "image" : "postgres:latest",
    "networkMode": "${network_mode}",
    "essential": false,
    "memoryReservation": 32,
    "command" : [
      "/bin/sh",
      "-c",
      "psql -c \"CREATE EXTENSION pgcrypto;\" || true"
    ],
    "environment": [
      {
        "name" : "PGDATABASE",
        "value" : "${db_name}"
      },
      {
        "name" : "PGHOST",
        "value" : "${db_host}"
      }
    ],
    "secrets": [
      {
        "name" : "PGPASSWORD",
        "valueFrom" : "${db_password_arn}"
      },
      {
        "name" : "PGUSER",
        "valueFrom" : "${db_username_arn}"
      }
    ]
  },
  {
    "name": "backend",
    "image": "${img}",
    "networkMode": "${network_mode}",
    "essential": true,
    "memoryReservation": ${memory},
    "entrypoint": [
      "/bin/bash",
      "-c",
      "${join(" ", [
        "${dspace_dir}/bin/dspace database migrate;",
        "catalina.sh run"
      ])}"
    ],
    "environment": [
      {
        "name": "db__P__url",
        "value": "${db_url}"
      },
      {
        "name": "dspace__P__dir",
        "value": "${dspace_dir}"
      },
      {
        "name": "dspace__P__hostname",
        "value": "${host}"
      },
      {
        "name": "dspace__P__name",
        "value": "${name}"
      },
      {
        "name": "dspace__P__server__P__url",
        "value": "${backend_url}"
      },
      {
        "name": "dspace__P__ui__P__url",
        "value": "${frontend_url}"
      },
      {
        "name": "solr__P__server",
        "value": "${solr_url}"
      },
      {
        "name": "TZ",
        "value": "${timezone}"
      }
    ],
    "secrets": [
      {
        "name": "db__P__password",
        "valueFrom": "${db_password_arn}"
      },
      {
        "name": "db__P__username",
        "valueFrom": "${db_username_arn}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${name}",
        "containerPath": "${dspace_dir}/assetstore"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${name}"
      }
    }
  }
]
