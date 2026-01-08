#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done

export ZONE=$(gcloud compute project-info describe \
    --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe \
    --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud artifacts repositories create docker-repo \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository" \
    --project=$DEVSHELL_PROJECT_ID || {
    echo ""
    exit 1
}

wget -q https://storage.googleapis.com/spls/gsp1024/flask_telemetry.zip || {
    echo ""
    exit 1
}
unzip -q flask_telemetry.zip

docker load -i flask_telemetry.tar || {
    echo ""
    exit 1
}

docker tag gcr.io/ops-demo-330920/flask_telemetry:61a2a7aabc7077ef474eb24f4b69faeab47deed9 \
    $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/docker-repo/flask-telemetry:v1 || {
    echo ""
    exit 1
}

docker push $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/docker-repo/flask-telemetry:v1 || {
    echo ""
    exit 1
}

gcloud beta container clusters create gmp-cluster \
    --num-nodes=1 \
    --zone $ZONE \
    --enable-managed-prometheus || {
    echo ""
    exit 1
}

gcloud container clusters get-credentials gmp-cluster --zone $ZONE || {
    echo ""
    exit 1
}

kubectl create ns gmp-test || {
    echo ""
    exit 1
}

wget -q https://storage.googleapis.com/spls/gsp1024/gmp_prom_setup.zip || {
    echo ""
    exit 1
}
unzip -q gmp_prom_setup.zip
cd gmp_prom_setup || {
    echo ""
    exit 1
}

sed -i "s|<ARTIFACT REGISTRY IMAGE NAME>|$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/docker-repo/flask-telemetry:v1|g" flask_deployment.yaml || {
    echo ""
    exit 1
}

kubectl -n gmp-test apply -f flask_deployment.yaml || {
    echo ""
    exit 1
}

kubectl -n gmp-test apply -f flask_service.yaml || {
    echo ""
    exit 1
}

url=$(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')

kubectl -n gmp-test apply -f prom_deploy.yaml || {
    echo ""
    exit 1
}

timeout 120 bash -c -- 'while true; do curl -s $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}') >/dev/null; sleep $((RANDOM % 4)); done' &

gcloud monitoring dashboards create --config='''
{
  "category": "CUSTOM",
  "displayName": "Prometheus Dashboard Example",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "prometheus/flask_http_request_total/counter [MEAN]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"prometheus.googleapis.com/flask_http_request_total/counter\" resource.type=\"prometheus_target\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "metric.label.\"status\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 0,
        "yPos": 0
      }
    ]
  }
}
''' || {
    echo ""
}

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
