#!/bin/bash

sudo systemctl enable docker

mkdir -p /tmp/www/healthcheck
cd /tmp/www

cat <<EOT >> /tmp/www/index.html
<<!DOCTYPE html>
 <html>
 <body>
 <h1 align="center" style="font-family:verdana;">An HTML whatch</h1>
 <div id="txt" align="center" style="font-family:verdana;">
 <canvas id="canvas" width="400" height="400" align="center">
 </canvas>
 </div>
 <div id="txt" align="right" style="font-family:verdana;">
 Version 0.1
 </div>
 <script>
 var canvas = document.getElementById("canvas");
 var ctx = canvas.getContext("2d");
 var radius = canvas.height / 2;
 ctx.translate(radius,radius);
 radius = radius * 0.90;
 setInterval(drawClock, 1000);

 function drawClock(){
   drawFace(ctx, radius);
   drawNumbers(ctx, radius);
   drawTime(ctx, radius);
 }

 function drawFace(ctx, radius){
   var grad;

   ctx.beginPath();
   ctx.arc(0, 0, radius, 0, 2*Math.PI);
   ctx.fillStyle = "powderblue";
   ctx.fill();


   grad = ctx.createRadialGradient(0, 0, radius*0.65, 0, 0, radius*1.35);
   grad.addColorStop(0, '#000');
   grad.addColorStop(0.5, '#FFF');
   grad.addColorStop(1, '#FFF');
   ctx.strokeStyle = grad;
   ctx.lineWidth = radius*0.2;
   ctx.stroke();

   ctx.beginPath();
   ctx.arc(0, 0, radius*0.05, 0, 2*Math.PI);
   ctx.fillStyle = "white";
   ctx.fill();
 }

 function drawNumbers(ctx, radius) {
   var ang;
   var num;
   ctx.font = radius*0.15 + "px arial";
   ctx.textBaseline="middle";
   ctx.textAlign="center";
   for(num= 1; num < 13; num++){
     ang = num * Math.PI / 6;
     ctx.rotate(ang);
     ctx.translate(0, -radius*0.80);
     ctx.rotate(-ang);
     ctx.fillText(num.toString(), 0, 0);
     ctx.rotate(ang);
     ctx.translate(0, radius*0.80);
     ctx.rotate(-ang);
   }
 }

 function drawTime(ctx, radius) {
   var now = new Date();
   var hour = now.getHours();
   var minute = now.getMinutes();
   var second = now.getSeconds();
   //hour
   hour=hour%12;
   hour=(hour*Math.PI/6)+(minute*Math.PI/(6*60))+(second*Math.PI/(360*60));
   drawHand(ctx, hour, radius*0.4, radius*0.07);
   //minute
   minute=(minute*Math.PI/30)+(second*Math.PI/(30*60));
   drawHand(ctx, minute, radius*0.6, radius*0.07);
   // second
   second=(second*Math.PI/30);
   drawHand(ctx, second, radius*0.75, radius*0.02);
 }

 function drawHand(ctx, pos, length, width) {
     ctx.beginPath();
     ctx.lineWidth = width;
     ctx.lineCap = "round";
     ctx.moveTo(0,0);
     ctx.rotate(pos);
     ctx.lineTo(0, -length);
     ctx.stroke();
     ctx.rotate(-pos);
 }
 </script>

 </body>
 </html>
EOT

echo "Healthcheck ok!" > /tmp/www/healthcheck/hc.html

sudo cat <<EOT >> /etc/systemd/system/mywebapp.service
[Unit]
Description=MyWebApp
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=/usr/bin/docker pull nginx
ExecStart=/usr/bin/docker run -d --name nginx_web_server -p 80:80 -v /tmp/www:/usr/share/nginx/html:ro  nginx

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl enable /etc/systemd/system/mywebapp.service
sudo systemctl start mywebapp.service