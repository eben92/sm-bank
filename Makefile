# Simple Makefile for a Go project

# Build the application
all: build

build:
	@echo "Building..."
	@go build -o main cmd/api/main.go

# Run the application
run:
	@go run cmd/api/main.go

# Create DB container
docker-run:
	@if docker compose up 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose up; \
	fi

# Shutdown DB container
docker-down:
	@if docker compose down 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose down; \
	fi

# Test the application
test:
	@echo "Testing..."
	@go test -v -cover ./...
	@echo "Tests complete!"	
	

# Clean the binary
clean:
	@echo "Cleaning..."
	@rm -f main

sqlc: 
	@echo "Generating..."
	@sqlc generate
	@echo "Generated!"

migrateup:
	@echo "Migrating..."
	@migrate -path ./internal/database/migration -database "postgresql://postgres:postgres@localhost:5432/bank?sslmode=disable" -verbose up
	@echo "Migration complete!"

migratedown:
	@echo "Rolling back..."
	@migrate -path ./internal/database/migration -database "postgresql://postgres:postgres@localhost:5432/bank?sslmode=disable" -verbose down
	@echo "Rollback complete!"

# Live Reload
watch:
	@if command -v air > /dev/null; then \
	    air; \
	    echo "Watching...";\
	else \
	    read -p "Go's 'air' is not installed on your machine. Do you want to install it? [Y/n] " choice; \
	    if [ "$$choice" != "n" ] && [ "$$choice" != "N" ]; then \
	        go install github.com/cosmtrek/air@latest; \
	        air; \
	        echo "Watching...";\
	    else \
	        echo "You chose not to install air. Exiting..."; \
	        exit 1; \
	    fi; \
	fi

.PHONY: all build run test clean


# docker db stuff
createdb:
	@echo "Creating database..."
	@docker exec -it postgres psql -U postgres postgres -c "CREATE DATABASE bank;"
	@echo "Database created!"

dropdb:
	@echo "Dropping database..."
	@docker exec -it postgres psql -U postgres postgres -c "DROP DATABASE bank;"
	@echo "Database dropped!"	