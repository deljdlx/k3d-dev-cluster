<!doctype html>
<html>
    <head>
        <title>Cluster Informations</title>
        <style>
            * {
                box-sizing: border-box;
            }
            body {
                font-family: Arial, sans-serif;
            }
            section {
                margin-bottom: 20px;
            }
            textarea {
                width: 100%;
                height: 200px;
                border: 1px solid #000;
                padding: 8px;
            }

        </style>
    </head>

    <body>
        <h1>Cluster Informations</h1>

        <section>
            <h2>Ingress list</h2>
            <?php
                $ingress = file(__DIR__ . '/../ingress.txt');
                foreach($ingress as $url) {
                    echo '<ul>';
                        echo sprintf('<li><a href="https://%s" target="_blank">%s</a></li>', $url, $url);
                    echo '</ul>';
                }
            ?>
        </section>
        <section>
            <h2>Code server informations</h2>
            <pre><?php
                echo file_get_contents(__DIR__ . '/../code-server-config.txt');
            ?></pre>
        </section>

        <section>
            <h2>Kubernetes dashboard token</h2>
            <textarea readonly onFocus="this.select()"><?php
                echo file_get_contents(__DIR__ . '/../kubernetes-dashboard-token.txt');
            ?></textarea>
        </section>


        <section>
            <h2>Grafana</h2>
            <h3>Recommended dashboards</h3>
            <ul>
                <li>
                    <input readonly value="15661" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/15661-k8s-dashboard-en-20250125/" target="_blank">K8S Dashboard EN 20250125</a>
                </li>
                <li>
                    <input readonly value="159" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/159-prometheus-system/" target="_blank">Prometheus system</a>
                </li>
                <li>
                    <input readonly value="17501" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/17501-traefik-via-loki/" target="_blank">Traefik On K8s Via Loki</a>
                </li>
                <li>
                    <input readonly value="13639" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/13639-logs-app/" target="_blank">Simple loki log viewer</a>
                </li>
                <li>
                    <input readonly value="15141" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/15141-kubernetes-service-logs/" target="_blank">Loki Kubernetes Logs</a>
                </li>
                <li>
                    <input readonly value="14057" onFocus="this.select()" class="grafana-dashboard-id"/>
                    <a href="https://grafana.com/grafana/dashboards/14057-mysql/" target="_blank">MySQL Dashboard</a>
                </li>
            </ul>






    </body>

</html>