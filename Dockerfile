# Website Cong Thuc Nau An - Recipe (De tai 29: Website Cong thuc nau an / Recipe)
FROM nginxinc/nginx-unprivileged:1.27-alpine

# Copy static website (ung dung web chay trong container nginx)
COPY index.html /usr/share/nginx/html/index.html
COPY detail.html /usr/share/nginx/html/detail.html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
