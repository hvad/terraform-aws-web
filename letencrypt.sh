#!/bin/bash                                                                                                                                                                              
                                                                                                                                                                                         
# Stop Apache Http 
if ps ax | grep -v grep | grep httpd > /dev/null                                                                                                                                         
then                                                                                                                                                                                     
    echo "Stopping Apache server."                                                                                                                                                         
    systemctl stop httpd 1 > /dev/null 2>&1                                                                                                                                                
fi                                                                                                                                                                                       
                                                                                                                                                                                         
## Generate SSL/TLS certificate                                                                                                                                                           
certbot certonly \
    --non-interactive \
    --email EMAIL \
    --preferred-challenges http \
    --standalone \
    --agree-tos \
    --renew-by-default \
    --webroot-path /var/www/html/DOMAIN \
    -d DOMAIN -d www.DOMAIN
                                                                                                                                                                                         
# Start Apache Http                                                                                                                                                                      
echo "Starting Apache server."                                                                                                                                                           
systemctl start httpd      
