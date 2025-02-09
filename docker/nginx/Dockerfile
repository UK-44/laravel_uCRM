FROM nginx:alpine

# default.conf (Nginx設定ファイル) を配置(web appにデプロイするとエラーになる)
COPY /docker/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
