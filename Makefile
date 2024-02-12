run:
	@docker compose down
	@docker compose up

bash:
	@docker compose exec app bash

clean:
	@docker compose down
	@docker system prune --volumes --force
	@docker network prune