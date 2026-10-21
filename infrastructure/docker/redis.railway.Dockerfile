FROM redis:7.4-alpine
COPY infrastructure/docker/redis-start.sh /usr/local/bin/staging-redis-start
RUN chmod +x /usr/local/bin/staging-redis-start
CMD ["/usr/local/bin/staging-redis-start"]
