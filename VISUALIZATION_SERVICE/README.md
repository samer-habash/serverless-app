This is a simple YAML files to visualiz the RDS Tables instance in grafana. 

1. Please apply at first the configMap for Mysql datasource :
    
        ~ kubectl apply -f grafana-configMap.yaml

2. Then please install the grafana with the values.yaml :

By default the persistence is enabled, so you must enabled in order not to loose data if the pod is terminated.

        ~ helm upgrade --install grafana stable/grafana -f grafana-values.yaml


3. After successful installation you can apply the json file which simply output the
rds tables (the json has 4 dashboards)

