#!/bin/bash

for file in slate-config/*; do
        if [[ $(stat -c %U $file) != root ]]; then
                echo "Fixing ownership of $file."
                sudo chown root:root $file
        fi
        if [[ $(stat -c %a $file) != 600 ]]; then
                echo "Fixing permissions of $file."
                sudo chmod 600 $file
        fi
done
docker-compose up -d
echo "Waiting for systemd to start up..."
sleep 10
docker-compose exec kube ./init.sh
docker-compose exec slate helm init --service-account tiller
docker-compose exec slate pip install -r /opt/slate-portal/requirements.txt
docker-compose exec slate sh -c "sed -i 's/localhost/0\.0\.0\.0/g' /opt/slate-portal/run_*"
docker-compose exec -d slate /bin/sh -c "cd /opt/slate-portal && ./run_portal.py"
