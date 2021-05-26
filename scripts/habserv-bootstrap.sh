
#!/usr/bin/env bash


# get and install hab

curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
hab license accept
sudo groupadd hab
sudo useradd -g hab hab



# add ssl certs etc from automate
sudo cp /opt/mysync/automate.cert /hab/cache/ssl/automate.cert




habcommand="sudo hab sup run core/artifactory \
       --event-stream-application='my-app' \
       --event-stream-environment='alpha' \
       --event-stream-site='supertest' \
       --event-stream-url='chef-automate.test:4222' \
       --event-stream-token='KGN0YhXlXhQwhFxTnXLTPhfObKs='"


# add to run on startup
sudo crontab -l | { cat; echo "@reboot ${habcommand}"; } | sudo crontab 

# and trigger for first run
echo "${habcommand}" | at now + 1 minutes