run:
	@docker compose up

clean:
	@docker compose down
	@docker system prune --volumes --force
	@docker network prune