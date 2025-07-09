.PHONY: frontend backend

frontend:
	cd frontend && nix develop --command make

backend:
	cd backend && nix develop --command make
